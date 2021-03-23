//p.61
module Datapath(input clk /*,
 input branch , jump,
 input mem_read , mem_write ,
 input[1:0] aluOp ,
 input reg_dest , reg_write,
 input alu_src,
 input mem_to_reg_sel,
 output [31:0] inst_mem_out*/
 );
 
 
 wire branch , jump;
 wire mem_read , mem_write ;
 wire[1:0] aluOp ;
 wire reg_dest , reg_write;
 wire alu_src;
 wire mem_to_reg_sel;
 wire [31:0] inst_mem_out;
 
 
 

wire[3:0] alu_opcode;
wire[31:0] pc_out;
wire[31:0] pc_mux_out;
wire[4:0] reg_dest_mux_out;
wire[31:0] mem_to_reg_mux_out;
wire[31:0] regFile_out1 , regFile_out2;
wire[31:0] alu_src_mux_out , alu_result;
wire alu_zero , alu_lt , alu_gt;
wire[31:0] data_mem_out;
wire[31:0] pc_jump_mux_out , pc_branch_mux_out;
wire[31:0] branch_address;
wire[31:0] next_ins;

wire[63:0] IF_ID_out;
wire[146:0] ID_EX_out;
wire[106:0] EX_MEM_out;
wire[70:0] MEM_WB_out;
wire[4:0] ID_EX_rs_out;
wire[5:0] ID_EX_ins_opcode_out;


wire[1:0] forwarding_rs_select,forwarding_rt_select;
wire[31:0] forwarding_rs_mux_out , forwarding_rt_mux_out;

wire pc_load,IF_ID_load,control_mux_sel;
wire[8:0] control_signals;


assign next_ins = pc_out + 4;



assign branch_address = IF_ID_out[15]? {16'hffff, IF_ID_out[15:0]} : {16'h0000, IF_ID_out[15:0]};

mux_2to1 #(.n(32)) pc_branch_mux(next_ins, EX_MEM_out[101:70] , EX_MEM_out[104] & EX_MEM_out[69] , pc_branch_mux_out);
//mux_2to1 #(.n(32)) pc_jump_mux(pc_branch_mux_out , {next_ins[31:28] , inst_mem_out[25:0] , 2'b00} , jump , pc_jump_mux_out);
register #(.n(32)) pc(.load(pc_load) , .clr(1'b0) , .clk(clk) , .in_data(pc_branch_mux_out) , .out_data(pc_out));
IMemBank ins_mem(1'b1, pc_out[7:0] , inst_mem_out);

register #(.n(64)) IF_ID(.load(IF_ID_load) , .clr(1'b0) , .clk(clk) ,
 .in_data({next_ins, inst_mem_out}) ,
 .out_data(IF_ID_out));

mux_2to1 #(.n(5)) reg_dest_mux(ID_EX_out[9:5], ID_EX_out[4:0] , ID_EX_out[141] , reg_dest_mux_out);
mux_2to1 #(.n(32)) mem_to_reg_mux(MEM_WB_out[68:37], MEM_WB_out[36:5] , MEM_WB_out[69] , mem_to_reg_mux_out);
RegFile reg_file(clk, IF_ID_out[25:21], IF_ID_out[20:16], MEM_WB_out[4:0], mem_to_reg_mux_out, MEM_WB_out[70], regFile_out1, regFile_out2);


 ControlUnit cu(clk,branch , jump,
 mem_read , mem_write ,
 aluOp ,
 reg_dest , reg_write,
 alu_src,
 mem_to_reg_sel,
 IF_ID_out[31:26]);
 
 
 hazard_detector hazard_unit(clk ,  IF_ID_out[25:21] , IF_ID_out[20:16] , ID_EX_out[9:5] , ID_EX_out[143] ,
 pc_load , IF_ID_load , control_mux_sel);
 
 
 assign control_signals = control_mux_sel?{reg_write, mem_to_reg_sel,branch, mem_read,mem_write,reg_dest,aluOp,alu_src} : 9'h0;
 
register #(.n(147)) ID_EX(.load(1'b1) , .clr(1'b0) , .clk(clk) ,
 .in_data({control_signals,IF_ID_out[63:32],
 regFile_out1,regFile_out2,branch_address,IF_ID_out[20:16],IF_ID_out[15:11]
 }) ,
 .out_data(ID_EX_out));
 
register #(.n(5)) ID_EX_rs(.load(1'b1) , .clr(1'b0) , .clk(clk) , .in_data(IF_ID_out[25:21]) , .out_data(ID_EX_rs_out));
register #(.n(6)) ID_EX_ins_opcode(.load(1'b1) , .clr(1'b0) , .clk(clk) , .in_data(IF_ID_out[31:26]) , .out_data(ID_EX_ins_opcode_out));

mux_3to1 #(.n(32))forwarding_rt_mux(ID_EX_out[73:42] , mem_to_reg_mux_out , EX_MEM_out[68:37] , forwarding_rt_select , forwarding_rt_mux_out);
mux_2to1 #(.n(32)) alu_src_mux(forwarding_rt_mux_out, ID_EX_out[41:10] , ID_EX_out[138] , alu_src_mux_out);
mux_3to1 #(.n(32))forwarding_rs_mux(ID_EX_out[105:74] , mem_to_reg_mux_out , EX_MEM_out[68:37] , forwarding_rs_select , forwarding_rs_mux_out);
ALU alu(forwarding_rs_mux_out ,alu_src_mux_out,alu_opcode, alu_result, alu_zero , alu_lt , alu_gt);
aluControl alu_control(ID_EX_out[15:10],ID_EX_out[140:139],ID_EX_ins_opcode_out,alu_opcode);

forwarding_unit forward_unit(clk , ID_EX_rs_out,ID_EX_out[9:5] , 
EX_MEM_out[4:0] , MEM_WB_out[4:0] ,
EX_MEM_out[106] , MEM_WB_out[70],
forwarding_rs_select , forwarding_rt_select
);


register #(.n(107)) EX_MEM(.load(1'b1) , .clr(1'b0) , .clk(clk) ,
 .in_data({ID_EX_out[146:142],ID_EX_out[137:106] + {ID_EX_out[39:10] , 2'b00} , alu_zero, alu_result,ID_EX_out[73:42] , reg_dest_mux_out }) ,
 .out_data(EX_MEM_out));

DMemBank data_mem(EX_MEM_out[103] , EX_MEM_out[102], EX_MEM_out[44:37], EX_MEM_out[36:5], data_mem_out);


register #(.n(71)) MEM_WB(.load(1'b1) , .clr(1'b0) , .clk(clk) ,
 .in_data({EX_MEM_out[106:105] , data_mem_out ,EX_MEM_out[68:37] , EX_MEM_out[4:0] }) ,
 .out_data(MEM_WB_out));


endmodule