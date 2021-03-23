
module testbench();

reg clk;
Datapath dp(clk);



initial 
 begin

	dp.reg_file.regfile[7] = 32'h0000abcd;
	dp.reg_file.regfile[8] = 32'h0000abcd;
	
	
	
	dp.ins_mem.mem_array[1]  = 32'b10001100001000100000000000000010;//lw  $2 = mem[$1 + 2]=mem[3]         1e
	dp.ins_mem.mem_array[5]  = 32'b00000000001000100001100000100000;//add $3 = $1 + $2;           1f
	dp.ins_mem.mem_array[9]  = 32'b00000000011000100010000000100010;//sub $4 = $3 - $2;           1
	
	dp.ins_mem.mem_array[13] = 32'b00010000111010000000000000000101;//beq $7,$8  5;   branch to 17+20 (after 3 instructions!)
	dp.ins_mem.mem_array[17] = 32'b00000000010010000010100000101010;//slt    $5 = slt($2 , $8);       1
	dp.ins_mem.mem_array[21] = 32'b00110000111001101111000011110000;//andi   $6 = $7 & 1111000011110000;
	dp.ins_mem.mem_array[25] = 32'b00101001010010010000000000001000;//slti   $9 = slti($10 , 8)        0
	
	dp.ins_mem.mem_array[37]= 32'b10101100001001110000000000000010;//sw $1 $7   2;    mem[$1 + 2] = mem[3] = $7
	
	
	
	
	
	
	force dp.branch = 0;
	

 end
  
 
  
  
initial 
 begin

	#80
	dp.IF_ID.tmp=0;
	dp.ID_EX.tmp=0;
	dp.EX_MEM.tmp=0;
	dp.MEM_WB.tmp=0;
	force dp.IF_ID_out = dp.IF_ID.tmp;
	force dp.ID_EX_out = dp.ID_EX.tmp;
	force dp.EX_MEM_out = dp.EX_MEM.tmp;
	force dp.MEM_WB_out = dp.MEM_WB.tmp;
	dp.pc.tmp = 1;
	force dp.pc_out = dp.pc.tmp;
/*
	#10
	release dp.IF_ID_out;
	release dp.ID_EX_out;
	release dp.EX_MEM_out;
	release dp.MEM_WB_out;*/

	#120
	release dp.branch;

 end
  

  

initial 
 begin 
    clk = 0;
    forever 
	 begin
		#50 clk = ~clk;
	 end 
 end

endmodule