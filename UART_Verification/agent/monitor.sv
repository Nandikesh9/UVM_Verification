
class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	virtual uart_if.MON_MP vif;
	uart_config u_cfg;
	write_xtn xtn;
	
	uvm_analysis_port #(write_xtn) monitor_port;	

	function new(string name ="monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",u_cfg))
			`uvm_fatal("Monitor","get method failed")
		xtn = write_xtn::type_id::create("xtn");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = u_cfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

	task collect_data();
		@(vif.mon_cb);
		wait(vif.mon_cb.wb_ack_o)
		xtn.wb_rst_i = vif.mon_cb.wb_rst_i;
		xtn.wb_we_i = vif.mon_cb.wb_we_i;
		xtn.wb_sel_i = vif.mon_cb.wb_sel_i;
		xtn.wb_stb_i = vif.mon_cb.wb_stb_i;
		xtn.wb_cyc_i = vif.mon_cb.wb_cyc_i;
		xtn.wb_adr_i = vif.mon_cb.wb_adr_i;
		xtn.wb_dat_i = vif.mon_cb.wb_dat_i;
		xtn.wb_dat_o = vif.mon_cb.wb_dat_o;
		xtn.wb_ack_o = vif.mon_cb.wb_ack_o;
		xtn.int_o = vif.mon_cb.int_o;
		
	//1 making lcr msb 1
		if(xtn.wb_adr_i == 3 && xtn.wb_we_i == 1)
			xtn.lcr = vif.mon_cb.wb_dat_i;
	//2 writing into dlm
		if(xtn.lcr[7] == 1 && xtn.wb_adr_i == 1 && xtn.wb_we_i ==1)
			xtn.dlm = vif.mon_cb.wb_dat_i;
	//3 writing into dll
		if(xtn.lcr[7] == 1 && xtn.wb_adr_i == 0 && xtn.wb_we_i ==1)
			xtn.dll = vif.mon_cb.wb_dat_i;
	//4 lcr as 0000_0011
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 3 && xtn.wb_we_i==1)
			xtn.lcr = vif.mon_cb.wb_dat_i;
	//5 making fcr as 0000_0110
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 2 && xtn.wb_we_i==1)
			xtn.fcr = vif.mon_cb.wb_dat_i;
	//6 making mcr as 0001_0000
		if(xtn.lcr[7] ==0 && xtn.wb_adr_i == 4 && xtn.wb_we_i ==1)
			xtn.mcr = vif.mon_cb.wb_dat_i;
	//7 making ier as 0000_0101
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 1 && xtn.wb_we_i ==1)
			xtn.ier = vif.mon_cb.wb_dat_i;
	//8 loading into thr
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 0 && xtn.wb_we_i==1) begin
			@(vif.mon_cb);
			xtn.thr.push_back(vif.mon_cb.wb_dat_i);
		end
	//9 loading into rb
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 0 && xtn.wb_we_i==0) begin
			@(vif.mon_cb);
			xtn.rb.push_back(vif.mon_cb.wb_dat_o);
		end
	

	//10 checking for data is available in iir
		if(xtn.lcr[7] == 0 && xtn.wb_adr_i == 2 && xtn.wb_we_i ==0) begin
			wait(vif.mon_cb.int_o)
			@(vif.mon_cb);
			xtn.iir = vif.mon_cb.wb_dat_o;
		end
	//11 accessing lsr 
		if(xtn.lcr[7]==0 && xtn.wb_adr_i == 5 && xtn.wb_we_i ==0) begin
			xtn.lsr = vif.mon_cb.wb_dat_o;
		end
		`uvm_info("Monitor data",$sformatf("From Monitor \n %s",xtn.sprint()),UVM_LOW)
		monitor_port.write(xtn);
	endtask
endclass
