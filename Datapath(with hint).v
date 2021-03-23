
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

wire[63:0] IF_ID_out,ID_EX_out , EX_MEM_out , MEM_WB_out;


assign next_ins = pc_out + 4;



assign branch_address = inst_mem_out[15]? {16'hffff, inst_mem_out[15:0]} : {16'h0000, inst_mem_out[15:0]};

mux_2to1 #(.n(32)) pc_branch_mux(next_ins, EX_MEM_out[70+31:70] , EX_MEM_out[101+2] & EX_MEM_out[69] , pc_branch_mux_out);
//mux_2to1 #(.n(32)) pc_jump_mux(pc_branch_mux_out , {next_ins[31:28] , inst_mem_out[25:0] , 2'b00} , jump , pc_jump_mux_out);
register #(.n(32)) pc(.load(1'b1) , .clr(pc_clr) , .clk(clk) , .in_data(pc_jump_mux_out) , .out_data(pc_out));
IMemBank ins_mem(1'b1, pc_out[7:0] , inst_mem_out);

register #(.n(64)) IF_ID(.load(1'b1) , .clr(pc_clr) , .clk(clk) ,
 .in_data({inst_mem_out,next_ins}) ,
 .out_data(IF_ID_out));

mux_2to1 #(.n(5)) reg_dest_mux(ID_EX_out[9:5], ID_EX_out[4:0] , ID_EX_out[138+3] , reg_dest_mux_out);
mux_2to1 #(.n(32)) mem_to_reg_mux(MEM_WB_out[37+31:31], MEM_WB_out[5+31:5] , MEM_WB_out[69] , mem_to_reg_mux_out);
RegFile reg_file(clk, IF_ID_out[25:21], IF_ID_out[20:16], reg_dest_mux_out, mem_to_reg_mux_out, MEM_WB_out[69+1], regFile_out1, regFile_out2);


 ControlUnit cu(clk,branch , jump,
 mem_read , mem_write ,
 aluOp ,
 reg_dest , reg_write,
 alu_src,
 mem_to_reg_sel,
 IF_ID_out[31:26]);
 
 
register #(.n(138 +9)) ID_EX(.load(1'b1) , .clr(pc_clr) , .clk(clk) ,
 .in_data({inst_mem_out[15:11],inst_mem_out[20:16],branch_address,regFile_out2,regFile_out1,
 next_ins,alu_src,aluOp,reg_dest,mem_write,mem_read,branch,reg_write,mem_to_reg_sel}) ,
 .out_data(ID_EX_out));

mux_2to1 #(.n(32)) alu_src_mux(ID_EX_out[42+31:42], ID_EX_out[10+31:10] , ID_EX_out[138] , alu_src_mux_out);
ALU alu(ID_EX_out[74+31:74],alu_src_mux_out,alu_opcode, alu_result, alu_zero , alu_lt , alu_gt);
aluControl alu_control(inst_mem_out[10:10+5],ID_EX_out[138+2:138+1],inst_mem_out[10+31:10+26],alu_opcode);

register #(.n(101 + 6)) EX_MEM(.load(1'b1) , .clr(pc_clr) , .clk(clk) ,
 .in_data({reg_dest_mux_out,ID_EX_out[42+31:42] , alu_result,alu_zero, ID_EX_out[106+31:106] + {ID_EX_out[29:0] , 2'b00} , ID_EX_out[142+9:142] }) ,
 .out_data(EX_MEM_out));

DMemBank data_mem(EX_MEM_out[102] , EX_MEM_out[101], EX_MEM_out[37+7:37], EX_MEM_out[5+31:5], data_mem_out);


register #(.n(69+2)) MEM_WB(.load(1'b1) , .clr(pc_clr) , .clk(clk) ,
 .in_data({EX_MEM_out[5:0], EX_MEM_out[37+31:37] , data_mem_out , EX_MEM_out[104+1:104] }) ,
 .out_data(MEM_WB_out));


endmodule