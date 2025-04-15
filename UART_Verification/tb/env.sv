
class env extends uvm_env;
	`uvm_component_utils(env)

	env_config e_cfg;
	u_agt_top agt_top;
	
	scoreboard sb;
	v_seqr vseqrh;

	function new(string name ="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("ENV","get() method failed")
		agt_top = u_agt_top::type_id::create("agt_top",this);
	
		if(e_cfg.has_scoreboard)
			sb = scoreboard::type_id::create("sb",this);
		if(e_cfg.v_seqr)
			vseqrh=v_seqr::type_id::create("vseqrh",this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	/*	if(e_cfg.v_seqr) begin
			foreach(vseqrh.seqrh[i])
				vseqrh.seqrh[i] = agt_top.u_agnth[i].seqrh;
		end*/
		if(e_cfg.has_scoreboard) begin
			foreach(agt_top.u_agnth[i])
				agt_top.u_agnth[i].monh.monitor_port.connect(sb.fifo_h[i].analysis_export);
		end
	endfunction

endclass
