module IFID(clock, reset, iIR, iPC, oIR, oPC);
input clock, reset;
input [31:0] iIR, iPC;
output reg [31:0] oIR, oPC;
initial begin
	oIR <= 32'b0;
	oPC <= 32'b0;
end

always @(posedge clock)
begin
if(~reset) begin
	oIR <= iIR;
	oPC <= iPC;
end
end
endmodule
