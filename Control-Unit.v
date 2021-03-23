
module ControlUnit(input clk ,
 output  branch , jump,
 output   mem_read , mem_write ,
 output  [1:0] aluOp ,
 output   writereg_sel , reg_write,
 output   alu_src,
 output   mem_to_reg_sel,
 input[5:0] opcode
 );

 assign branch =	(opcode==6'b000000)? 0://R type
					(opcode==6'b100011)? 0://lw
					(opcode==6'b101011)? 0://sw
					(opcode==6'b000100)? 1://beq
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?0:// addi  andi  ori   slti
					1'bx;
					
 assign jump =	(opcode==6'b000000)? 0:
					(opcode==6'b100011)? 0:
					(opcode==6'b101011)? 0:
					(opcode==6'b000100)? 0:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?0:
					1'bx;
					
					
assign mem_read =	(opcode==6'b000000)? 0:
					(opcode==6'b100011)? 1:
					(opcode==6'b101011)? 0:
					(opcode==6'b000100)? 0:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?0:
					1'bx;
					
					
assign mem_write =	(opcode==6'b000000)? 0:
					(opcode==6'b100011)? 0:
					(opcode==6'b101011)? 1:
					(opcode==6'b000100)? 0:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?0:
					1'bx;
					
					
assign aluOp =	(opcode==6'b000000)? 2'b10:
					(opcode==6'b100011)? 2'b00:
					(opcode==6'b101011)? 2'b00:
					(opcode==6'b000100)? 2'b01:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?2'b11:
					2'bx;
					
					
assign writereg_sel =	(opcode==6'b000000)? 1:
					(opcode==6'b100011)? 0:
					(opcode==6'b101011)? 1'bx:
					(opcode==6'b000100)? 1'bx:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?0:
					1'bx;
 
 assign reg_write =	(opcode==6'b000000)? 1:
					(opcode==6'b100011)? 1:
					(opcode==6'b101011)? 0:
					(opcode==6'b000100)? 0:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?1:
					1'bx;
					
					
assign alu_src =	(opcode==6'b000000)? 0:
					(opcode==6'b100011)? 1:
					(opcode==6'b101011)? 1:
					(opcode==6'b000100)? 0:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?1:
					1'bx;					
					
assign mem_to_reg_sel =	(opcode==6'b000000)? 1:
					(opcode==6'b100011)? 0:
					(opcode==6'b101011)? 1'bx:
					(opcode==6'b000100)? 1'bx:
					( (opcode==6'b001000) || (opcode==6'b001100) || (opcode==6'b001101) || (opcode==6'b001010) )?1:
					1'bx;
					
					

 
 
endmodule