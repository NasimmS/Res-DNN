//////////////////////////////////////////////////
module scale_extension(
    input [4:0] r1,//32
    input [4:0] r2,//31
    input [5:0] r3,//63
	input [4:0] sub,
    output  [9:0]out
    );
wire [4:0]out_w;
wire [5:0]out_w2;
wire [4:0]sum1,carry1;
wire [5:0]sum2,carry2;
wire [5:0]a3; 
wire [4:0]a2;
wire cout1,cout2;
//block1
CSA #(5)csa1(r2,~r1,~sub,sum1,carry1);
set3_add_ppa31 inst1(sum1,{carry1[3:0],carry1[4]},a2);
//block2
linear42_6bit l1({r3[4:0],r3[5]},{~sub[4:0],1'b1},{~a2[4:0],1'b1},{~r1[3:0],1'b1,~r1[4]},sum2,carry2);
set3_add_ppa63 inst2(sum2,{carry2[4:0],carry2[5]},a3);
//block3
cla #(5)cla2(a2[4:0],~a3[4:0],1'b1,out_w,c2);
//block4
assign out={out_w,r1};
endmodule

/////////////////////////////////////////////////
module linear42_6bit(
    input [5:0] in1,
	input [5:0] in2,
	input [5:0] in3,
	input [5:0] in4,
	output [5:0] out1,
	output [5:0] out2
	);
wire cout1,cout2,cout3,cout4,cout5,cout6;
reg cout6_reg=0;
always @* begin
	cout6_reg=cout6;
end
one_bit_42 inst1({in1[0],in2[0],in3[0],in4[0]},cout6_reg,cout1,out1[0],out2[0]);
one_bit_42 inst2({in1[1],in2[1],in3[1],in4[1]},cout1,cout2,out1[1],out2[1]);
one_bit_42 inst3({in1[2],in2[2],in3[2],in4[2]},cout2,cout3,out1[2],out2[2]);
one_bit_42 inst4({in1[3],in2[3],in3[3],in4[3]},cout3,cout4,out1[3],out2[3]);
one_bit_42 inst5({in1[4],in2[4],in3[4],in4[4]},cout4,cout5,out1[4],out2[4]);
one_bit_42 inst6({in1[5],in2[5],in3[5],in4[5]},cout5,cout6,out1[5],out2[5]);
endmodule
/////////////////////////////////////////////////

//////////////////////////////////////////////
module one_bit_42(
    input [3:0]in,
    input cin,
    output cout,
	output s,
	output c
    );
    wire s1,s2;
    FA fa1(
            in[0],in[1],in[2],s1,cout
        );
    FA fa2(
            in[3],cin,s1,s,c
        );
endmodule
