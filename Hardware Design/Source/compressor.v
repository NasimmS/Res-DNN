///////////////////////////////////////////////////////////////////////////////
module compressor #(parameter n=16)(
    input [n-1:0] in,
	 input clk,
	 input rst,
    output reg [63:0]out,
	 output reg s,
	 output reg endd
    );
reg [127:0]temp;
reg [63:0]temp2;
reg [6:0]count;
reg [5:0]t;
reg [6:0]i;

	reg[1:0] state;
	reg[1:0] next_state;
	localparam [1:0]
	start = 2'b00,
	one = 2'b01,
	zero = 2'b11;
	
	always @* begin // combinational
		case(state)
			start: begin
				endd=0;
				if (in==16'b0) begin
					next_state = zero;
					
				end
				else begin 
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
					temp=temp<<64;
				end
				if(count>64) begin
					endd=1;
				end
				if (in==16'b0) begin next_state = zero;  end
				if (in!=16'b0) begin next_state = one;  end
				temp[127-count+1]=1'b0;
			end

			one: begin
				if(endd) begin 
					endd=0; 
					temp[127:64]=temp[63:0];
					//temp={temp[127:64+count],temp2,{count*{1'b0}}}; 
				end
				temp[128-count]=1'b1;
				for(i=0;i<16;i=i+1) begin
					temp[112-count+i]=in[i];
				end
				if(count>64)begin 
					endd=1;
				end
				//count=count+16;

				if (in==16'b0) begin next_state = zero;  end
				else begin next_state = one;  end
			end

			
			default: next_state = start;
		endcase
	end
	
	always @(posedge clk) // sequential
		if (rst) begin
			state <= start;
			count<=0;
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
				out<=temp[127:64];
				count<=0;
				t=count;
				//temp[count-:64]<=temp2;//{temp[127:64+count],temp2,{count*{1'b0}}};
			end
		end
endmodule
