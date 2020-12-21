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
