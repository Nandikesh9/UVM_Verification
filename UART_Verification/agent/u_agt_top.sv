class u_agt_top extends uvm_env;
	`uvm_component_utils(u_agt_top)

	env_config e_cfg;
	uart_config u_cfg[];
	uart_agent u_agnth[];

	function new(string name ="u_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal(get_full_name(),"get () method failed")
		u_agnth = new[e_cfg.no_of_uart_agents];
		foreach(u_agnth[i]) begin
			u_agnth[i] = uart_agent::type_id::create($sformatf("u_agnth[%0d]",i),this);
			uvm_config_db #(uart_config)::set(this,$sformatf("u_agnth[%0d]*",i),"uart_config",e_cfg.u_cfg[i]);
		end
	endfunction
endclass
