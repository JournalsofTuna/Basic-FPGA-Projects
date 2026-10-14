`timescale 1ns / 1ps

module tb_matrix_multiplication;
    reg clk;
    reg reset;
    wire done;
    wire [15:0] data_out;
    integer r, c;

    matrix_multiplication uut (
        .clk(clk),
        .reset(reset),
        .done(done),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #40;
        reset = 0;

        // Islem bitene kadar bekle
        wait(done);
        #40;

        $display("\n=======================================================");
        $display("   4x4 MATRIS CARPIMI SONUC MATRISI (C = A x B)");
        $display("=======================================================");
        for (r = 0; r < 4; r = r + 1) begin
            $display("  [0x%h]   [0x%h]   [0x%h]   [0x%h]", 
                     uut.C[r][0], uut.C[r][1], uut.C[r][2], uut.C[r][3]);
        end
        $display("=======================================================\n");

        #50;
        $finish;
    end
endmodule