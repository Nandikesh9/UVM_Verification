class uart_agent extends uvm_agent;
	`uvm_component_utils(uart_agent)

	driver drvh;
	sequencer seqrh;
	monitor monh;	
	uart_config u_cfg;

	function new(string name="uart_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",u_cfg))
			`uvm_fatal("AGENT","get() method failed")
		monh = monitor::type_id::create("monh",this);
		if(u_cfg.is_active == UVM_ACTIVE) begin
			drvh = driver::type_id::create("drvh",this);
			seqrh = sequencer::type_id::create("seqrh",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(u_cfg.is_active == UVM_ACTIVE) begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
		end
		

	endfunction
endclass
