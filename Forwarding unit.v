
module forwarding_unit(input clk , input[4:0] ID_EX_rs , input[4:0] ID_EX_rt,
input[4:0] EX_MEM_rd , input[4:0] MEM_WB_rd ,
input EX_MEM_regWrite , input MEM_WB_regWrite,
output[1:0] rs_select , output[1:0] rt_select
);
reg[1:0] rs_select_reg , rt_select_reg;
assign rs_select = rs_select_reg;
assign rt_select = rt_select_reg;


always@*
  begin
  
  rs_select_reg = 0;
  rt_select_reg = 0;
  
  
	if ((EX_MEM_regWrite==1) && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs))
		rs_select_reg = 2;
		
	if (EX_MEM_regWrite==1 && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rt))
		rt_select_reg = 2;
		
	if (MEM_WB_regWrite==1 && (MEM_WB_rd != 0) &&
	!(EX_MEM_regWrite==1 && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs)) &&
	(MEM_WB_rd == ID_EX_rs))
		rs_select_reg = 1;
		
	if (MEM_WB_regWrite==1 && (MEM_WB_rd != 0) &&
	!(EX_MEM_regWrite==1 && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rt)) &&
	(MEM_WB_rd == ID_EX_rt))
		rt_select_reg = 1;

  end


endmodule