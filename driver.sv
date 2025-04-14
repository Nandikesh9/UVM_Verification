class driver extends uvm_driver #(write_xtn);
	`uvm_component_utils(driver)

	virtual uart_if.DRV_MP vif;
	uart_config u_cfg;

	function new(string name ="driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",u_cfg))
			`uvm_fatal(get_full_name(),"get method failed")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = u_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b0;
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b1;
		vif.drv_cb.wb_stb_i <= 1'b0;
		vif.drv_cb.wb_cyc_i <= 1'b0;
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b0;

		forever begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
			
	endtask

	task send_to_dut(write_xtn xtn );
		@(vif.drv_cb);
		vif.drv_cb.wb_sel_i <= 4'b0001;
		vif.drv_cb.wb_stb_i <= 1'b1; 
		vif.drv_cb.wb_cyc_i <= 1'b1;
		vif.drv_cb.wb_we_i <= xtn.wb_we_i;
		vif.drv_cb.wb_adr_i <= xtn.wb_adr_i;
		vif.drv_cb.wb_dat_i <= xtn.wb_dat_i;
			`uvm_info("DRIVER",$sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW);
		wait(vif.drv_cb.wb_ack_o);
		vif.drv_cb.wb_stb_i <= 1'b0;
		vif.drv_cb.wb_cyc_i <= 1'b0;
		if(xtn.wb_adr_i==2 && xtn.wb_we_i==0) begin
			wait(vif.drv_cb.int_o);
			@(vif.drv_cb);
			@(vif.drv_cb);
			xtn.iir = vif.drv_cb.wb_dat_o;
			seq_item_port.put_response(xtn);
			`uvm_info("DRIVER",$sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW);
		end
			
			 
	endtask

endclass
