module IDEX(clock, reset, iPC, iIR, iwrite_addr, ibranch, ijump, imem_read, imem_to_reg, ipc_to_reg, ialuop, imem_write, ialusrc, ireg_write, iread_data1, iread_data2, isign_ext,
oPC, oIR, owrite_addr, obranch, ojump, omem_read, opc_to_reg, oaluop, omem_write, oalusrc, oreg_write, oread_data1, oread_data2, osign_ext);
input clock, reset, ibranch, ijump, imem_read, imem_to_reg, ipc_to_reg, imem_write, ialusrc, ireg_write;
input [31:0] iPC, iIR, iread_data1, iread_data2, isign_ext;
input[4:0] iwrite_addr;
input [3:0] ialuop;
output reg obranch, ojump, omem_read, omem_to_reg, opc_to_reg, omem_write, oalusrc, oreg_write;
output reg [31:0] oPC, oIR, oread_data1, oread_data2, osign_ext;
output reg [4:0] owrite_addr;
output reg [3:0] oaluop;
initial begin
	oPC=32'b0;
	oIR=32'b0;
end

always@ (posedge clock) 
begin
	if(~reset) begin
		obranch <= ibranch;
		ojump <= ijump;
		omem_read <= imem_read;
		omem_to_reg <= imem_to_reg;
		opc_to_reg <= ipc_to_reg;
		omem_write <= imem_write;
		oalusrc <= ialusrc;
		oreg_write <= ireg_write;
		oPC <= iPC;
		oIR <= iIR;
		oread_data1 <= iread_data1;
		oread_data2 <= iread_data2;
		owrite_addr <= iwrite_addr;
		oaluop <= ialuop;
		osign_ext <= isign_ext;
	end
end
endmodule
