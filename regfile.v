module RegFile (clk, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
  input [4:0] readreg1, readreg2, writereg;
  input [31:0] writedata;
  input clk, RegWrite;
  output [31:0] readdata1, readdata2;

  reg [31:0] regfile [31:0];
  
  integer i;
  initial begin
      for (i=0; i<64; i=i+1)   
     regfile[i]=i;
  end
  
 
  always @(negedge clk)
  begin
    regfile[0]=0;
		  	if (RegWrite) 
	 				regfile[writereg] <= writedata;
  end
  

  assign readdata1 = regfile[readreg1];
  assign readdata2 = regfile[readreg2];
endmodule