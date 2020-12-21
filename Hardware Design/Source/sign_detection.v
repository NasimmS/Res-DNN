/////////////////////////////////////////////////////////////////////////////////
module sign_3set #(parameter n=5)(
    input [5:0] in1,
    input [4:0] in2,
    input [4:0] in3,
    output sign
    );
wire gt,pt,pn,w;
wire [4:0]sum,carry;
CSA #(5) csa1({~in1[n-2:0],~in1[n]},in2,in3,sum,carry);
comparator c2(in2,in1,w);
carry_gen c1(sum,{carry[3:0],1'b0},gt,pt,pn);
post_proc p1(gt,pt,pn,w,sign);

endmodule

module carry_gen(
	input [4:0]in1,
	input [4:0]in2,
	output gt,
	output pt,
	output pn
	);
wire [4:0]P=in1^in2;
wire [4:0]G=in1&in2;
wire [1:0]gs1,ps1;
wire gs2,ps2;
GA ga1(G[0],P[0],G[1],P[1],gs1[0],ps1[0]);
GA ga2(G[2],P[2],G[3],P[3],gs1[1],ps1[1]);
GA ga3(gs1[0],ps1[0],gs1[1],ps1[1],gt,pt);
assign pn=P[4];
endmodule

module comparator(
	input [4:0]in1,
	input [5:0]in2,
	output w
	);

wire [4:0]P=in1^~in2;
wire [4:0]G=in1&(~in2);
wire [1:0]gs1,ps1;
wire gs2,ps2,gs3,ps3,w1;
GA ga1(G[0],P[0],G[1],P[1],gs1[0],ps1[0]);
GA ga2(G[2],P[2],G[3],P[3],gs1[1],ps1[1]);
GA ga3(gs1[0],ps1[0],gs1[1],ps1[1],gs2,ps2);
GA ga4(gs2,ps2,G[4],P[4],gs3,ps3);	
//p for equal and g for in1>~in2
assign w1=~in2[5]&ps3;
assign w=w1|gs3;
endmodule

module post_proc(
	input gt,
	input pt,
	input pn,
	input w,
	output sign
	);
assign sign=((w&pt)|gt)^pn;
endmodule
