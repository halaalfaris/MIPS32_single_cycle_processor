module alu (
input [3:0]aluCON,
input [31:0] In1,
input [31:0] In2,
output [31:0] result,
output reg branchYes,
output reg ov,
output zero);

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
addu14
subu15
*/ 
 
always @(*)
    begin
        case(aluCON)
        4'h0:
                begin
                    res = In1 + In2; 
                    ov = (In1[31] & In2[31] & ~res[31]) | (~In1[31] & ~In2[31] & res[31]);
                end
        4'h1:
                begin
                    res = In1 - In2; 
                    ov = (In1[31] & ~In2[31] & ~res[31]) | (~In1[31] & In2[31] & res[31]);
                end
        4'h2: res <= In1 & In2; 
        4'h3: res <= In1 | In2; 
        4'h4: res <= In1 ^ In2; 
        4'h5: res <= In1 ~^ In2; 
        4'h6: res <= In1 << In2;
        4'h7: res <= In1 >> In2;
        4'h8: begin if(In1 == In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        4'h9: begin if(In1 != In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        4'hA: begin if(In1 >= In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        4'hB: begin if(In1 > In2) branchYes <= 1; else branchYes<= 0;  res <= In1 - In2;  end
        4'hC: begin if(In1 <= In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        4'hD: begin if(In1 < In2) branchYes <= 1; else branchYes<= 0;  res <= In1 - In2;  end
        4'hE: begin
                    res <= In1 + In2; 
                    ov <= 1'b0;
                end
        4'hF: begin
                    res = In1 - In2; 
                    ov = 1'b0;
                end
        endcase
    end
    
    
assign temp = In1[30:0] + In2[30:0];
assign result = {res[31:0]};
assign carry = res[32];
/*
assign ov = carry ^ temp[31];
*/
assign zero = (res==32'd0) ? 1'b1: 1'b0;  





endmodule