class write_xtn extends uvm_sequence_item;
	`uvm_object_utils(write_xtn)
	rand bit[2:0] wb_adr_i;
	rand bit[7:0] wb_dat_i;
	rand bit  wb_we_i;
	bit[7:0] wb_dat_o;
	bit wb_rst_i;
	bit wb_ack_o;
	bit int_o;	
	bit [3:0] wb_sel_i;
	bit wb_stb_i, wb_cyc_i;
	bit [7:0] ier,iir,fcr,lcr,dll,dlm,msr,mcr,lsr;
	bit [7:0] thr[$], rb[$];

	function new(string name="write_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("wb_rst_i",this.wb_rst_i,1,UVM_BIN);
		printer.print_field("wb_adr_i",this.wb_adr_i,3,UVM_DEC);
		printer.print_field("wb_dat_i",this.wb_dat_i,8,UVM_DEC);
		printer.print_field("wb_dat_o",this.wb_dat_o,8,UVM_DEC);
		printer.print_field("wb_we_i",this.wb_we_i,1,UVM_BIN);
		printer.print_field("wb_stb_i",this.wb_stb_i,1,UVM_BIN);
		printer.print_field("wb_cyc_i",this.wb_cyc_i,1,UVM_BIN);
		printer.print_field("wb_ack_o",this.wb_ack_o,1,UVM_BIN);
		printer.print_field("int_o",this.int_o,1,UVM_BIN);
		printer.print_field("dll(DLR_LSB)", this.dll,8,UVM_BIN);
		printer.print_field("dlm(DLR_MSB)", this.dlm,8,UVM_BIN);

		//if(this.ier !=0)
			printer.print_field("ier",this.ier,8,UVM_BIN);
		//if(this.iir !=0)
			printer.print_field("iir",this.iir,8,UVM_BIN);
		//if(this.fcr !=0)
			printer.print_field("fcr",this.fcr,8,UVM_BIN);
		//if(this.lcr !=0)
			printer.print_field("lcr",this.lcr,8,UVM_BIN);
		//if(this.msr !=0)
			printer.print_field("msr",this.msr,8,UVM_BIN);
	//	if(this.mcr !=0)
			printer.print_field("mcr",this.mcr,8,UVM_BIN);
		//if(this.lsr !=0)
			printer.print_field("lsr",this.lsr,8,UVM_BIN);
		
		foreach(thr[i])
			printer.print_field("thr[i]",this.thr[i],8,UVM_DEC);
		foreach(rb[i]) //check
			printer.print_field("rb[i]",this.rb[i],8,UVM_DEC);
	endfunction 
endclass
