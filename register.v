module register #(parameter n=16)
	(
    input load,clr,clk,
    input [n-1:0] in_data,
    output [n-1:0] out_data
    );
	
	reg [n-1:0] tmp;
	assign out_data = tmp;

	always@(posedge clk)
		if(clr)
			tmp <= 0;
		else if(load)
			tmp <= in_data;
			
	


endmodule


