module set3_add #(parameter n=11)
	(
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
	wire carry;
	cla#(n) inst(r12,r22,1'b0,out2,carry);
	//assign {carry,out2}=r12+r22;
	set3_m_add#(n+1) inst1(r11,r21,out1);
	set3_m_add#(n) inst2(r13,r23,out3);

endmodule


module set3_m_add#( parameter n = 5 )
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
