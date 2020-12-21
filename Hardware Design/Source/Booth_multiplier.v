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
