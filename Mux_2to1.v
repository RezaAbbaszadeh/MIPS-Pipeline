
module mux_2to1#(parameter n=32)(in1, in2, sel , out);
	output [n-1:0] out;
	input [n-1:0] in1,in2;
	input sel;
	reg [n-1:0] out;
	always @(in1 or in2 or sel)
		if (sel == 1'b0)
			out = in1;
		else
			out = in2;
endmodule