
module hazard_detector(input clk , input[4:0] IF_ID_rs , input[4:0] IF_ID_rt , input[4:0] ID_EX_rt , input ID_EX_mem_read ,
 output pc_load , output IF_ID_load , output control_mux_sel
 );

 reg pc_load_reg , IF_ID_load_reg , control_mux_sel_reg;
 assign pc_load = pc_load_reg;
 assign IF_ID_load = IF_ID_load_reg;
 assign control_mux_sel = control_mux_sel_reg;


always@*
begin

pc_load_reg = 1;
IF_ID_load_reg =1;
control_mux_sel_reg = 1;

if((ID_EX_mem_read==1) && ( (ID_EX_rt==IF_ID_rs) || (ID_EX_rt==IF_ID_rt)))
	begin
		pc_load_reg=0;
		IF_ID_load_reg=0;
		control_mux_sel_reg=0;
	end


end







 endmodule