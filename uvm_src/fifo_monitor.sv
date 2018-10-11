class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor)
	
	virtual fifo_if vif;
	
	uvm_analysis_port #(fifo_transaction) ap;
	
	function new(string name = "fifo_monitor",uvm_component parent = null);
		super.new(name,parent);
	end
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif);
			`uvm_fatal("fifo_monitor","virtual interface must be set for vif!!!")
		ap = new("ap",this);
	endfunction

	extern task main_phase(uvm_phase phase);
	extern task collect_one_pkt(fifo_transaction tr);
	
endclass

task fifo_monitor::main_phase(uvm_phase phase);
	fifo_transaction tr;
	while(1) begin
		tr = new("tr");
		collect_one_pkt(tr);
		ap.write(tr);
	end
endtask

task fifo_monitor::collect_one_pkt(fifo_transaction tr);
	byte unsigned data_q[$];
	byte unsigned data_array[];
	logic[`DATA_SIZE-1:0] data;
	int data_size;
endtask
