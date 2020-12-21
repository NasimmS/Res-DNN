////////////////////////////////////////////////////////////////////////////////
module PPA #(parameter n=16)(
    input [n-1:0] in1,
    input [n-1:0] in2,
    output [n:0] out
    );
wire [n-1:0]P,G;
assign P=in1^in2;
assign G=in1&in2;
wire cin=0;
wire [7:0]gs1,ps1,gs2,ps2,gs3,ps3,gs4,ps4;
genvar i;
generate for(i=0;i<n/2;i=i+1) begin:faa1
	GA ins3(G[2*i],P[2*i],G[2*i+1],P[2*i+1],gs1[i],ps1[i]);
end
for(i=0;i<n/4;i=i+1) begin:faa2
	GA ins1(gs1[2*i],ps1[2*i],gs1[2*i+1],ps1[2*i+1],gs2[2*i],ps2[2*i]);
	GA ins2(gs1[2*i],ps1[2*i],G[4*i+2],P[4*i+2],gs2[2*i+1],ps2[2*i+1]);
end
endgenerate
////stage3
GA inst1(gs2[1],ps2[1],G[4],P[4],gs3[0],ps3[0]);
GA inst2(gs2[1],ps2[1],gs1[2],ps1[2],gs3[1],ps3[1]);
GA inst3(gs2[1],ps2[1],gs2[2],ps2[2],gs3[2],ps3[2]);
GA inst4(gs2[1],ps2[1],gs2[3],ps2[3],gs3[3],ps3[3]);
GA inst5(gs2[5],ps2[5],G[12],P[12],gs3[4],ps3[4]);
GA inst6(gs2[5],ps2[5],gs1[6],ps1[6],gs3[5],ps3[5]);
GA inst7(gs2[5],ps2[5],gs2[6],ps2[6],gs3[6],ps3[6]);
GA inst8(gs2[5],ps2[5],gs2[7],ps2[7],gs3[7],ps3[7]);

////stage4
GA inst11(gs3[3],ps3[3],G[8],P[8],gs4[0],ps4[0]);
GA inst12(gs3[3],ps3[3],gs1[4],ps1[4],gs4[1],ps4[1]);
GA inst13(gs3[3],ps3[3],gs2[4],ps2[4],gs4[2],ps4[2]);
GA inst14(gs3[3],ps3[3],gs2[5],ps2[5],gs4[3],ps4[3]);
GA inst15(gs3[3],ps3[3],gs3[4],ps3[4],gs4[4],ps4[4]);
GA inst16(gs3[3],ps3[3],gs3[5],ps3[5],gs4[5],ps4[5]);
GA inst17(gs3[3],ps3[3],gs3[6],ps3[6],gs4[6],ps4[6]);
GA inst18(gs3[3],ps3[3],gs3[7],ps3[7],gs4[7],ps4[7]);

assign out[15:8]={gs4[6]^P[15],gs4[5]^P[14],gs4[4]^P[13],gs4[3]^P[12],gs4[2]^P[11],gs4[1]^P[10],gs4[0]^P[9],gs3[3]^P[8]};
assign out[7:0]={gs3[2]^P[7],gs3[1]^P[6],gs3[0]^P[5],gs2[1]^P[4],gs2[0]^P[3],gs1[0]^P[2],G[0]^P[1],P[0]};
assign out[16]=gs4[7];
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

