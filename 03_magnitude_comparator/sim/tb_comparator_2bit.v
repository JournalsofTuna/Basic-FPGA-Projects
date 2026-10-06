`timescale 1ns / 1ps

module tb_comparator_2bit;

    reg  [1:0] A;
    reg  [1:0] B;
    wire       A_less_B;
    wire       A_equal_B;
    wire       A_greater_B;

    integer i, j;

    comparator_2bit uut (
        .A(A),
        .B(B),
        .A_less_B(A_less_B),
        .A_equal_B(A_equal_B),
        .A_greater_B(A_greater_B)
    );

    initial begin
        A = 2'b00;
        B = 2'b00;
        #20;

        // Tum 16 kombinasyonu sirayla test et
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                A = i;
                B = j;
                #10;
            end
        end

        $finish;
    end

endmodule