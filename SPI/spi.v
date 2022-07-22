module spi(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
	parameter IDLE = 3'b000;
	parameter CHK_CMD = 3'b001;
	parameter WRITE = 3'b010;
	parameter READ_ADD = 3'b011;
	parameter READ_DATA = 3'b100;
	input MOSI,clk,rst_n,tx_valid,SS_n;
	input [7:0] tx_data;
	output reg MISO,rx_valid;
	output reg [9:0] rx_data; 
	reg [9:0] tmp_data;
	reg [2:0]cs,ns;
	reg chk_flag = 0;
	integer i = 10;
	integer j = 8;
	// Next state logic 
	always @(cs or MOSI or SS_n)begin
		case(cs)
			IDLE:	if(~SS_n)
					ns = CHK_CMD;
				else
					ns = cs;
	
			CHK_CMD:  if(SS_n)
					ns = IDLE;
				  else if(SS_n ==0 && MOSI == 0)
					ns = WRITE;

				  else if(SS_n==0&&MOSI==1&&chk_flag==0)
					ns = READ_ADD;
				 
				  else if (SS_n==0&&MOSI==1&&chk_flag==1)
					ns=READ_DATA;

			WRITE: if(SS_n)
					ns = IDLE;
				 else
					ns = cs;
			READ_ADD: if(SS_n)
					ns = IDLE;
				 else
					ns = cs;
			READ_DATA: if(SS_n)
					ns = IDLE;
				   else
					ns = cs;
			default: 
				        ns = IDLE;
		endcase
	end
	// memory state
	always @(posedge clk or negedge rst_n)begin
		if(~rst_n)
			cs <= IDLE;
		else 
			cs <= ns;
	end
	// Output logic
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n)
			chk_flag = 0;
		else begin
		case(cs)
			WRITE: begin
				   if(SS_n == 0) begin
						if (i > 0) begin
						tmp_data[i-1] = MOSI ;
						i = i-1;
						rx_valid = 0;
							if (i == 0) begin
								i =10;
								rx_data = tmp_data;
								rx_valid = 1;
							end
						end
						
				   end
			       end
			READ_ADD: begin
				   if(SS_n == 0) begin
			       		if (i > 0) begin
						tmp_data[i-1] = MOSI ;
						i = i-1;
						rx_valid = 0;
						if (i == 0) begin
							i =10;
							rx_data = tmp_data;
							rx_valid = 1;
							chk_flag = 1;
						end
					end
				    end
			           end
			READ_DATA: begin
				    if(SS_n == 0) begin
					if(tx_valid == 1) begin
							if (i>0)begin
							MISO = tx_data[i-1] ;
							i = i - 1;
							if (i==0)
								i = 10;
							end
					end
					else begin
					if (i > 0) begin
						tmp_data[i-1] = MOSI ;
						i = i-1;
						rx_valid = 0;
						if(i == 0) begin
							i =9;
							rx_data = tmp_data;
				     			rx_valid = 0;
				     			chk_flag = 0;
						end
					end
					end
				    end
				    end	
			default: begin
				  rx_data = 'b0;
				  rx_valid = 0;
				end
		endcase
		end
	end
endmodule