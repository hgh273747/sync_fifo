class fifo_transaction extends uvm_sequence_item;
	rand bit[DATA_SZIE-1] data[];
	
	constraint data_cons{
		data.size >= 1;
		data.size <= 512;
	}
	
	`uvm_object_utils_begin(fifo_transaction)
		`uvm_field_array_int(data,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "fifo_transaction");
		super.new(name);
	endfunction
	
endclass
