interface fifo_if #(
	parameter DATA_SZIE = 8
)(
	input sys_clk_i,
	input sys_rstn_i
);

logic wr_l;
logic[DATA_SZIE-1:0] din_l;
logic rd_l;
logic[DATA_SZIE-1:0] dout_l;
logic full_l;
logic empty_l;


endinterface
