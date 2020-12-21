module set3_mult #(parameter n=4)(
    input [n:0] r11,
    input [n-1:0] r12,
    input [n-1:0] r13,
    input [n:0] r21,
    input [n-1:0] r22,
    input [n-1:0] r23,
    output [n:0] out1,
    output [n-1:0] out2,
    output [n-1:0] out3
    );
wire [2*n-1:0]temp;
set3_m_mult #(n+1)mult1(r11,r21,out1);
Booth_mult#(n)mult2(r12,r22,temp);
assign out2=temp[n-1:0];
set3_m_mult #(n)mult3(r13,r23,out3);
endmodule

/////////////////////////////////////////

module set3_m_mult#(parameter n=4)(    //2**n-1
        input[n-1:0] r1,
        input[n-1:0] r2,
        output[n-1:0] out
        );
wire [2*n-1:0]temp;
Booth_mult #(n)mult(r1,r2,temp);
set3_m_add #(n)add(temp[n-1:0],temp[2*n-1:n],out);

endmodule

//////////////////////////

module Booth_mult #(parameter n=1)(
		input [n-1:0]mr,
		input [n-1:0]md,
		output reg [2*n-1:0]out
    );	 
reg [n-1:0] out1,out2;
reg [n+2:0]outt;
wire [n+2:0]mrr;
reg temp1,temp2,one,two,neg,zero;
assign mrr={2'b0,mr,1'b0};
reg [10:0]i,ii,j,k;
reg [n+2:0]s;//={19'b0};
reg [n+2:0]c;//={19'b0};
reg [n+2:0]sum,carry;
reg [n-1:0]p,g;
reg [n:0]cc;
reg s2,ccpa;
reg [n+2:0]s1,c1,c2;

always @(*) begin
	sum={(n+3){1'b0}};
	s={(n+3){1'b0}};
	carry={(n+3){1'b0}};
	c={(n+3){1'b0}};
	for (j=0;j<=(n/2);j=j+1) begin:l1

		one=mrr[2*j+1]^mrr[2*j];
		temp1=~(mrr[2*j+1]^mrr[2*j]);
		temp2=mrr[2*j+1]^mrr[2*j+2];
		two=temp1&temp2; 
		neg=mrr[2*j+2];
		zero=~(mrr[2*j+2]&mrr[2*j+1]&mrr[2*j]);
		for(ii=0;ii<=n-1;ii=ii+1) begin:l2
			out1[ii]=((md[ii]^neg))&one&zero;
			out2[ii]=((md[ii]^neg))&two&zero;
		end
		outt[n+2:0]={neg&two,neg&two,out2,1'b0}|{neg&one,neg&one,neg&one,out1};
		for(i=0;i<n+3;i=i+1)begin
				s1[i]=outt[i]^s[i];
				sum[i]=(s1[i])^c[i];
				c1[i]=outt[i]&s[i];
				c2[i]=s1[i]&c[i];
				carry[i]=c1[i]|c2[i];
		end
			s[n+2:0]={sum[n+2],sum[n+2],sum[n+2:2]};
			c[n+2:0]={carry[n+1],carry[n+1],carry[n+1:1]};

			out[2*j]=neg^sum[0];
			ccpa=neg&sum[0];
			s2=carry[0]^sum[1];
			cc[0]=carry[0]&sum[1];
			out[2*j+1]=s2^ccpa;

	end		
	p[n-1:0]=s[n-1:0]^c[n-1:0];
	g[n-1:0]=s[n-1:0]&c[n-1:0];
//	cc[0]=1'b0;
	for(k=0;k<n;k=k+1) begin
		cc[k+1]= g[k]|(p[k] & cc[k]);
	end
	out[2*n-1:(n/2)*2+2]=p^cc;
end
 
endmodule
//////////////////////////
module Booth16 (
		input [15:0]mr,
		input [15:0]md,
		output reg [31:0]out
    );	 
reg [15:0] out1,out2;
reg [18:0]outt;
wire [18:0]mrr;
reg temp1,temp2,one,two,neg,zero;
assign mrr={2'b0,mr,1'b0};
reg [5:0]i,j,k;
reg [18:0]s={19'b0};
reg [18:0]c={19'b0};
reg [18:0]sum,carry;
reg [15:0]p,g;
reg [16:0]cc;
reg s2,ccpa;
reg [18:0]s1,c1,c2;

always@* begin
for(j=0;j<=8;j=j+1) begin:l1
	one=mrr[2*j+1]^mrr[2*j];
	temp1=~(mrr[2*j+1]^mrr[2*j]);
	temp2=mrr[2*j+1]^mrr[2*j+2];
	two=temp1&temp2; 
	neg=mrr[2*j+2];
	zero=~(mrr[2*j+2]&mrr[2*j+1]&mrr[2*j]);
	for(i=0;i<=15;i=i+1) begin:l2
			out1[i]=((md[i]^neg))&one&zero;
			out2[i]=((md[i]^neg))&two&zero;
	end
	outt[18:0]={neg&two,neg&two,out2,1'b0}|{neg&one,neg&one,neg&one,out1};
	for(i=0;i<19;i=i+1)begin
		 s1[i]=outt[i]^s[i];
		 sum[i]=s1[i]^c[i];
		 c1[i]=outt[i]&s[i];
		 c2[i]=s1[i]&c[i];
		 carry[i]=c1[i]|c2[i];
	end
	s={sum[18],sum[18],sum[18:2]};
	c={carry[17],carry[17],carry[17:1]};

	out[2*j]=neg^sum[0];
	ccpa=neg&sum[0];
	s2=carry[0]^sum[1];
	out[2*j+1]=s2^ccpa;
	
end

	p=s^c;
	g=s&c;
	cc[0]=1'b0;
	for(k=0;k<16;k=k+1) begin
		cc[k+1]= g[k]|(p[k] & cc[k]);
	end
	out[31:18]=p^cc;
end
endmodule

//////////////////////////////////////////

module set3_m_add#( parameter n = 4 )
	(
    input [n-1:0] in1,
    input [n-1:0] in2,
    output [n-1:0] out
    );

wire [n-1:0]s,c,out1,out2;
wire carry1,carry2;	 
cla #(n)add1(in1,in2,1'b0,out1,carry1);

cla #(n)add3(in1,in2,1'b1,out2,carry2);

MUX #(n) multi1(out1,out2,carry2,out[n-1:0]);

endmodule


module MUX #(parameter n=4)(
		input [n-1:0]out1,
		input [n-1:0]out2,
		input carry2,
		output reg [n-1:0]out
    );
	 
	 always @(*) begin
		if(carry2) out=out2;
		else out=out1;
	end


endmodule

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
