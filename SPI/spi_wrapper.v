module spi_wrapper(MOSI,MISO,SS_n,clk,rst_n);
	input MOSI,SS_n,clk,rst_n;
	output MISO;
 	wire rx_valid,tx_valid;
	wire [9:0] rx_data;
	wire [7:0] tx_data;
	spi s1(.rx_data(rx_data),.rx_valid(rx_valid),.clk(clk),.rst_n(rst_n),.tx_data(tx_data),.tx_valid(tx_valid),.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n));
	dpr_async d1(.din(rx_data),.rx_valid(rx_valid),.dout(tx_data),.tx_valid(tx_valid),.clk(clk),.rst_n(rst_n));
endmodule
