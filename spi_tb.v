module spi_tb();
	reg MOSI,clk,rst_n,SS_n;
	wire MISO;
	spi_wrapper dut(MOSI,MISO,SS_n,clk,rst_n);
	integer i =0;
	initial begin
		clk =0;
		forever

			#1 clk =~clk;
	end
	initial begin
		rst_n =0;   
		SS_n = 1;
		MOSI = 0;
		#10
		rst_n = 1;
		$readmemh("mem_data.txt",dut.d1.mem);
		// write address
		SS_n = 0;
		#2
		MOSI = 0;
		#2
		for(i = 0;i<8;i=i+1) begin
			#2
			MOSI=$random;
			
		end
		#4
		$display("rx_data = %b",dut.rx_data);
		SS_n =1;
		#2
		$display("addr_wr = %b",dut.d1.addr_wr);
		// write data
		SS_n = 0; MOSI = 0;
		#6
		MOSI =1;
		for(i = 0;i<8;i=i+1) begin
			#2
			MOSI=$random;
			
		end
		#2
		$display("rx_data = %b",dut.rx_data);
		$display("Data = %b",dut.d1.din[7:0]);
		SS_n =1;
		#2
		// sending read address
		SS_n = 0; MOSI = 1;
		#6
		MOSI =0;
		for(i = 0;i<8;i=i+1) begin
			#2
			MOSI=$random;
			
		end
		#2
		$display("rx_data = %b",dut.rx_data);
		SS_n =1;
		#2;
		$display("addr_rd = %b",dut.d1.addr_rd);
		// read data 
		SS_n = 0; MOSI = 1;
		#6
		for(i = 0;i<8;i=i+1) begin
			#2
			MOSI=$random;
			
		end
		#2
		$display("rx_data = %b",dut.rx_data);
		#2
		$display("dout = %b",dut.d1.dout);
		#2
		for(i = 0; i<8 ; i = i+1)begin
			$display("MISO = %b",MISO);
			#2;
		end
		SS_n =1;
		#2
	$stop;
	end
endmodule