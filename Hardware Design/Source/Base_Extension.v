//////////////////////////////////////////////////
module base_extension1024(
    input [4:0] r1,//32
    input [4:0] r2,//31
    input [5:0] r3,//63
    output  [6:0]out
    );
wire [5:0]out_w;
wire [5:0]out_w2;
wire [5:0]sum1,carry1;
wire [4:0]sum2,carry2;
wire [5:0]a3; 
wire [4:0]a2;
wire cout1,cout2;
//block1
set3_add_ppa31 inst1(r2,~r1,a2);
//block2

CSA #(6)csa1({r1[3:0],1'b0,r1[4]},{~r3[3:0],~r3[5:4]},{a2,1'b0},sum1,carry1);
set3_add_ppa63 inst2(sum1,{carry1[4:0],carry1[5]},a3);
//block3
cla #(6)cla2({1'b0,a2[4:0]},{~a3[5:0]},1'b1,out_w[5:0],c2);
//block4
assign out={out_w[1:0],r1};
endmodule


module set3_add_ppa63(
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
gaa ins1(gs3[1],G[0],P[0],gs4[0]);
gaa ins2(gs3[1],gs1[0],ps1[0],gs4[1]);
gaa ins3(gs3[1],gs2[0],ps2[0],gs4[2]);
gaa ins4(gs3[1],gs2[1],gs2[1],gs4[3]);
gaa ins5(gs3[1],gs3[0],ps3[0],gs4[4]);

assign out[5:0]={P[5]^gs4[4],P[4]^gs4[3],P[3]^gs4[2],P[2]^gs4[1],P[1]^gs4[0],P[0]^(gs3[1])};

endmodule


module set3_add_ppa31(
    input [4:0] in1,
    input [4:0] in2,
    output [4:0] out
    );
wire [4:0]P,G;
wire [1:0]gs1,gs2,ps1,ps2;
wire gs3,ps3;
wire [3:0]gs4,ps4;
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

assign out[4:0]={P[4]^gs4[3],P[3]^gs4[2],P[2]^gs4[1],P[1]^gs4[0],P[0]^(gs3)};
endmodule
