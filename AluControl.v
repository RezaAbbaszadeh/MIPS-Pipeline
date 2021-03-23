module aluControl(input [5:0]fun,input [1:0]aluOp,input [5:0]opcode,output reg[3:0] opration);

  always@(*)begin
     opration[0] = (fun[0]|fun[3])&aluOp[1];
     opration[1] = ~(fun[2]&aluOp[1]);
     opration[2] = (aluOp[1]&fun[1])|aluOp[0];
     opration[3] =1'b0;
     if(aluOp==2'b11)
       begin
         
         case(opcode)
             6'b001000://addi
              opration=4'b0010;
             6'b001100://andi
              opration=4'b0000;
             6'b001101://ori
              opration=4'b0001;
             6'b001010://slti
              opration=4'b0111;
           endcase
            
           end
           
           end
endmodule


