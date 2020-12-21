module set3_scaler#(parameter n=5)(
	input [n:0]r1,
	input [n-1:0]r2,
	input [n-1:0]r3,
	output [n:0]out1,
	output [n-1:0]out2,
	output [n-1:0]out3
    );
//channel 2/n+1/ -1
wire [n:0]out1_t;
reg temp;
reg [4:0]i;
set3_m_add#(n+1) inst1(r1,{1'b1,~r2},out1_t);
assign out1={out1_t[n-1:0],out1_t[n]};
//channel 2/n/ -1
set3_m_add#(n) inst2(r3,~r2,out3);
//channel 2/n/
//
wire [2*n:0]sum,carry,out21,out22;
wire [n:0]r11;
wire carry1,carry2;
//set3_m_add#(n+1) inst3({~r1[n-2:0],~r1[n:n-1]},0,r11); //XOR used instead
/*always @(*) begin
	for(i=0;i<=n;i=i+2)begin
		temp<=~out1_t[i+1]&~out1_t[i];
	end
	if(temp) r11={(n+1){1'b0}};
	else r11={~out1_t[n-2:0],~out1_t[n:n-1]};
end*/
assign r11={~out1_t[n-2:0],~out1_t[n:n-1]};
CSA# (2*n+1) csa1({out3,~r11[0],~out3},{r11[n:1],~r11},{{(n-1){1'b0}},1'b1,1'b1,{n{1'b0}}},sum,carry);
cla# (2*n+1) cla1(sum,{carry[2*n-1:0],1'b0},1'b0,out21,carry1);
cla# (2*n+1) cla2({out3,~r11[0],~out3},{r11[n:1],~r11},1'b1,out22,carry2);
MUX# (n) multi1(out21[n-1:0],out22[n-1:0],(carry1 | carry[2*n]),out2);

endmodule
