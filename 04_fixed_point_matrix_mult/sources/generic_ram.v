`timescale 1ns / 1ps

module generic_ram #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 4,
    parameter IS_MAT_A   = 0,
    parameter IS_MAT_B   = 0
)(
    input                          clk,
    input                          we,
    input      [ADDR_WIDTH-1:0]    addr,
    input      [DATA_WIDTH-1:0]    din,
    output reg [DATA_WIDTH-1:0]    dout
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    integer idx;

    initial begin
        // Belleği önce sıfırla
        for (idx = 0; idx < (1<<ADDR_WIDTH); idx = idx + 1) begin
            mem[idx] = 16'h0000;
        end

        // matA: 4x4 Birim Matris (Q8.8 formatında 1.0 = 16'h0100)
        if (IS_MAT_A) begin
            mem[0]  = 16'h0100; mem[1]  = 16'h0000; mem[2]  = 16'h0000; mem[3]  = 16'h0000;
            mem[4]  = 16'h0000; mem[5]  = 16'h0100; mem[6]  = 16'h0000; mem[7]  = 16'h0000;
            mem[8]  = 16'h0000; mem[9]  = 16'h0000; mem[10] = 16'h0100; mem[11] = 16'h0000;
            mem[12] = 16'h0000; mem[13] = 16'h0000; mem[14] = 16'h0000; mem[15] = 16'h0100;
        end

        // matB: Tüm elemanları 2.0 olan Matris (Q8.8 formatında 2.0 = 16'h0200)
        if (IS_MAT_B) begin
            for (idx = 0; idx < 16; idx = idx + 1) begin
                mem[idx] = 16'h0200;
            end
        end
    end

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule