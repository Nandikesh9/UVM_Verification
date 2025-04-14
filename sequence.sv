class b_sequence extends uvm_sequence #(write_xtn);
	`uvm_object_utils(b_sequence)

	function new(string name ="");
		super.new(name);
	endfunction
endclass


class full_duplex1 extends b_sequence;
	`uvm_object_utils(full_duplex1)

	function new(string name="");
		super.new(name);
	endfunction

	task body();

		req = write_xtn::type_id::create("req");
		// 1 Line Control Register(LCR) 7th bit as 1, to access DLR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000;});
		finish_item(req);

		//2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000000;});
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); // 163
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
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b01000000;});  // 64
		finish_item(req);

		// 8 IIR to check data present in the reciever buffer are not
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		// step 9
		if(req.iir[3:1] == 3'b010 ) begin
			start_item(req);	
			assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_dat_i == 8'b0000_0000;});
			`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
			finish_item(req);
		end
	endtask

endclass

 
class full_duplex2 extends b_sequence;
	`uvm_object_utils(full_duplex2)

	function new(string name="");
		super.new(name);
	endfunction

	task body();
		req= write_xtn::type_id::create("req");

		// 1 Line Control Register(LCR) 7th bit as 1, to access DLR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000;});
		finish_item(req);

		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0001;});	// 256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;});	// 070
		finish_item(req);								//------------------
												//	   356 

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
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b00011001;}); //25
		finish_item(req);

		// 8 IIR to check data present in the reciever buffer are not
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		// step 9
		if(req.iir[3:1] == 3'b010) begin
			start_item(req);	
			assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_dat_i ==8'b0000_0000;});
			`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
			finish_item(req);
		end
			
	endtask
endclass

//------------------------------------------------------------------ HALF_DUPLEX --------------------------------------------------------
class half_duplex1 extends b_sequence ;
	`uvm_object_utils(half_duplex1)

	function new(string name="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");
	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i ==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);

			
		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000000;});
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;});
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000101;});
		finish_item(req);

		// 7 THR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b00011001;}); //25
		finish_item(req);
	endtask
endclass

class half_duplex2 extends b_sequence ;
	`uvm_object_utils(half_duplex2)

	function new(string name="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");
	
		// 1 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i ==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);

		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //70
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000101;});
		finish_item(req);

		// 7 THR
	
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//9 Reading from RB
		if(req.iir[3:1] == 3'b010) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass

//------------------------------------------------------------------ LOOP_BACK --------------------------------------------------------
class loop_back1 extends b_sequence;
	`uvm_object_utils(loop_back1)

	function new(string name="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");
				
		// 1 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i ==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);

		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); //070
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 making MCR 4th bit as high to act as loop_back mode
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==4; wb_we_i==1; wb_dat_i ==8'b00010000;});
		finish_item(req);

		// 7 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 8 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
		finish_item(req); 
		
		// 9 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//10 Reading from RB
		if(req.iir[3:1] == 3'b010) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class loop_back2 extends b_sequence;
	`uvm_object_utils(loop_back2)

	function new(string name="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");
		
		// 1 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i ==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);

		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //070
		finish_item(req);

		// 4 LCR select the general registers and how many bits are trasmitted
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b00000011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		// 6 making MCR 4th bit as high to act as loop_back mode
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==4; wb_we_i==1; wb_dat_i ==8'b00010000;});
		finish_item(req);
/*
		// 7 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000001;});
		finish_item(req);

		// 8 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
		finish_item(req); 
		
		// 9 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//10 Reading from RB
		if(req.iir[3:1] == 3'b010) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end	*/	
	endtask
endclass

class parity_error1 extends b_sequence;
	`uvm_object_utils(parity_error1)

	function new(string name="");
		super.new(name);
	endfunction

	task body();

		req = write_xtn::type_id::create("req");
		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00000;}); //000
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0010;}); //163
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0001_1010;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000100;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_0001;});
		finish_item(req); 
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from RB
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end	

	endtask
endclass

class parity_error2 extends b_sequence;
	`uvm_object_utils(parity_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_1010;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000100;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_0011;});
		finish_item(req); 
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass

class framing_error1 extends b_sequence;
	`uvm_object_utils(framing_error1)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_00001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0001;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b00000101;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
		finish_item(req); 
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class framing_error2 extends b_sequence;
	`uvm_object_utils(framing_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0000;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0101;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass

class overrun_error1 extends b_sequence;
	`uvm_object_utils(overrun_error1)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //000
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0000_1110;}); //163
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0100;});
		finish_item(req);

		// 7 thr
		repeat(19) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
			finish_item(req);
		end
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
/*		repeat(10) begin
			if(req.iir[3:1] == 3'b011) begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
				finish_item(req);
			end
		end*/

	endtask
endclass

class overrun_error2 extends b_sequence;
	`uvm_object_utils(overrun_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0001_1011;}); //070
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0100;});
		finish_item(req);

		// 7 thr
		repeat(19) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
			finish_item(req); 
		end

		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	/*	repeat(10) begin
			if(req.iir[3:1] == 3'b011) begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
				finish_item(req);
			end
		end*/
	endtask
endclass


class breakint_error1 extends b_sequence;
	`uvm_object_utils(breakint_error1)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0100_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0100;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class breakint_error2 extends b_sequence;
	`uvm_object_utils(breakint_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0100_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0100;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b011)  begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class timeout_error1 extends b_sequence;
	`uvm_object_utils(timeout_error1)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b0100_0110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0101;});
		finish_item(req);
	
		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
		finish_item(req); 
		
	
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b110) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class timeout_error2 extends b_sequence;
	`uvm_object_utils(timeout_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b11000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0101;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b110) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==0; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass


class thr_empty_error1 extends b_sequence;
	`uvm_object_utils(thr_empty_error1)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0000;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b1010_0011;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b00000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0010;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0001_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);

		//09 Reading from LSR
		if(req.iir[3:1] == 3'b001) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass

class thr_empty_error2 extends b_sequence;
	`uvm_object_utils(thr_empty_error2)
	
	function new(string name ="");
		super.new(name);
	endfunction

	task body();
		req = write_xtn::type_id::create("req");

		//lcr[7] ==1
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3;wb_we_i==1; wb_dat_i == 8'b1000_0000;});
		finish_item(req);


		// 2 selecting the DLR MSB and stored the last(msb 8 bits of divison value 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0001;}); //256
		finish_item(req);

		// 3 selecting the DLR LSB and stored the first 8bits of division value
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_dat_i==8'b0100_0110;}); //076
		finish_item(req);

		// 4 LCR select the general registers, how many bits are trasmitted and enabling parity. 
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b0000_0011;});
		finish_item(req);

		// 5 FIFO Controled Register FCR
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_dat_i==8'b01000110;});
		finish_item(req);

		
		// 6 Interput Enable Register
		start_item(req);	
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_dat_i==8'b0000_0010;});
		finish_item(req);

		// 7 thr
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i ==1; wb_dat_i ==8'b0000_1001;});
		finish_item(req); 
		
		
		// 8 IIR
		start_item(req);
		assert(req.randomize() with {wb_adr_i ==2; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
		finish_item(req);
		get_response(req);
/**/
		//09 Reading from LSR
		if(req.iir[3:1] == 3'b001) begin
			start_item(req);
			assert(req.randomize() with {wb_adr_i ==5; wb_we_i ==0; wb_dat_i==8'b0000_0000;});
			finish_item(req);
		end
	endtask
endclass
