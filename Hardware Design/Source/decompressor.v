/////////////////////////////////////////////////////////////////////////////////
module decompressor  #(parameter n=16)(
    input clk,
	 input [63:0]in,
	 input rst,
	 output reg endd,
    output reg [15:0] out
    );
reg [127:0]temp;
reg [63:0]temp2;
reg [5:0]count;
reg [5:0]t;
reg [6:0]i;

	reg[1:0] state;
	reg[1:0] next_state;
	localparam [1:0]
	start = 2'b00,
	one = 2'b01,
	zero = 2'b11,
	idle = 2'b10;
	
	always @* begin // combinational
		case(state)
			start: begin
				temp[127:0]={in[62:0],65'b0};
				endd=0;
				if (~in[63]) begin
					next_state = zero;
					
				end
				if (in[63]) begin 
					next_state = one;
					//endd=0;
					
				end
				//temp=1<<temp;
				//count=count+1;
			end
			zero: begin
				
				if(endd) begin 
					endd=0; 
					//temp={temp[127:64+t],temp2,{count*{1'b0}}}; 
					for(i=0;i<64;i=i+1) begin
						temp[63-t+i+1]=temp2[i];
					end
				end
				if(count>32) begin
					endd=1;
				end
				if (temp[127]) begin next_state = one;  end
				if (~temp[127]) begin next_state = zero;  end
				out=16'b0;
				temp=temp<<1;
			end

			one: begin
				if(endd) begin 
					endd=0; 
					for(i=0;i<64;i=i+1) begin
						temp[63-t+i]=temp2[i];
					end
					//temp={temp[127:64+count],temp2,{count*{1'b0}}}; 
				end
				out=temp[127:112];
				if(count>32)begin 
					endd=1;
					
				end
				//count=count+16;

				if (temp[111]) begin next_state = one;  end
				else if (~temp[111]) begin next_state = zero;  end
				temp=temp<<17;
			end

			
			default: next_state = start;
		endcase
	end
	
	always @(posedge clk) // sequential
		if (rst) begin
			state <= start;
			count<=0;
			temp2<=0;
			temp<=0;
			//temp[127:64]<=in;
		end
		else begin
			state <= next_state;
			if(next_state==zero)
				count<=count+1;
			else if(next_state==one)
				count<=count+17;
			//t<=count;
			if(endd) begin
				temp2<=in;
				count<=0;
				t=count;
				//temp[count-:64]<=temp2;//{temp[127:64+count],temp2,{count*{1'b0}}};
			end
		end
endmodule
//////////////////////////////////////////


