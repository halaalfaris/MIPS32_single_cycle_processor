module MEMWB(clock, reset, iPC, iIR, iwrite_addr, imem_to_reg, ipc_to_reg, ireg_write, 
oPC, oIR, owrite_addr, opc_to_reg, oreg_write,ialu_res,oalu_res);
input clock, reset, imem_to_reg, ipc_to_reg,  ireg_write;
  input [31:0] iPC, iIR, ialu_res,iData_mem_res;
input[4:0] iwrite_addr;

output reg   omem_to_reg, opc_to_reg, oreg_write;
  output reg [31:0] oPC, oIR,oalu_res,oData_mem_res;
output reg [4:0] owrite_addr;

initial begin
	oPC=32'b0;
	oIR=32'b0;
end

always@ (posedge clock) 
begin
	if(~reset) begin
    oData_mem_res<=iData_mem_res;
    ialu_res<=oalu_res;
   
		
		omem_to_reg <= imem_to_reg;
		opc_to_reg <= ipc_to_reg;
		
		oreg_write <= ireg_write;
		oPC <= iPC;
		oIR <= iIR;

		owrite_addr <= iwrite_addr;

	end
end
endmodule
