class uart_test extends uvm_test;
	`uvm_component_utils(uart_test)
	
	env envh;
	env_config e_cfg;
	uart_config u_cfg[];


	int no_of_uart_agents=2;
	int has_scoreboard =1;
	int v_seqr =1;

	function new(string name="uart_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		u_cfg = new[no_of_uart_agents];//
		envh=env::type_id::create("envh",this);

		e_cfg = env_config::type_id::create("e_cfg");
		e_cfg.u_cfg = new[no_of_uart_agents];
		foreach(u_cfg[i]) begin
			u_cfg[i] = uart_config::type_id::create($sformatf("u_cfg[%0d]",i));
			if(!uvm_config_db #(virtual uart_if)::get(this,"",$sformatf("vif_%0d",i),u_cfg[i].vif))
				`uvm_fatal("Test","get() method failed vif_1")
			u_cfg[i].is_active = UVM_ACTIVE;
			e_cfg.u_cfg[i]=u_cfg[i];
		end
		
		e_cfg.no_of_uart_agents=no_of_uart_agents;
		e_cfg.has_scoreboard=has_scoreboard;
		e_cfg.v_seqr = v_seqr;
		uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		uvm_top.print_topology;
	endtask
endclass

class full_test extends uart_test;
	`uvm_component_utils(full_test)
	full_duplex1 fd1;
	full_duplex2 fd2;
	//v_seqs vseqsh;

	function new(string name ="full_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fd1 = full_duplex1::type_id::create("fd1");
		fd2 = full_duplex2::type_id::create("fd2");
		//vseqsh = v_seqs::type_id::create("vseqsh");
		fork
			//foreach(envh.agt_top.u_agnth[i])
			fd1.start(envh.agt_top.u_agnth[0].seqrh);
			fd2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask

endclass


class half_test extends uart_test;
	`uvm_component_utils(half_test)
	half_duplex1 hd1;
	half_duplex2 hd2;
	//v_seqs vseqsh;

	function new(string name ="half_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		hd1 = half_duplex1::type_id::create("hd1");
		hd2 = half_duplex2::type_id::create("hd2");
		//vseqsh = v_seqs::type_id::create("vseqsh");
		fork
			//foreach(envh.agt_top.u_agnth[i])
			hd1.start(envh.agt_top.u_agnth[0].seqrh);
			hd2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask

endclass


class loop_back_test extends uart_test;
	`uvm_component_utils(loop_back_test)
	loop_back1 lb1;
	loop_back2 lb2;
	//v_seqs vseqsh;

	function new(string name ="loop_back_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		lb1 = loop_back1::type_id::create("lb1");
		lb2 = loop_back2::type_id::create("lb2");
		//vseqsh = v_seqs::type_id::create("vseqsh");
		fork
			//foreach(envh.agt_top.u_agnth[i])
			lb1.start(envh.agt_top.u_agnth[0].seqrh);
			lb2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#020000;
		phase.drop_objection(this);
	endtask

endclass

class parity_error_test extends uart_test;
	`uvm_component_utils(parity_error_test)
	parity_error1 pe1;
	parity_error2 pe2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		pe1=parity_error1::type_id::create("pe1");
		pe2=parity_error2::type_id::create("pe2");
		fork
			pe1.start(envh.agt_top.u_agnth[0].seqrh);
			pe2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask
endclass

class framing_error_test extends uart_test;
	`uvm_component_utils(framing_error_test)
	framing_error1 fe1;
	framing_error2 fe2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fe1=framing_error1::type_id::create("fe1");
		fe2=framing_error2::type_id::create("fe2");
		fork
			fe1.start(envh.agt_top.u_agnth[0].seqrh);
			fe2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask
endclass


class overrun_error_test extends uart_test;
	`uvm_component_utils(overrun_error_test)
	overrun_error1 oe1;
	overrun_error2 oe2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		oe1=overrun_error1::type_id::create("oe1");
		oe2=overrun_error2::type_id::create("oe2");
		fork
			oe1.start(envh.agt_top.u_agnth[0].seqrh);
			oe2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask
endclass


class breakinterrupt_error_test extends uart_test;
	`uvm_component_utils( breakinterrupt_error_test)
	 breakint_error1 be1;
	 breakint_error2 be2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		be1= breakint_error1::type_id::create("be1");
		be2= breakint_error2::type_id::create("be2");
		fork
			be1.start(envh.agt_top.u_agnth[0].seqrh);
			be2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask
endclass

class timeout_error_test extends uart_test;
	`uvm_component_utils(timeout_error_test)
	 timeout_error1 te1;
	 timeout_error2 te2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		te1= timeout_error1::type_id::create("te1");
		te2= timeout_error2::type_id::create("te2");
		fork
			te1.start(envh.agt_top.u_agnth[0].seqrh);
			te2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#20000;
		phase.drop_objection(this);
	endtask
endclass

class thr_empty_error_test extends uart_test;
	`uvm_component_utils(thr_empty_error_test)
	 thr_empty_error1 te1;
	 thr_empty_error2 te2;

	function new(string name="", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		te1= thr_empty_error1::type_id::create("te1");
		te2= thr_empty_error2::type_id::create("te2");
		fork
			te1.start(envh.agt_top.u_agnth[0].seqrh);
			te2.start(envh.agt_top.u_agnth[1].seqrh);
		join
		#40;
		phase.drop_objection(this);
	endtask
endclass
