`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:44 12/16/2017 
// Design Name: 
// Module Name:    MUX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MUX#(parameter n=12)(
		input [n-1:0]out1,
		input [n-1:0]out2,
		input [n-1:0]out3,
		input carry2,
		input carry3,
		output reg [n-1:0]out
    );
	 
	 always @(*) begin
		if(carry3) out=out3;
		else if(carry2)out=out2;
		else out=out1;
	end


endmodule
