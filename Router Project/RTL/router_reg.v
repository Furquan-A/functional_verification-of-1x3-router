module router_register(
input clk,resetn,pkt_vld,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
input [7:0] data_in,
output reg parity_done,low_pkt_vld,error,
output reg [7:0] data_out
);
reg [7:0] hhb,ffb,ip,pp;
//logic for ffb and ffb and data out
always@(posedge clk)
begin
if(~resetn)
begin
data_out <= 0;
hhb <= 0;
ffb <= 0;
end
else if ((detect_add) && (pkt_vld) && (data_in[1:0]!=2'b11))
hhb <= data_in;
else if(lfd_state)
data_out<=hhb;
else if(ld_state && !fifo_full)
data_out<=data_in;
else if(ld_state && fifo_full)
ffb<=data_in;
else if(laf_state)
data_out<=ffb;
end

//parity done
always@(posedge clk)
begin
if(~resetn)
parity_done <= 1'b0;
else if(detect_add)
parity_done <= 1'b0;
else if((ld_state && !fifo_full && !pkt_vld) || (laf_state && low_pkt_vld
&& !parity_done))

parity_done <= 1'b1;
// else if(laf_state && low_pkt_vld && !parity_done)
// parity_done <= 1'b1;
else
parity_done <= parity_done;
end
//low packet valid
always@(posedge clk)
begin
if(~resetn)
low_pkt_vld <= 1'b0;
else if(rst_int_reg)
low_pkt_vld <= 1'b0;
else if (ld_state && !pkt_vld)
low_pkt_vld <= 1'b1;
else
low_pkt_vld <= low_pkt_vld;

end
//packet parity
always@(posedge clk)
begin
if(~resetn)
pp <= 8'b0;

else if(detect_add)
pp <= 8'b0;
else if((ld_state && !fifo_full && !pkt_vld) || (laf_state && !parity_done
&& low_pkt_vld))
pp <= data_in;
else
pp <= pp;
end
// internal parity
always@(posedge clk)
begin
if(~resetn)
ip <= 8'b0;

else if (detect_add)
ip <= 8'b0;
else if(lfd_state && pkt_vld)
ip <= ip ^ hhb;
else if (ld_state && pkt_vld && !full_state)
ip <= ip ^ data_in;

else
ip <= ip;
end
//error
always@(posedge clk)
begin
if(!resetn)
error <= 0;
else if(parity_done)
begin
if (ip==pp)
error <= 0;
else
error <= 1;
end
else
error <= 0;
end
endmodule
