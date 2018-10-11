interface fifo_if(
	input sys_clk_i,
	input sys_rstn_i
);

logic                 wr_l;
logic[`DATA_SZIE-1:0] din_l;
logic                 rd_l;
logic[`DATA_SZIE-1:0] dout_l;
logic                 full_l;
logic                 empty_l;

modport wr_port(input wr_l,din_l,output full_l);

modport rd_port(input rd_l,output dout_l,empty_l);

endinterface
