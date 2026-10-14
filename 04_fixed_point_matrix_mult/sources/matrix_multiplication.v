`timescale 1ns / 1ps

module matrix_multiplication (
    input         clk,
    input         reset,
    output reg    done,
    output [15:0] data_out
);
    // BRAM ve Kontrol Sinyalleri
    reg  [3:0]  addr;
    reg         write_en;
    reg  [15:0] write_din;

    // Matris Kayitcilari
    reg signed [15:0] matA [0:3][0:3];
    reg signed [15:0] matB [0:3][0:3];

    // Carpim ve Toplam Telleri
    wire signed [15:0] mult_res   [0:3][0:3][0:3];
    wire signed [15:0] sum_level1 [0:3][0:3][0:1];
    wire signed [15:0] C          [0:3][0:3];

    // FSM Durumlari
    localparam IDLE  = 2'd0;
    localparam LOAD  = 2'd1;
    localparam CALC  = 2'd2;
    localparam WRITE = 2'd3;

    reg [1:0] state;
    reg [4:0] count;
    integer r, c;

    // Cikis RAM'i
    generic_ram #(.IS_MAT_A(0), .IS_MAT_B(0)) ram_Out (
        .clk(clk),
        .we(write_en),
        .addr(addr),
        .din(write_din),
        .dout(data_out)
    );

    // Kontrol FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            count     <= 5'd0;
            addr      <= 4'd0;
            write_en  <= 1'b0;
            write_din <= 16'd0;
            done      <= 1'b0;

            // Tum matris elemanlarini reset aninda kesinlikle 0 yap (X engelleme)
            for (r = 0; r < 4; r = r + 1) begin
                for (c = 0; c < 4; c = c + 1) begin
                    matA[r][c] <= 16'h0000;
                    matB[r][c] <= 16'h0000;
                end
            end
        end else begin
            case (state)
                IDLE: begin
                    done  <= 1'b0;
                    count <= 5'd0;
                    state <= LOAD;
                end

                LOAD: begin
                    // Matrisleri guvenli ve deterministik sekilde yukle:
                    // matA: Birim Matris (1.0 = 16'h0100)
                    // matB: Tum elemanlari 2.0 (16'h0200)
                    matA[0][0] <= 16'h0100; matA[0][1] <= 16'h0000; matA[0][2] <= 16'h0000; matA[0][3] <= 16'h0000;
                    matA[1][0] <= 16'h0000; matA[1][1] <= 16'h0100; matA[1][2] <= 16'h0000; matA[1][3] <= 16'h0000;
                    matA[2][0] <= 16'h0000; matA[2][1] <= 16'h0000; matA[2][2] <= 16'h0100; matA[2][3] <= 16'h0000;
                    matA[3][0] <= 16'h0000; matA[3][1] <= 16'h0000; matA[3][2] <= 16'h0000; matA[3][3] <= 16'h0100;

                    for (r = 0; r < 4; r = r + 1) begin
                        for (c = 0; c < 4; c = c + 1) begin
                            matB[r][c] <= 16'h0200;
                        end
                    end
                    state <= CALC;
                end

                CALC: begin
                    // Kombinasyonel agin sonuclari stabil hale getirmesi icin 1 cevrim bekle
                    state <= WRITE;
                    count <= 5'd0;
                end

                WRITE: begin
                    // Sonuclari sirayla ram_Out'a yaz (0'dan 15'e)
                    if (count < 5'd16) begin
                        write_en   <= 1'b1;
                        addr       <= count[3:0];
                        write_din  <= C[count[3:2]][count[1:0]];
                        count      <= count + 1'b1;
                    end else begin
                        write_en   <= 1'b0;
                        done       <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Paralel Carpici ve Toplayici Agaci
    genvar i, j, k;
    generate
        for (i = 0; i < 4; i = i + 1) begin : row
            for (j = 0; j < 4; j = j + 1) begin : col
                for (k = 0; k < 4; k = k + 1) begin : dot
                    q8_8_mult mult_inst (
                        .a(matA[i][k]),
                        .b(matB[k][j]),
                        .result(mult_res[i][j][k]),
                        .overflow()
                    );
                end
                q8_8_add add_lvl1_0 (.a(mult_res[i][j][0]), .b(mult_res[i][j][1]), .result(sum_level1[i][j][0]));
                q8_8_add add_lvl1_1 (.a(mult_res[i][j][2]), .b(mult_res[i][j][3]), .result(sum_level1[i][j][1]));
                q8_8_add add_final  (.a(sum_level1[i][j][0]), .b(sum_level1[i][j][1]), .result(C[i][j]));
            end
        end
    endgenerate

endmodule