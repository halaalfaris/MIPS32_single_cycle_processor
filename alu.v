module alu (
input [3:0]aluCON,
input [31:0] In1,
input [31:0] In2,
output [31:0] result,
output zero,
output ov);

wire [31:0]temp;
wire carry;
reg [32:0] res;

/*
add 0
sub 1
and 2
or  3
xor 4
nor 5 
sll 6
srl 7
addu8
subu9
*/ 
 
always @(*)
	begin
		case(aluCON)
		4'h0: res <= In1 + In2; 
		4'h1: res <= In1 - In2; 
		4'h2: res <= In1 & In2; 
		4'h3: res <= In1 | In2; 
		4'h4: res <= In1 ^ In2; 
		4'h5: res <= In1 ~^ In2; 
		4'h6: res <= In1 << In2;
		4'h7: res <= In1 >> In2;
		endcase
	end
	
assign temp = In1[30:0] + In2[30:0];
assign result = {res[31:0]};
assign carry = res[32];
assign ov = carry ^ temp[31];
assign zero = (res==32'd0) ? 1'b1: 1'b0;  





endmodule