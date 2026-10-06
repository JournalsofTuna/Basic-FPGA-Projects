`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module comparator_2bit(
    input wire [1:0] A,
    input wire [1:0] B,
    output wire     A_less_B,
    output wire     A_equal_B,
    output wire     A_greater_B
    );
    
    wire tmp1,tmp2;
    wire tmp3,tmp4,tmp5;
    wire tmp6,tmp7,tmp8;
    
    // A = B Logic (XNOR bit-bit esitlik,ardindan AND)
    xnor u1(tmp1, A[1], B[1]);
    xnor u2(tmp2, A[0], B[0]);
    and  u3(A_equal_B,tmp1,tmp2);
    
    // A < B Logic K-Map indirgemesi)
    assign tmp3 = (~A[0]) & (~A[1]) & B[0];
    assign tmp4 = (~A[1]) & B[1];
    assign tmp5 = (~A[0]) & B[1] & A[0];
    assign A_less_B = tmp3 | tmp4 | tmp5;
    
    // A > B Logic (K-Map indirgemesi)
    assign tmp6 = (~B[0]) & (~B[1]) & A[0];
    assign tmp7 = (~B[1]) & A[1];
    assign tmp8 = (~B[0]) & A[1] & A[0];
    assign A_greater_B = tmp6 | tmp7 | tmp8;
    
endmodule
