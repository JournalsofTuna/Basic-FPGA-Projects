`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module decoder_5to32_basys3(

    input wire [4:0] sw_adr, // SW4 - SW0 : 5 bit Adres Girisi
    input wire      sw_bank, // SW15 : Sayfa Secimi (0: Out[15:0], 1: [31:16])
    output reg [15:0] led
    
    
    );

    // 32-bit kod cozucu dahili cikisi
    wire [31:0] dec_out;
    
    // 5-to-32 Adres Kod Cozme (One-hot mapping)
    assign dec_out = 32'b1 << sw_adr;
    // 16 LED'e yonlendirme mantigi (Multiplexer / Bank Select)
    always @(*) begin
        if(sw_bank == 1'b0) begin
            led = dec_out[15:0]; // Adres 0 - 15 Araligi
        end else begin
            led = dec_out[31:16]; // Adres 16 - 31 Araligi
         end
     end

endmodule
