`define log2(VALUE) ((VALUE<=1)? 0 : (VALUE<=2)? 1 : (VALUE<=4)? 2 : (VALUE<=8)? 3 : (VALUE<=16)? 4 : (VALUE<=32)? 5 : (VALUE<=64)? 6 : (VALUE<=128)? 7 : (VALUE<=256)? 8 : (VALUE<=512)? 9 : (VALUE<=1024)? 10 : (VALUE<=2048)? 11 : (VALUE<=4096)? 12 : (VALUE<=8192)? 13 : (VALUE<=16384)? 14 : (VALUE<=32768)? 15 : (VALUE<=65536)? 16 : (VALUE<=131072)? 17 : (VALUE<=262144)? 18 : (VALUE<=524288)? 19 : (VALUE<=1048576)? 20 : (VALUE<=1048576*2)? 21 : (VALUE<=1048576*4)? 22 : (VALUE<=1048576*8)? 23 : (VALUE<=1048576*16)? 24 : 25)

module sync_fifo #(
	parameter DATA_SZIE = 8,
	parameter DATA_DEPTH = 16,
	parameter APT_SIZE = `log2(DATA_DEPTH)
)(
	input                 clk_i,
	input                 rstn_i,
	input                 fifo_wr_i,
	input                 fifo_rd_i,
	input[DATA_SZIE-1:0]  fifo_din_i,
	output[DATA_SZIE-1:0] fifo_dout_o,
	output                fifo_full_o,
	output                fifo_empty_o,
	output[APT_SIZE:0]    fifo_usedw_o
);

logic[DATA_SZIE-1:0] mem_l[DATA_DEPTH-1:0];

logic[APT_SIZE:0] cnt_l;
logic[APT_SIZE-1:0] fifo_wr_ptr_l;
logic[APT_SIZE-1:0] fifo_rd_ptr_l;

logic fifo_wr_l;
logic fifo_rd_l;
logic[DATA_SZIE-1:0] fifo_dout_l;
logic fifo_full_l;
logic fifo_empty_l;

assign fifo_wr_l = fifo_wr_i && !fifo_full_l;
assign fifo_rd_l = fifo_rd_i && !fifo_empty_l;


always_latch@(posedge clk_i or negedge rstn_i)
begin
	if(!rstn_i)
		for(int i=0;i<DATA_DEPTH;i++) begin
		  mem_l[i] <= {DATA_SZIE{1'b0}};
		end
	else if(fifo_wr_l)
		mem_l[fifo_wr_ptr_l] <= fifo_din_i;
end

always_comb@(*)
begin
	if(!rstn_i)
		fifo_dout_l <= {DATA_SZIE{1'b0}};
	else if(fifo_rd_l)
		fifo_dout_l <= mem_l[fifo_rd_ptr_l];
	else if(!fifo_empty_l)
		fifo_dout_l <= {DATA_SZIE{1'b0}};
end

always_ff@(posedge clk_i or negedge rstn_i)
begin
	if(!rstn_i)
		cnt_l <= {DATA_DEPTH{1'b0}};
	else if(fifo_wr_l && fifo_rd_l)
		cnt_l <= cnt_l;
	else if(fifo_wr_l)
		cnt_l <= cnt_l + 1;
	else if(fifo_rd_l)
		cnt_l <= cnt_l - 1;
	else
		cnt_l <= cnt_l;
end

always_ff@(posedge clk_i or negedge rstn_i)
begin
	if(!rstn_i)
		fifo_wr_ptr_l <= {APT_SIZE-1{1'b0}};
	else if(fifo_wr_l)
		fifo_wr_ptr_l <= fifo_wr_ptr_l + 1;
	else
		fifo_wr_ptr_l <= fifo_wr_ptr_l;
end

always_ff@(posedge clk_i or negedge rstn_i)
begin
	if(!rstn_i)
		fifo_rd_ptr_l <= {APT_SIZE-1{1'b0}};
	else if(fifo_rd_l)
		fifo_rd_ptr_l <= fifo_rd_ptr_l + 1;
	else
		fifo_rd_ptr_l <= fifo_rd_ptr_l;
end

assign fifo_empty_l = (cnt_l == 0)? 1'b1 : 1'b0; 
assign fifo_full_l = (cnt_l == APT_SIZE || rstn_i == 1'b0 )? 1'b1 : 1'b0;
assign fifo_empty_o = fifo_empty_l;
assign fifo_full_o = fifo_full_l;

assign fifo_usedw_o = cnt_l;

assign fifo_dout_o = fifo_dout_l;

endmodule
