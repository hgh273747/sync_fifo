class fifo_driver extends uvm_driver#(fifo_transaction);
	`uvm_component_utils(fifo_driver)
	
	virtual fifo_if vif;
	
	function new(string name = "fifo_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif))
			`uvm_fatal("fifo_driver","virtual interface must be set for vif!!!")
	endfunction
	
	extern task main_phase(uvm_phase phase);
	extern task drive_one_pkt(fifo_transaction tr);
	
endclass

task fifo_driver::main_phase(uvm_phase phase);
	vif.wr_port.din_l <= `DATA_SIZE{1'b0};
	vif.wr_port.wr_l <= 1'b0;
	while(!vif.rstn_i);
		@(posedge vif.clk_i);
	while(1) begin
		seq_item_port.get_next_item(req);
		drive_one_pkt(req);
		seq_item_port.item_done();
	end
endtask

task fifo_driver::drive_one_pkt(fifo_transaction tr);
	bit[`DATA_SIZE-1:0] data_q[];
	int data_size;
	data_size = tr.pack_bytes(data_q) / (`DATA_SIZE / 4);
	`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
	repeat(3)@(posedge vif.clk_i);
	for(int i=0; i<data_size;i++) begin
		while(!vif.full_l) begin
			vif.wr_port.wr_l <= 1'b0;
			vif.wr_port.din_l <= `DATA_SIZE{1'b0};
			@(posedge vif.clk_i);
		end
		vif.wr_port.wr_l <= 1'b0;
		vif.wr_port.din_l <= data_q[i];
		@(posedge vif.clk_i);
	end
	vif.wr_port.wr_l <= 1'b0;
	vif.wr_port.din_l <= `DATA_SIZE{1'b0};
	@(posedge vif.clk_i);
	`uvm_info("fifo_driver","end drive one pkt",UVM_LOW);
endtask