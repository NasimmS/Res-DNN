/////////////////////////////////////////////////////////////////////////////////
module comp#(parameter n=5)(
	input [n-1:0]r11,//2^n
	input [n:0]r12,
	input [n-1:0]r13,//2^n -1
	input [n-1:0]r21,
	input [n:0]r22,
	input [n-1:0]r23,
	output reg [n-1:0]out1,
	output reg [n:0]out2,
	output reg [n-1:0]out3
	/*output eq1,
	output r11LTr21*/
    );
wire carry1,carry2,cout1,cout2;
wire [n-1:0]o1,o21,p1,p21,sum1,car1,sum2,car2;
wire [n:0]p2,p22;
reg comp;
wire eq1,eq2,eq3,p1LTp21,p2LTp22,r11LTr21;
//////p11(x)
/*set3_add_ppa63 add2({r11,1'b0},{~r13[n-1:0],~r13[n]},p2);
CSA #(n) add1(r12,~r11,{p2[n-1:0]},sum1,car1);
cla#(n) add3(sum1,{car1[n-2:0],1'b0},1'b0,p1,carry2);*/
set3_add_ppa63 ppa1({r13,1'b0},{~r12[n-1:0],~r12[n]},p2,cout1);
linear42_5bit l1(5'b00001,r11,r13,~r12[n-1:0],sum1,car1);
cla#(n) cla1(sum1,{car1[n-2:0],1'b0},cout1,p1,carry1);
//////p21(x)
/*set3_add_ppa63 add22({r21,1'b0},{~r23[n-1:0],~r23[n]},p22);
CSA #(n) add21(r22,~r21,{p22[n-1:0]},sum2,car2);
cla#(n) add23(sum2,{car2[n-2:0],1'b0},1'b0,p21,carry22);*/
set3_add_ppa63 ppa2({r23,1'b0},{~r22[n-1:0],~r22[n]},p22,cout2);
linear42_5bit l2(5'b00001,r21,r23,~r22[n-1:0],sum2,car2);
cla#(n) cla2(sum2,{car2[n-2:0],1'b0},cout2,p21,carry2);

bin_comp #(3*n+1) inst3({p1,p2,r11},{p21,p22,r21},eq1,r11LTr21);

always @(*) begin

	if(~eq1) begin
		if(~r11LTr21) begin
			out1<=r21;
			out2<=r22;
			out3<=r23;
		end

		else begin
			out1<=r11;
			out2<=r12;
			out3<=r13;
		end
	end
	else begin
		out1<=r11;
		out2<=r12;
		out3<=r13;
	end
end
endmodule

///////////////////////////////////////////////////////////////////////////////
module set3_add_ppa31(
    input [4:0] in1,
    input [4:0] in2,
    output [4:0] out
    );
wire [4:0]P,G;
wire [1:0]gs1,gs2,ps1,ps2;
wire gs3,ps3;
wire [4:0]gs4,ps4;
assign P=in1^in2;
assign G=in1&in2;

GA inst1(G[0],P[0],G[1],P[1],gs1[0],ps1[0]);
GA inst2(G[2],P[2],G[3],P[3],gs1[1],ps1[1]);
GA inst3(gs1[0],ps1[0],G[2],P[2],gs2[0],ps2[0]);
GA inst4(gs1[0],ps1[0],gs1[1],ps1[1],gs2[1],ps2[1]);
GA inst5(gs2[1],ps2[1],G[4],P[4],gs3,ps3);

gaa ins1(gs3,G[0],P[0],gs4[0]);
gaa ins2(gs3,gs1[0],ps1[0],gs4[1]);
gaa ins3(gs3,gs2[0],ps2[0],gs4[2]);
gaa ins4(gs3,gs2[1],gs2[1],gs4[3]);
gaa ins5(gs3,gs3,ps3,gs4[4]);

assign out[4:0]={P[4]^gs4[3],P[3]^gs4[2],P[2]^gs4[1],P[1]^gs4[0],P[0]^(gs3)};
endmodule

module GA(
	input gr,
	input pr,
	input gl,
	input pl,
	output g,
	output p
	);
assign g=gl|(gr&pl);
assign p=pl&pr;
endmodule

module gaa(
	input gr,
	input gl,
	input pl,
	output g
	);
assign g=gl|(gr&pl);
endmodule


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

module FA(
    input a,
    input b,
    input cin,
    output s,
    output cout
    );
    
    
	 assign s1=a^b;
    assign s=s1^cin;
    assign c1=a&b;
    assign c2=s1&cin;
    assign cout=c1|c2;  
    
endmodule

/////////////////////////////////////////////////////////////////////////////////
module ppa64(
    input [5:0] in1,
    input [5:0] in2,
    output [5:0] out
    );
wire [5:0]P,G;
wire [2:0]gs1,gs2,ps1,ps2;
wire [1:0]gs3,ps3;
wire [5:0]gs4,ps4;
assign P=in1^in2;
assign G=in1&in2;

GA inst1(G[0],P[0],G[1],P[1],gs1[0],ps1[0]);
GA inst2(G[2],P[2],G[3],P[3],gs1[1],ps1[1]);
GA inst6(G[4],P[4],G[5],P[5],gs1[2],ps1[2]);
GA inst3(gs1[0],ps1[0],G[2],P[2],gs2[0],ps2[0]);
GA inst4(gs1[0],ps1[0],gs1[1],ps1[1],gs2[1],ps2[1]);
GA inst5(gs2[1],ps2[1],G[4],P[4],gs3[0],ps3[0]);
GA inst7(gs2[2],ps2[2],gs2[1],ps2[1],gs3[1],ps3[1]);

assign out[5:0]={gs3[0]^P[5],gs2[1]^P[4],gs2[0]^P[3],gs1[0]^P[2],G[0]^P[1],P[0]};

endmodule

module bin_comp #(parameter n=16)(

	input [n-1:0]in1,
	input [n-1:0]in2,
	output reg eq,
	output reg i1LT2);
always@(*) begin
	if(in1==in2) begin
		eq<=1;
	end
	else begin
		eq<=0;
		if(in1>in2)
			i1LT2<=1;
		else
			i1LT2<=0;
	end
end
endmodule

/* module bin_comp #(parameter n=16)(

	input [n-1:0]in1,
	input [n-1:0]in2,
	output reg [n-1:0]out);
always@(*) begin
	if(in1==in2) begin
		out<=in1;
	end
	else begin
		if(in1>in2)
			out<=in1;
		else
			out<=in2;
	end
end
endmodule */

module set3_m_add_half_cla#( parameter n = 4 )
	(
    input [n-1:0] in1,
    input [n-1:0] in2,
    output reg [n-1:0] out
    );
	reg [n-1:0]p,g,out1,out2;
	reg [n:0]c1,c2;
	reg [n-1:0]j;
	wire carry=c2[n];
	
	always @(*) begin
	c1[0]=1'b0;
		p=in1^in2;
		g=in1&in2;
		for(j=0;j<n;j=j+1) begin
			c1[j+1]= g[j]|(p[j] & c1[j]);
		end
		out1=p^c1;

		for(j=0;j<n-1;j=j+1) begin
			c2[j+1]= g[j]|(p[j] & c2[j]);
		end
		
		c2[0]=c1[n];
		out=p^c2;
	end
//MUX #(n) multi1(out1,out2,carry,out[n-1:0]);
//cla #(n)add3(out1,{(n){1'b0}},carry1,out,carry2);

endmodule
/////////////////////////////////////////////////////////////////////////////////
module set3_add_ppa63(
    input [5:0] in1,
    input [5:0] in2,
    output [5:0] out,
	output cout
    );
wire [5:0]P,G;
wire [2:0]gs1,gs2,ps1,ps2;
wire [1:0]gs3,ps3;
wire [5:0]gs4,ps4;
assign P=in1^in2;
assign G=in1&in2;

GA inst1(G[0],P[0],G[1],P[1],gs1[0],ps1[0]);
GA inst2(G[2],P[2],G[3],P[3],gs1[1],ps1[1]);
GA inst6(G[4],P[4],G[5],P[5],gs1[2],ps1[2]);
GA inst3(gs1[0],ps1[0],G[2],P[2],gs2[0],ps2[0]);
GA inst4(gs1[0],ps1[0],gs1[1],ps1[1],gs2[1],ps2[1]);
GA inst5(gs2[1],ps2[1],G[4],P[4],gs3[0],ps3[0]);
GA inst7(gs2[2],ps2[2],gs2[1],ps2[1],gs3[1],ps3[1]);
gaa ins1(gs3[1],G[0],P[0],gs4[0]);
gaa ins2(gs3[1],gs1[0],ps1[0],gs4[1]);
gaa ins3(gs3[1],gs2[0],ps2[0],gs4[2]);
gaa ins4(gs3[1],gs2[1],gs2[1],gs4[3]);
gaa ins5(gs3[1],gs3[0],ps3[0],gs4[4]);
assign cout=g3[1];
assign out[5:0]={P[5]^gs4[4],P[4]^gs4[3],P[3]^gs4[2],P[2]^gs4[1],P[1]^gs4[0],P[0]^(gs3[1])};

endmodule

/////////////////////////////////////////////////////////////////////////////////
module cla#(parameter n=4)(
    input [n-1:0] in1,
    input [n-1:0] in2,
    input cin,
    output reg [n-1:0] out,
	 output reg carry
    );

	reg [n-1:0]p,g;
	reg [n:0]c;
	reg [n-1:0]j;
	
	always @(*) begin
	c[0]=cin;
		p=in1^in2;
		g=in1&in2;
		for(j=0;j<n;j=j+1) begin
			c[j+1]= g[j]|(p[j] & c[j]);
		end
		out=p^c;
		carry=c[n];
	end

endmodule
/////////////////////////////////////////////////
module linear42_5bit(
    input [4:0] in1,
	input [4:0] in2,
	input [4:0] in3,
	input [4:0] in4,
	output [4:0] out1,
	output [4:0] out2
	);
wire cout1,cout2,cout3,cout4,cout5,cout6;
reg cout5_reg=0;
always @* begin
	cout5_reg=cout5;
end
one_bit_42 inst1({in1[0],in2[0],in3[0],in4[0]},cout5_reg,cout1,out1[0],out2[0]);
one_bit_42 inst2({in1[1],in2[1],in3[1],in4[1]},cout1,cout2,out1[1],out2[1]);
one_bit_42 inst3({in1[2],in2[2],in3[2],in4[2]},cout2,cout3,out1[2],out2[2]);
one_bit_42 inst4({in1[3],in2[3],in3[3],in4[3]},cout3,cout4,out1[3],out2[3]);
one_bit_42 inst5({in1[4],in2[4],in3[4],in4[4]},cout4,cout5,out1[4],out2[4]);
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
//////////////////////////////////////////////
