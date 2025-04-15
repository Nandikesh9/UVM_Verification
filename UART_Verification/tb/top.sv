//`timesclae 1ns/1ps;
`include "timescale.v"
module top;
	import uvm_pkg::*;
	import uart_pkg::*;

	bit clk1,clk2;
	wire tx,rx;

	always
	   forever
		#20 clk1= ~clk1;
	always 
	   forever
		#10 clk2 = ~clk2;
// Interface instantiation
	uart_if in0 (clk1);
	uart_if in1 (clk2);

//DUT instantiation
	
	uart_top DUT1 (.wb_clk_i(clk1),
			.wb_rst_i(in0.wb_rst_i),
			.wb_adr_i(in0.wb_adr_i),
			.wb_dat_i(in0.wb_dat_i),
			.wb_dat_o(in0.wb_dat_o),
			.wb_sel_i(in0.wb_sel_i),
			.wb_we_i(in0.wb_we_i),
			.wb_cyc_i(in0.wb_cyc_i),
			.wb_stb_i(in0.wb_stb_i),
			.wb_ack_o(in0.wb_ack_o),
			.int_o(in0.int_o),
			.stx_pad_o(tx),
			.srx_pad_i(rx));
			
	uart_top DUT2 (.wb_clk_i(clk2),
			.wb_rst_i(in1.wb_rst_i),
			.wb_adr_i(in1.wb_adr_i),
			.wb_dat_i(in1.wb_dat_i),
			.wb_dat_o(in1.wb_dat_o),
			.wb_sel_i(in1.wb_sel_i),
			.wb_we_i(in1.wb_we_i),
			.wb_cyc_i(in1.wb_cyc_i),
			.wb_stb_i(in1.wb_stb_i),
			.wb_ack_o(in1.wb_ack_o),
			.int_o(in1.int_o),
			.stx_pad_o(rx),
			.srx_pad_i(tx));

	initial begin
		`ifdef Questa
		$fsdbDumpvars(0,top);
		`endif

		uvm_config_db #(virtual uart_if) ::set(null,"*","vif_0",in0);
		uvm_config_db #(virtual uart_if) ::set(null,"*","vif_1",in1);
		run_test();
	end
endmodule
