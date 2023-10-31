module IR(
    input wire [7:0] address,   // 8-bit address input
    output reg [31:0] data    // 32-bit data output
);


reg [31:0] Imemory [0:255];


initial begin : INIT
Imemory[0]  = 32'b00001100000000010000000000011000; 
Imemory[1]  = 32'b00000100000000010000000011111010; 
Imemory[2]  = 32'b00010100000000100000000000011111; 
Imemory[3]  = 32'b00000000001000100001100000000000; 
Imemory[4]  = 32'b00000000001000100010000000000001; 
Imemory[5]  = 32'b00010000010001010000000000000001; 
Imemory[6]  = 32'b00000000010001010011000000000110; 
Imemory[7]  = 32'b00000000010001010011100000000111; 
Imemory[8]  = 32'b00000000010000000100000000000100; 
Imemory[9]  = 32'b00001000000010010000000011111010; 
Imemory[10] = 32'b00000000101001110101000000000010;
Imemory[11] = 32'b00000000100001100101100000000011;
Imemory[12] = 32'b00000000101001000110000000000101;

end


always @(address) begin
  if (address > 256) 
          data = {32{1'b0}};
  else
          data = Imemory[address];
end


endmodule

/*

addi f0 f1 24   1
sw f1, 250(f0)	2
ori f0 f2 31	3
add f1 f2 f3	4
sub f1 f2 f4	5
andi f2 f5 1 	6
sll f2 f5 f6 	7
srl f2 f5 f7 	8	
xor f2 f0 f8 	9
lw f9, 250(f0) 	10
and f5 f7 f10   11
or f4 f6 f11 	12
xnor f5 f4 f12	13
*/