
// Feras's version
module mip32_b(input reset, input clk);
//misc wires
wire [31:0] sign_out_Decode, sign_out_Execution;
wire [31:0] Branch_Address, Jump_Address;
wire [3:0] out_to_alu;
wire branchYes;
wire [31:0] alu1, alu2, rs2, rs2_Memory, alu_res_Execution, alu_res_Memory, alu_res_WB, read_data_Memory, read_data_WB;
//PC wires
wire [31:0] PC_Add_One, PC_Add_One_Decode, PC_Add_One_Execution, PC_Add_One_Memory, PC_Add_One_WB;//PC + 1, carried through the whole pipeline for Jal to work
wire [31:0] Final_PC; //pc value after all the jumping and branching
wire [7:0] PC_Value; //pc value into the Instruction Memory(should be carried to the Execution stage for exceptions)

//IR wires
wire [31:0] opcode_Fetch, opcode_Decode, opcode_Execution, opcode_Memory, opcode_WB; //opcode leaving the IR and going through the pipeline

//Control Unit wires
	//(Decode stage)
	wire [1:0] reg_dest_Decode; //to choose for the write_reg_mux what should be taken as rd(10 chooses the 31st register when using jal)
	wire branch_Decode, pc_to_reg_Decode, mem_read_Decode, mem_to_reg_Decode, mem_write_Decode, alusrc_Decode, reg_write_Decode;
	wire [1:0] jump_Decode;
	wire [3:0] aluop_Decode; 
	//(Execution stage)
	wire pc_to_reg_Execution, mem_read_Execution, mem_to_reg_Execution, mem_write_Execution, alusrc_Execution, reg_write_Execution;
	wire [1:0] jump_Execution;
	wire [3:0] aluop_Execution; 
	//(Memory Stage)
	wire pc_to_reg_Memory, mem_read_Memory, mem_to_reg_Memory, mem_write_Memory, reg_write_Memory;
	//WB stage
	wire pc_to_reg_WB, mem_to_reg_WB, reg_write_WB;
	
//Register File wires
wire [4:0] RS1_Decode, RS1_Execution, RS2_Decode, RS2_Execution; //operand addresses(used to compare with RD in the forwarding unit)
wire [4:0] RD_Decode, RD_Execution, RD_Memory, RD_WB; //Register Destination address(carried through the whole pipeline)
wire [31:0] RS1_Data_Decode, RS1_Data_Execution, RS2_Data_Decode, Rs2_Data_Execution, Rs2_Data_Memory;
wire [31:0] RD_Value_Memory; //alu result
wire [31:0] RD_Value_WB; //result of the mux in the WB stage, chooses between memory result or the alu result(not the mux that is immediately before the RF)
wire [31:0] RD_Value;//rd value between mem/alu and pc




//note for instantiations of modules; above are inputs, below are outputs(for the most part)
PC_reg(clk, reset, Final_PC_Fetch, 
PC_Value 
);

adder4 (PC_Value, PC_Add_One); // to get pc +1

IR(
    PC_Value, 
     opcode_Fetch    
);

IFID(clk, reset, opcode_Fetch, PC_Add_One, 
opcode_Decode, PC_Add_One_Decode);

control_unit (opcode_Decode, 
reg_dest_Decode, branch_Decode, jump_Decode, mem_read_Decode, mem_to_reg_Decode ,pc_to_reg_Decode, aluop_Decode, mem_write_Decode, alusrc_Decode, reg_write_Decode);

extract_reg_adrr(
opcode_Decode,
RS1_Decode, RS2_Decode
); //to get rs1 and rs2 values from the IR (it would be preferable if this stuff is done in RF itself though)

write_reg_MUX (
     reg_dest_Decode, opcode_Decode,
     RD_Decode 
); //outputs RD_Decode which ENTERS THE PIPELINE NOT THE RF

register_file (RS1_Decode, RS2_Decode, RD_WB, 
RS1_Data_Decode, RS2_Data_Decode, RD_Value, reg_write_WB, clk, reset); //note: clk and reset are not outputs, just didnt bother and change the order in the original file

Comparator_32bit (
  RS1_Data_Decode, RS2_Data_Decode, opcode_Decode, clk, rst,
  branchYes, res
); //a comparator used to find the result of the branching instead of the alu(jumping and branching results will also be done in decode)

sign_extension (opcode_Decode, 
sign_out_Decode);

bmux2to1 (
	 branchYes, branch_Decode, PC_Add_One_Decode, sign_out_Decode,
    Branch_Address);
	 
jumpShift(opcode_Decode, PC_Add_One_Decode, 
Jump_Address);//the module used to get the jump address

jumpMux(Jump_Address, RS1_Data_Decode, Branch_Address, jump_Decode, 
Final_PC);// chooses between either jump address, branch address, or an address stored in a register for the jr instruction


IDEX(clk, reset, PC_Add_One_Decode, opcode_Decode, RD_Decode, ibranch, ijump, mem_read_Decode, mem_to_reg_Decode, pc_to_reg_Decode, aluop_Decode, mem_write_Decode, alusrc_Decode, reg_write_Decode,
 RS1_Data_Decode, RS2_Data_Decode, sign_out_Decode,RS1_Decode,RS2_Decode,
mem_to_reg_Execution,PC_Add_One_Execution, opcode_Execution, RD_Execution, 
mem_read_Execution, pc_to_reg_Execution, aluop_Execution, mem_write_Execution, alusrc_Execution, reg_write_Execution,
RS1_Data_Execution, RS2_Data_Execution, sign_out_Execution, hazard_detected,RS1_Execution, RS2_Execution);
//got lazy but you should REMOVE the jump and branch signals for after the decode stage; so I didnt change the ijump ibranch stuff :)

aluCON (aluop_Execution, opcode_Execution, out_to_alu);

forwarding_unit(
  RS1_Execution, RS2_Execution, RD_Memory, RD_WB, reg_write_Memory, reg_write_WB, clk, reset,
  ForwardA, ForwardB);//forwarding unit compares the operands with the destination of the prior instructions to check dependencies
  
mux_4to1 (
  RS1_Data_Execution, RD_Value_WB, RD_Value_Memory, data_input_3, ForwardA,
  alu1);
 mux_4to1 (
  RS2_Data_Execution, RD_Value_WB, RD_Value_Memory, data_input_3, ForwardB,
  rs2);
  //these muxs choose where the forward data comes from
  //no reason to keep "data_input_3"; kept it in case it was needed.
 mux2to1 m1(
    alusrc_Execution, rs2, sign_out_Execution,
    alu2
);//chooses between immediate value or rs2 value

alu (
out_to_alu, alu1, alu2, alu_res_Execution,
branchYes, ov); //uhh the alu duh
//also, the branchYes should be removed since branching happens in decode stage now. same with the comparisons in the alu as well


EXMEM(clk, reset, PC_Add_One_Execution, opcode_Execution, RD_Execution, mem_read_Execution, mem_to_reg_Execution, pc_to_reg_Execution, mem_write_Execution, reg_write_Execution, rs2,
PC_Add_One_Memory, opcode_Memory, RD_Memory, mem_read_Memory, pc_to_reg_Memory, mem_write_Memory, reg_write_Memory,alu_res_Execution, alu_res_Memory, mem_to_reg_Memory ,rs2_Memory);


data_memory (alu_res_Memory, rs2_Memory, read_data_Memory, clk, reset, mem_read_Memory, mem_write_Memory);

MEMWB(clk, reset, PC_Add_One_Memory, opcode_Memory, RD_Memory, mem_to_reg_Memory, pc_to_reg_Memory, reg_write_Memory, read_data_Memory, mem_to_reg_WB, read_data_WB,
PC_Add_One_WB, opcode_WB, RD_WB, pc_to_reg_WB, reg_write_WB, alu_res_Memory, alu_res_WB);

mux2to1 m2(
    mem_to_reg_WB, alu_res_WB, read_data_WB,
	 RD_Value_WB
);//alu result and memory data

mux2to1 m3(
    pc_to_reg_WB, RD_Value_WB, PC_Add_One_WB,
	 RD_Value
);// alu/memory or pc


endmodule
