module set3_forward#(parameter n=4,parameter bitwidth=12)
	(
    input [bitwidth:0] in,
    output reg[n:0] r1,
    output [n-1:0] r2,
    output reg [n-1:0] r3
    );

parameter m1=1;
parameter m2=2;

wire [n:0]c12,s12,c13,s13,c14,s14;
wire [n-1:0]c11,s11;
wire [n:0]c21,s21;
wire [n+1:0]c22,s22,c23,s23;
wire [n:0]sum11,sum12;
wire [n+1:0]sum13;
wire [n+1:0]sum21,sum22;
wire [n+2:0]sum23;
wire carry11,carry12,carry13,carry21,carry22,carry23;
CSA#(n) c1(in[n-1:0],in[2*n-1:n],in[3*n-1:2*n],s11,c11);
CSA#(n+1) c2({1'b0,s11},{c11,1'b0},m1,s12,c12);
CSA#(n+1) c3({1'b0,s11},{c11,1'b0},m2,s13,c13);

CSA#(n+1) c4(in[n:0],in[2*n+1:n+1],{{(3*n+3-bitwidth){1'b0}},in[bitwidth-1:2*n+2]},s21,c21);
CSA#(n+2) c5({1'b0,s21},{c21,1'b0},m1,s22,c22);
CSA#(n+2) c6({1'b0,s21},{c21,1'b0},m2,s23,c23);

cla#(n+1) add1({1'b0,s11},{c11,1'b0},sum11,carry11);
cla#(n+1) add2(s12,{c12[n-1:0],1'b0},sum12,carry12);
cla#(n+2) add3({1'b0,s13},{c13,1'b0},sum13,carry13);

cla#(n+2) add4({1'b0,s21},{c21,1'b0},sum21,carry21);
cla#(n+2) add5(s22,{c22[4:0],1'b0},sum22,carry22);
cla#(n+3) add6({1'b0,s23},{c23,1'b0},sum23,carry23);

assign r2=in[n-1:0];
	always @(*) begin
		//if(~carry11) r1=sum11;
		if(sum13[n+1]) begin //if(~(sum13[3:0]^4'b1111))r1=0; else 
			r3=sum13; 
			end
		else if(sum12[n]) r3=sum12;
		else r3=sum11;
		
		if(sum23[n+2]) r1=sum23;
		else if(sum22[n+1]) r1=sum22;
		else r1=sum21;
	end
endmodule
