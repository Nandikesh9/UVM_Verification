class v_seqr extends uvm_sequencer #(write_xtn);
	`uvm_component_utils(v_seqr)
	
	sequencer seqrh[];

	env_config e_cfg;

	function new(string name="v_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal(get_full_name(),"get method failed")
		seqrh = new[e_cfg.no_of_uart_agents];
	endfunction
endclass
