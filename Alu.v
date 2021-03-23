
module ALU(input [31:0] data1,data2,input [3:0] aluoperation,
output reg [31:0] result,output reg zero,lt,gt);

  always@(aluoperation,data1,data2)
  begin
    case (aluoperation)
      4'b0000 : result = data1 & data2; 
      4'b0001 : result = data1 | data2; 
      4'b0010 : result = data1 + data2; 
      4'b0110 : result = data1 - data2; 
      4'b0000 : result = ~(data1 | data2);
      4'b0111 :  // setOnLessThan
       begin 
         if (data1<data2)result=1'b1;
         else result=1'b0;
         end
      default : result = data1 + data2; // ADD
    endcase
    
    if(data1>data2)
      begin
       gt = 1'b1;
       lt = 1'b0; 
      end else if(data1<data2)
      begin
       gt = 1'b0;
       lt = 1'b1;  
      end
      
    if (result==32'd0) zero=1'b1;
    else zero=1'b0;
     
  end
  

endmodule
