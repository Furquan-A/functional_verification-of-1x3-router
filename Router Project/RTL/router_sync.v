module router_sync(input clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,input [1:0] data_in,
output vld_out_0,vld_out_1,vld_out_2,
output reg [2:0] write_enb,
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2
);
reg [1:0] int_addr_reg;
reg [4:0] timer_0,timer_1,timer_2;
//Latching the address ----------- Combinational logic
always@(*)
begin
if(~resetn)
int_addr_reg = 2'b11;
else if(detect_add == 1'b1)
int_addr_reg = data_in;
end
//fifo full logic and write enable logic
always@(*)
begin
case(int_addr_reg)
2'b00:begin
fifo_full<=full_0;
if(write_enb_reg)
write_enb<=3'b001;
else

write_enb<=0;
end
2'b01:begin
fifo_full<=full_1;
if(write_enb_reg)
write_enb<=3'b010;
else
write_enb<=0;
end
2'b10:begin
fifo_full<=full_2;
if(write_enb_reg)
write_enb<=3'b100;
else
write_enb<=0;
end
default:begin
fifo_full<=0;
write_enb<=0;
end
endcase
end

//soft_reset_0 logic ----------- Sequential logic
always@(posedge clk)
begin
if(~resetn)
begin
timer_0 <= 0;
soft_reset_0 <= 0;
end
else if(vld_out_0)
begin
if(read_enb_0 == 0)

begin
if(timer_0 == 29)
begin
soft_reset_0 <= 1;
timer_0 <= 0;
end
else
begin
soft_reset_0 <= 0;
timer_0 <= timer_0 + 1;
end
end
else
timer_0 <= 0;
end
end

//soft_reset_1 logic ----------- Sequential logic
always@(posedge clk)
begin
if(~resetn)
begin
timer_1 <= 0;
soft_reset_1 <= 0;
end
else if(vld_out_1)
begin
if(read_enb_1 == 0)
begin
if(timer_1 == 29)
begin
soft_reset_1 <= 1;
timer_1 <= 0;
end
else

begin
soft_reset_1 <= 0;
timer_1 <= timer_1 + 1;
end
end
else
timer_1 <= 0;
end
end
//soft_reset_2 logic ----------- Sequential logic
always@(posedge clk)
begin
if(~resetn)
begin
timer_2 <= 0;
soft_reset_2 <= 0;
end
else if(vld_out_2)
begin
if(read_enb_2 == 0)
begin
if(timer_2 == 29)
begin
soft_reset_2 <= 1;
timer_2 <= 0;
end
else
begin
soft_reset_2 <= 0;
timer_2 <= timer_2 + 1;
end
end
else
timer_2 <= 0;

end
end

//valid out logic ---------------- Combinational Logic
assign vld_out_0 = (~empty_0);
assign vld_out_1 = (~empty_1);
assign vld_out_2 = (~empty_2);

endmodule
