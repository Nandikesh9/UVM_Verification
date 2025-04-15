class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	write_xtn xtn1,xtn2;
	write_xtn cov_data;

	env_config e_cfg;
	int thr1size,thr2size;
	int rb1size,rb2size;

	uvm_tlm_analysis_fifo #(write_xtn) fifo_h[];


	covergroup uart_signals;
		option.per_instance=1;

		DATA: coverpoint cov_data.wb_dat_i[7:0] {bins data_i ={[0:255]};}
		ADD: coverpoint cov_data.wb_adr_i[2:0] {bins adri ={[0:7]};}
		WE_ENB: coverpoint cov_data.wb_we_i {	bins rd ={0};
							bins wr ={1};}
	endgroup

	covergroup uart_lcr;
		option.per_instance=1;

		CHAR: coverpoint cov_data.lcr[1:0] {bins five = {2'b00};
							bins six = {2'b01};
							bins seven = {2'b10};
							bins eight = {2'b11}; }

		STOP: coverpoint cov_data.lcr[2] {bins single_stop = {1'b0};
							bins more_stops ={1'b1}; }

		PARITY: coverpoint cov_data.lcr[3] {bins parity_off = {1'b0}; 
							bins parity_on ={1'b1}; }

		E_O_PARITY: coverpoint cov_data.lcr[4] {bins even_parity ={1'b1};
							bins odd_parity = {1'b0}; }
		
		STICKY: coverpoint cov_data.lcr[5] {bins sp_off ={1'b0};
							bins sp_on ={1'b1}; }

		BREAK_INT: coverpoint cov_data.lcr[6] {bins break_int_off ={1'b0};
							bins break_int_on ={1'b1}; }

		DLR: coverpoint cov_data.lcr[7] {bins dlr_off ={1'b0};
						bins dlr_on ={1'b1}; }

		CHAR_X_STOP_X_E_O_PARITY: cross CHAR,STOP,E_O_PARITY;
	endgroup

	covergroup uart_ier;
		option.per_instance=1;

		RD_INT: coverpoint cov_data.ier[0] {bins dis ={1'b0};
							bins en={1'b1}; }
		THR_EMPT: coverpoint cov_data.ier[1] {bins dis ={1'b0};
							bins en = {1'b1}; }
		RLS_INT: coverpoint cov_data.ier[2] {bins dis ={1'b0};
							bins en={1'b1}; }
	endgroup

	covergroup uart_fcr;
		option.per_instance=1;
		
		RFIFO: coverpoint cov_data.fcr[1] {bins dis ={1'b0};
							bins en={1'b1};}
		TFIFO: coverpoint cov_data.fcr[2] {bins dis={1'b0};
							bins en={1'b1};}
		TRG_LVL: coverpoint cov_data.fcr[7:6] {bins one_by ={2'b00};
						bins four_by = {2'b01};
						bins eight_by = {2'b10};
						bins fourteen_by ={2'b11}; }
	endgroup

	covergroup uart_mcr;
		option.per_instance=1;

		LOOP: coverpoint cov_data.mcr[4] {bins dis={1'b0};
						bins en ={1'b1}; }
	endgroup

	covergroup uart_iir;
		option.per_instance=1;

		IIR: coverpoint cov_data.iir[3:1] {bins lsr={3'b011};
						bins rdf ={3'b010};
						bins ti_o={3'b110};
						bins therm ={3'b001}; }
	endgroup

	covergroup uart_lsr;
		option.per_instance=1;
		
		DTR: coverpoint cov_data.lsr[0] {bins fifo_emp={1'b0};
						bins data_avl={1'b1}; }
		OVERRUN: coverpoint cov_data.lsr[1] {bins no_overrun ={1'b0};
							bins overrun ={1'b1}; }
		PARITY: coverpoint cov_data.lsr[2] {bins no_parity={1'b0};
							bins parity={1'b1}; }
		FRAM: coverpoint cov_data.lsr[3] {bins no_frame_err ={1'b0};
						bins frame_err ={1'b1}; }
		BREAK: coverpoint cov_data.lsr[4] {bins no_break_int ={1'b0};
							bins break_int ={1'b1}; }
		THR_EMP: coverpoint cov_data.lsr[5] {bins thr_not_emp ={1'b0};
							bins thr_emp ={1'b1}; }
	endgroup

	function new(string name = "", uvm_component parent);
		super.new(name,parent);
		uart_signals = new();
		uart_lcr = new();
		uart_ier = new();
		uart_fcr = new();
		uart_mcr = new();
		uart_iir = new();
		uart_lsr = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("Scoreboard","get () method failed")
		xtn1 = write_xtn::type_id::create("xtn1");
		xtn2 = write_xtn::type_id::create("xtn2");
		fifo_h = new[e_cfg.no_of_uart_agents];
		foreach(fifo_h[i])
			fifo_h[i]=new($sformatf("fifo_h[%d]",i));
	endfunction
	
	task run_phase(uvm_phase phase);
		fork 
			forever begin
				fifo_h[0].get(xtn1);
				cov_data=xtn1;
				uart_signals.sample();
				uart_lcr.sample();
				uart_ier.sample();
				uart_fcr.sample();
				uart_mcr.sample();
				uart_iir.sample();
				uart_lsr.sample();
			end
			forever begin
				fifo_h[1].get(xtn2);
				cov_data=xtn2;
				uart_signals.sample();
				uart_lcr.sample();
				uart_ier.sample();
				uart_fcr.sample();
				uart_mcr.sample();
				uart_iir.sample();
				uart_lsr.sample();
			end
		join	
	endtask
	
	function void check_phase(uvm_phase phase);
		
		thr1size = xtn1.thr.size();
		$display("thr_1 size =%d",thr1size);
		$display("value of thr1 = %0p",xtn1.thr);

		rb1size = xtn1.rb.size();
		$display("rb_1 size =%d",rb1size);
		$display("value of rb1 = %0p",xtn1.rb);

		thr2size = xtn2.thr.size();
		$display("thr_2 size =%d",thr2size);
		$display("value of thr2 = %0p",xtn2.thr);

		rb2size = xtn2.rb.size();
		$display("rb_2 size =%d",rb2size);
		$display("value of rb2 = %0p",xtn2.rb);

	// THR_EMPTY LOGIC
		if (   xtn1.lsr[5]==1'b1 && xtn2.lsr[5]==1'b1 && xtn1.ier[1]==1 && xtn2.ier[1]==1 && xtn1.iir[3:1]==3'b001 && xtn2.iir[3:1]==3'b001 ) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n THR_EMPTY_TEST PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// TIMEOUT LOGIC
		else if (xtn1.fcr[7:6]!= xtn2.fcr[7:6] && xtn1.ier[2]==1 && xtn2.ier[2]==1) begin
			if ( xtn1.iir[3:1]==3'b110 ) begin
				`uvm_info(get_type_name(),$sformatf("\n\n UART1 TIME_OUT_TEST_PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s ",xtn1.sprint()),UVM_MEDIUM)
			end
			if (xtn2.iir[3:1]==3'b110 ) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n UART2 TIME_OUT_TEST_PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART2: \n%s ",xtn2.sprint()),UVM_MEDIUM)
			end
		//	`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end


	// breakinterupt LOGIC
		else if (   xtn1.lcr[6]==1 && xtn2.lcr[6]==1 && xtn1.ier[2]==1 && xtn2.ier[2]==1 && xtn1.iir[3:1]==3'b011 && xtn2.iir[3:1]==3'b011 && xtn1.lsr[4]==1 && xtn2.lsr[4]==1) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n BREAK_INTERUPT PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// overrun LOGIC
		else if (   xtn1.ier[2]==1 && xtn2.ier[2]==1 && xtn1.iir[3:1]==3'b011 && xtn2.iir[3:1]==3'b011 && xtn1.lsr[1]==1 && xtn2.lsr[1]==1) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n OVERRUN PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// FRAMING LOGIC
		else if (   xtn1.ier[2]==1 && xtn2.ier[2]==1 && xtn1.iir[3:1]==3'b011 && xtn2.iir[3:1]==3'b011 && xtn1.lsr[3]==1 && xtn2.lsr[3]==1) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n FRAMING PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// PARITY_LOGIC		
		else if (  xtn1.lcr[4:3]==2'b11 && xtn2.lcr[4:3]==2'b01  && xtn1.lsr[2]==1 && xtn2.lsr[2]==1) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n PARITY PASSED \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// LOOP_BACK LOGIC
		else if (  xtn1.mcr[4]==1 && xtn2.mcr[4]==1 && xtn1.thr==xtn1.rb && xtn2.thr==xtn2.rb) begin	
				`uvm_info(get_type_name(),$sformatf("\n\n LOOP_BACK SUCCESSFUL \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n FROM SB UART1: \n%s \n FROM SB UART2 \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end

	// FULL_DUPLEX LOGIC
		else if(thr1size !=0 && thr2size !=0 && xtn1.thr == xtn2.rb && xtn1.rb == xtn2.thr) begin
				`uvm_info(get_type_name(),$sformatf("\n\n FULL DUPLEX SUCCESSFUL \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf(" \n FROM SB xtn1: \n%s \n FROM SB xtn2: \n%s", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end
		
	// HALF_DUPLEX LOGIC	
		else if(thr1size !=0 && xtn1.thr == xtn2.rb) begin
				`uvm_info(get_type_name(),$sformatf("\n\n HALF DUPLEX SUCCESSFUL \n"),UVM_LOW)
				`uvm_info(get_type_name(),$sformatf("\n FROM SB xtn1: \n%s \n FROM SB xtn2: \n%s", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		end
	
	// DEFAULT	
		else
			`uvm_info(get_type_name(),$sformatf("\n\nPROTOCOL IS FAILED \n"),UVM_LOW)
			`uvm_info(get_type_name(),$sformatf("\n \n FROM SB UART1: \n%s \n FROM SB UART2: \n%s ", xtn1.sprint(),xtn2.sprint()),UVM_MEDIUM)
		
	endfunction

endclass
