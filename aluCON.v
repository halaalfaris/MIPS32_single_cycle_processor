module aluCON (aluop, IR, out_to_alu);
	input [2:0] aluop;
	input [31:0] IR;
	wire [5:0] funct;
	assign funct= IR[5:0];
	output reg [3:0] out_to_alu;
	/*
add 0
sub 1
and 2
or  3
xor 4
nor 5 
sll 6
srl 7
	*/
always @(*)
	begin
		case(aluop)
			3'b000:
				out_to_alu = 4'd0;
			3'b001:
				out_to_alu = 4'd1;
			3'b010:
				begin
					case(funct)
						4'h0: out_to_alu = 4'd0; 
						4'h1: out_to_alu = 4'd1; 
						4'h2: out_to_alu = 4'd2; 
						4'h3: out_to_alu = 4'd3; 
						4'h4: out_to_alu = 4'd4; 
						4'h5: out_to_alu = 4'd5; 
						4'h6: out_to_alu = 4'd6;
						4'h7: out_to_alu = 4'd7;
					endcase
				end
			3'b011:
				out_to_alu = 4'd2;
			3'b100:
				out_to_alu = 4'd3;
		endcase
		
	end
	
	
endmodule