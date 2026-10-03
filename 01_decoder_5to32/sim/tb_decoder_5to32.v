`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module tb_decoder_5to32;

    // Test Bench Sinyalleri (UUT Girisleri -> reg. Cikislari -> Wire)
    reg [4:0] sw_adr;
    reg     sw_bank;
    wire    [15:0] led;
    
    integer i;
    
    // UUT(Unit Under Test) Orneklendirme.
    decoder_5to32_basys3 uut (
        .sw_adr(sw_adr),
        .sw_bank(sw_bank),
        .led(led)
    );
    
    
    initial begin
    // Baslangic degerleri
    sw_adr = 5'd0;
    sw_bank = 1'b0;
    #20;
    
    $display("-----------------------------------------");
    $display("TEST: Alt Banka Testi (sw_bank = 0, Adres: 0 - 15)");
    $display("-----------------------------------------");
    sw_bank = 1'b0;
    
    
    for(i = 0; i < 16; i = i+1) begin
        sw_adr = i;
        #10; // Kombinasyonel yayilim icin bekleme.
        
        // Beklenen kontrol: led == (i<<i) 
        if(led == (16'b1 << i)) begin
        $display("[PASS] Adres: %2d | Bank = %b | LED = %016b", sw_adr,sw_bank,led);
       end else begin
        $display("[FAIL] Adres = %2d | Beklenen: %016b | Gelen: %016b", sw_adr,(16'b1 << i), led);
        end
     end
     
// Adres 16-31 aralığındayken sw_bank=0 ise LED'ler 0 olmalıdır
        #10;
        sw_adr = 5'd16;
        #10;
        if (led === 16'h0000) begin
            $display("[PASS] Adres 16 ve Bank 0 iken LED'lerin hepsi kapali (Beklenen durum).");
        end else begin
            $display("[FAIL] Adres 16 ve Bank 0 iken LED cikisi: %016b", led);
        end

        #20;
        $display("--------------------------------------------------");
        $display("TEST 2: Ust Banka Testi (sw_bank = 1, Adres: 16 - 31)");
        $display("--------------------------------------------------");
        sw_bank = 1'b1;

        for (i = 16; i < 32; i = i + 1) begin
            sw_adr = i;
            #10;

            // Beklenen kontrol: led == (1 << (i - 16))
            if (led === (16'b1 << (i - 16))) begin
                $display("[PASS] Adres = %2d | Bank = %b | LED = %016b", sw_adr, sw_bank, led);
            end else begin
                $display("[FAIL] Adres = %2d | Beklenen: %016b | Gelen: %016b", sw_adr, (16'b1 << (i - 16)), led);
            end
        end

        #20;
        $display("--------------------------------------------------");
        $display("SIMULASYON TAMAMLANDI");
        $display("--------------------------------------------------");
        $finish;
    end

endmodule