module CSA#(parameter n=4)(
	 input [n-1:0] in1,
    input [n-1:0] in2,
	 input [n-1:0] in3,
    output [n-1:0] sum,
	 output [n-1:0] carry
    );

genvar i;
generate for(i=0;i<n;i=i+1) begin:faa
		FA inst (
    .a(in1[i]), 
    .b(in2[i]), 
    .cin(in3[i]), 
    .s(sum[i]), 
    .cout(carry[i])
    );
end
endgenerate

endmodule
