`timescale 1ns / 1ps

module tb_pwm_controller_top;

    // Test Sinyalleri
    reg        clk;
    reg        rst;
    reg        btn_up;
    reg        btn_down;

    wire       pwm_out;
    wire [7:0] duty_leds;

    // UUT (Debounce filtresini simülasyonda beklememek için 5 çevrime kuruyoruz)
    pwm_controller_top #(
        .SIM_DEBOUNCE_LIMIT(20'd5)
    ) uut (
        .clk       (clk),
        .rst       (rst),
        .btn_up    (btn_up),
        .btn_down  (btn_down),
        .pwm_out   (pwm_out),
        .duty_leds (duty_leds)
    );

    // 100 MHz Sistem Saati (Periyot: 10 ns)
    always begin
        #5 clk = ~clk;
    end

    // Buton Darbe Görevleri (Task)
    task press_up;
        begin
            @(posedge clk);
            btn_up = 1'b1;
            #100; // 10 cycle (5 cycle limitini rahatça aşar)
            @(posedge clk);
            btn_up = 1'b0;
            #100;
        end
    endtask

    task press_down;
        begin
            @(posedge clk);
            btn_down = 1'b1;
            #100;
            @(posedge clk);
            btn_down = 1'b0;
            #100;
        end
    endtask

    // Test Senaryosu
    initial begin
        clk      = 1'b0;
        rst      = 1'b1;
        btn_up   = 1'b0;
        btn_down = 1'b0;

        // Reset süreci
        #100;
        @(posedge clk);
        rst = 1'b0;
        $display("[T=%0t ns] Reset birakildi. Baslangic duty degeri: %d", $time, duty_leds);

        #500;

        // Parlaklık artırma (128 -> 144)
        $display("[T=%0t ns] btn_up basiliyor...", $time);
        press_up();
        @(posedge clk);
        $display("[T=%0t ns] Yeni duty degeri: %d", $time, duty_leds);

        #500;

        // Parlaklık artırma (144 -> 160)
        $display("[T=%0t ns] btn_up basiliyor...", $time);
        press_up();
        @(posedge clk);
        $display("[T=%0t ns] Yeni duty degeri: %d", $time, duty_leds);

        #500;

        // Parlaklık azaltma (160 -> 144)
        $display("[T=%0t ns] btn_down basiliyor...", $time);
        press_down();
        @(posedge clk);
        $display("[T=%0t ns] Yeni duty degeri: %d", $time, duty_leds);

        #1000;
        $display("[T=%0t ns] Simülasyon basariyla tamamlandi.", $time);
        $finish;
    end

endmodule