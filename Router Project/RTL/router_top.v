module router_top(input clk, resetn, pkt_vld, read_enb_0, read_enb_1,read_enb_2,
input [7:0]data_in,
output vld_out_0, vld_out_1, vld_out_2, error, busy,
output [7:0]data_out_0, data_out_1, data_out_2);
wire soft_reset_0,full_0,empty_0,soft_reset_1,full_1,empty_1,soft_reset_2,full_2,empty_2,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,parity_done,low_pkt_vld,write_enb_reg;
wire [2:0]write_enb;
wire [7:0]d_in;
//-------fifo instantiation-----

router_fifo FIFO_0(.clk(clk),
.resetn(resetn),
.soft_reset(soft_reset_0),
.write_enb(write_enb[0]),
.read_enb(read_enb_0),
.lfd_state(lfd_state),
.data_in(d_in),
.empty(empty_0),
.full(full_0),
.data_out(data_out_0));

router_fifo FIFO_1(.clk(clk),
.resetn(resetn),
.soft_reset(soft_reset_1),
.write_enb(write_enb[1]),
.read_enb(read_enb_1),
.lfd_state(lfd_state),
.data_in(d_in),
.empty(empty_1),
.full(full_1),
.data_out(data_out_1));

router_fifo FIFO_2(.clk(clk),
.resetn(resetn),
.soft_reset(soft_reset_2),
.write_enb(write_enb[2]),
.read_enb(read_enb_2),
.lfd_state(lfd_state),
.data_in(d_in),
.empty(empty_2),
.full(full_2),
.data_out(data_out_2));

//-------register instantiation-----
router_register REGISTER(.clk(clk),

.resetn(resetn),
.pkt_vld(pkt_vld),
.fifo_full(fifo_full),
.rst_int_reg(rst_int_reg),
.detect_add(detect_add),
.ld_state(ld_state),

.laf_state(laf_state),
.full_state(full_state),
.lfd_state(lfd_state),
.data_in(data_in),
.parity_done(parity_done),
.low_pkt_vld(low_pkt_vld),
.error(error),
.data_out(d_in));

//-------synchronizer instantiation-----

router_sync SYNCHRONIZER(.clk(clk),

.resetn(resetn),
.detect_add(detect_add),
.write_enb_reg(write_enb_reg),
.read_enb_0(read_enb_0),
.read_enb_1(read_enb_1),
.read_enb_2(read_enb_2),
.empty_0(empty_0),
.empty_1(empty_1),
.empty_2(empty_2),
.full_0(full_0),
.full_1(full_1),
.full_2(full_2),
.data_in(data_in[1:0]),
.vld_out_0(vld_out_0),
.vld_out_1(vld_out_1),
.vld_out_2(vld_out_2),
.write_enb(write_enb),
.fifo_full(fifo_full),

.soft_reset_0(soft_reset_0),
.soft_reset_1(soft_reset_1),
.soft_reset_2(soft_reset_2));

//-------fsm instantiation-----
router_fsm FSM(.clk(clk),
.resetn(resetn),
.pkt_vld(pkt_vld),
.parity_done(parity_done),
.soft_reset_0(soft_reset_0),
.soft_reset_1(soft_reset_1),
.soft_reset_2(soft_reset_2),
.fifo_full(fifo_full),
.low_pkt_vld(low_pkt_vld),
.fifo_empty_0(empty_0),
.fifo_empty_1(empty_1),
.fifo_empty_2(empty_2),
.data_in(data_in[1:0]),
.busy(busy),
.detect_add(detect_add),
.ld_state(ld_state),
.laf_state(laf_state),
.full_state(full_state),
.write_enb_reg(write_enb_reg),
.rst_int_reg(rst_int_reg),
.lfd_state(lfd_state));

endmodule
