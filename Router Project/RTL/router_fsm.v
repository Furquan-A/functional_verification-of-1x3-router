module router_fsm(input clk,resetn,pkt_vld,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_vld,fifo_empty_0,fifo_empty_1,fifo_empty_2,
	input [1:0]data_in,
output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state
);
//Defining the states
parameter DECODE_ADDRESS = 3'b000,
LOAD_FIRST_DATA = 3'b001,
WAIT_TILL_EMPTY = 3'b010,
LOAD_DATA = 3'b011,
LOAD_PARITY = 3'b100,
CHECK_PARITY_ERROR = 3'b101,
FIFO_FULL_STATE = 3'b110,
LOAD_AFTER_FULL = 3'b111;

reg [2:0]STATE,NEXT_STATE;
//reg [1:0] addr;
//addr logic
/*always@(posedge clk)
begin
if(~resetn)
addr <= 2'b0;
else if(detect_add)
addr <= data_in;
end
*/

//logic for present state
always@(posedge clk)
begin
if(~resetn)
STATE <= DECODE_ADDRESS;
else if(soft_reset_0 || soft_reset_1 || soft_reset_2 )
STATE <= DECODE_ADDRESS;
else
STATE <= NEXT_STATE;
end
//logic for next state
always@(*)
begin
NEXT_STATE = DECODE_ADDRESS;
case(STATE)
DECODE_ADDRESS : begin

if((pkt_vld & (data_in[1:0] == 0) & fifo_empty_0) |
(pkt_vld & (data_in[1:0] == 1) & fifo_empty_1) | (pkt_vld & (data_in[1:0] ==
2) & fifo_empty_2))

NEXT_STATE = LOAD_FIRST_DATA;
else if((pkt_vld & (data_in[1:0] == 0) &

!fifo_empty_0) | (pkt_vld & (data_in[1:0] == 1) & !fifo_empty_1) | (pkt_vld &
(data_in[1:0] == 2) & !fifo_empty_2))

NEXT_STATE = WAIT_TILL_EMPTY;
else
NEXT_STATE = DECODE_ADDRESS;
end

LOAD_FIRST_DATA : begin

NEXT_STATE = LOAD_DATA;
end

WAIT_TILL_EMPTY : begin

if((!fifo_empty_0 /*&& (addr == 0)*/) ||

(!fifo_empty_1 /*&& (addr == 1)*/) || (!fifo_empty_2 /*&& (addr == 2)*/))
NEXT_STATE = WAIT_TILL_EMPTY;
else if((fifo_empty_0 /*&& (addr == 0)*/) ||
(fifo_empty_1 /*&& (addr == 1)*/) || (fifo_empty_2 /*&& (addr == 2)*/))
NEXT_STATE = LOAD_FIRST_DATA;
else
NEXT_STATE = WAIT_TILL_EMPTY;
end

LOAD_DATA : begin
if(fifo_full)
NEXT_STATE = FIFO_FULL_STATE;
else if(!fifo_full && !pkt_vld)
NEXT_STATE = LOAD_PARITY;
else
NEXT_STATE = LOAD_DATA;
end

LOAD_PARITY : begin

NEXT_STATE = CHECK_PARITY_ERROR;
end

CHECK_PARITY_ERROR: begin
if(fifo_full)
NEXT_STATE = FIFO_FULL_STATE;
else
NEXT_STATE = DECODE_ADDRESS;
end

FIFO_FULL_STATE : begin
if(!fifo_full)
NEXT_STATE = LOAD_AFTER_FULL;
else if(fifo_full)
NEXT_STATE = FIFO_FULL_STATE;
end

LOAD_AFTER_FULL : begin

if(!parity_done && !low_pkt_vld)
NEXT_STATE = LOAD_DATA;
else if(!parity_done && low_pkt_vld)
NEXT_STATE = LOAD_PARITY;

else if(parity_done)
NEXT_STATE = DECODE_ADDRESS;
end

endcase
end
//logic for output
assign ld_state = (STATE == LOAD_DATA) ? 1'b1 : 1'b0;
assign lfd_state = (STATE == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;
assign detect_add = (STATE == DECODE_ADDRESS) ? 1'b1 : 1'b0;
assign laf_state = (STATE == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
assign full_state = (STATE == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
assign rst_int_reg = (STATE == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
assign write_enb_reg = (STATE == LOAD_DATA ||STATE ==
LOAD_PARITY || STATE == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
assign busy = (STATE == LOAD_DATA || STATE == DECODE_ADDRESS) ?1'b0 : 1'b1;
endmodule
