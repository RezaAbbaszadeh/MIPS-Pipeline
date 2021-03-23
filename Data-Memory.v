//memory unit
module DMemBank(input memread, input memwrite, input [7:0] address, input [31:0] writedata, output reg [31:0] readdata);
 
  reg [31:0] mem_array [63:0];
  
  integer i;
  initial 
  begin
      for (i=0; i<64; i=i+1)   
     mem_array[i]=i*10;
  end
 
  always@(memread, memwrite, address, mem_array[address], writedata)
  begin
    if(memread)begin
      readdata=mem_array[address];
    end

    if(memwrite)
    begin
      mem_array[address]= writedata;
    end

  end

endmodule

