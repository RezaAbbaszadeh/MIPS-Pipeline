
module mux_3to1#(parameter n=32)(in1, in2, in3, sel , out);
	output [n-1:0] out;
	input [n-1:0] in1,in2,in3;
	input[1:0] sel;
	reg [n-1:0] out;
	always @(in1 or in2 or in3 or sel)
		if (sel == 0)
			out = in1;
		else if(sel == 1)
			out = in2;
		else
			out = in3;
endmodule
