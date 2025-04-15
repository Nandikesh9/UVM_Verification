class v_seqs extends uvm_sequence #(write_xtn);
	`uvm_object_utils(v_seqs)
	
	
	sequencer seqrh[];
	env_config e_cfg;
	v_seqr vseqrh;

	function new(string name ="v_seqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",e_cfg))
			`uvm_fatal(get_type_name(),"get() method failed")
		seqrh = new[e_cfg.no_of_uart_agents];
		assert($cast(vseqrh,m_sequencer))
		else begin
			`uvm_fatal("V_SEQS","error in $cast of virtual sequencer")
		end

		foreach(seqrh[i])
			seqrh[i]=vseqrh.seqrh[i];

	endtask
endclass

/*
class full_duplex1 extends v_seqs;
	`uvm_object_utils(full_duplex1)

	function new(string name="");
		super.new(name);
	endfunction

	task body();


		// 1 Line Control Register(LCR) 7th bit as 1, to access DLR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000;});
		finish_item(req);

		//2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b01000110;});
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 7 THR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b01000000;});
		finish_item(req);

		// 8 IIR to check data present in the reciever buffer are not
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0;});// wb_dat_i==8'b01000000};);
		finish_item(req);
		get_response(req);

		// step 9
		if(req.iir[3:1] == 2)
			start_item(req);	
			assert(req.randomize() with {wb_adr_i==0; wb_we_i==0;});
			$display("----------------------------------------------FULL DUPLEX SEQUENCE 1-----------------------------");
			`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
			finish_item(req);
	endtask

endclass

class full_duplex2 extends b_sequence;
	`uvm_object_utils(full_duplex2)

	function new(string name="");
		super.new(name);
	endfunction

	task body();

		// 1 Line Control Register(LCR) 7th bit as 1, to access DLR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000;});
		finish_item(req);

		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000000;});
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b10100011;});
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 7 THR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b00011001;});
		finish_item(req);

		// 8 IIR to check data present in the reciever buffer are not
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0;});// wb_dat_i==8'b01000000};);
		finish_item(req);
		get_response(req);

		// step 9
		if(req.iir[3:1] == 2)
			start_item(req);	
			assert(req.randomize() with {wb_adr_i==0; wb_we_i==0;});
			$display("----------------------------------------------FULL DUPLEX SEQUENCE 2-----------------------------");
			`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
			finish_item(req);
	endtask

endclass*/ 

