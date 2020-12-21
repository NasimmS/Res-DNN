module set3_reverse#(parameter n=5,parameter bitwidth=16)
	(
		input [n-1:0]rr3,
		input [n-1:0]r2,
		input [n:0]rr1,
		output reg [bitwidth-1:0]out
    );
	wire [n:0]r1;
	wire [n-1:0]r3;
	wire [2*n+1:0] M,M3;
	wire [2*n+2:0] M32;
	parameter [2*n+1:0]m=((2**n)-1)*((2**(n+1))-1);
	parameter [2*n+1:0]m3=(2**(2*n+2))-m;
	wire [n:0]r1p,r1pn,r1pp;
	wire [n-1:0]r2n,r3n;
	//wire [2*n+2:0]w1,w2,w3,w4,w5;
	wire [2*n:0]w1,w2;
//	wire [2*n+2:0]s1,c1,s2,c2,s3,c3,s4,c4,s5,c5;
	wire [2*n:0]s1,c1,s2,c2,s3,c3,s4,c4,s5,c5;
	wire [2*n+2:0]out1,out2,out3;
	wire carry;
	wire car1,car2;
	wire [2*n:0]o1,o2;
	set3_m_add#(n+1) ins1(rr1,{1'b0,~r2},r1);
	set3_m_add#(n) ins2(rr3,~r2,r3);

	assign r1pn=~{r1[n-2:0],r1[n:n-1]};
	assign r2n=~r2;
 
	assign w1={r1pn,r2n}; 
//	assign w2={2'b0,r2,r1p};
	assign w2={r2,r1p};

	CSA#(2*n+1) csa1(w1,w2,{{n{1'b0}},{(n+1){1'b1}}},s1,c1);
	cla#(2*n+1) cla1({1'b0,s1[2*n:1]},c1,1'b0,o1,car1);
	cla#(2*n+1) cla2(w1,w2,1'b0,o2,car2);
	always @(*) begin
		if(car2) out={o2[bitwidth-1-n:0],r3};
		else if(car1) out={o1[bitwidth-1-n:0],r3};
	end
endmodule


module set_m_add#( parameter n = 5 )
	(
    input [n-1:0] in1,
    input [n-1:0] in2,
    output reg [n-1:0] out
    );

reg [n-1:0]out1;
	reg [n-1:0]p,g,cc;
	reg [n:0]c;
	reg [n-1:0]j;

	always @(*) begin
	c[0]=1'b0;
		p=in1^in2;
		g=in1&in2;
		for(j=0;j<n;j=j+1) begin
			c[j+1]= g[j]|(p[j] & c[j]);
		end
		
		if(c[n])begin
			cc[0]=1'b1;
			for(j=0;j<n-1;j=j+1)begin
				cc[j+1]=((p[j]^c[j]) & cc[j]);
			end
			out=(p^c)^cc;
		end
		else out=p^c;
end
endmodule
