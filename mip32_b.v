// Copyright (C) 2023  Intel Corporation. All rights reserved.
`include "adder4.v"
`include "alu.v"
`include "aluCON.v"
`include "bmux2to1.v"
`include "control_unit.v"
`include "data_memory.v"
`include "extract_reg_addr.v"
`include "IR.v"
`include "jumpMUX.v"
`include "jumpshift.v"
`include "mux2to1.v"
`include "PC_reg.v"
`include "register_file.v"
`include "sing_extend.v"
`include "write_reg_MUX.v"
`include "IFID.v"
`include "hazard_detection.v"
`include "IDEX.v"
`include "forwarding_unit.v"
`include "mux_4to1.v"
`include "EXMEM.v"
`include "MEMWB.v"

module mip32_b(
	clk,
	reset
);


input wire	clk;
input wire	reset;

wire	[31:0] next_instruction;
wire	reg_write;
wire	[4:0] read_address_1;
wire	[4:0] read_address_2;
wire	[4:0] write_address;
wire	[31:0] write_data;
wire	[31:0] instruction;
wire	[1:0] reg_dest;
wire	branch_yes;
wire	branch;
wire	[31:0] address_p_4;
wire	[31:0] sign_extended;
wire	[31:0] address_branch;
wire	[1:0] jump;
wire	[31:0] new_address;
wire	[31:0] read_data_1;
wire	pc_to_reg;
wire	[31:0] write_back;
wire	[7:0] intruct_address;
wire	[3:0] alu_control;
wire	[31:0] alu_in_2;
wire	[3:0] aluop;
wire	mem_read;
wire	mem_write;
wire	[31:0] alu_res;
wire	[31:0] read_data_2;
wire	alusrc;
wire	mem_to_reg;
wire	[31:0] Dmemory_res;

	
	//SEGMENT IR YA FERAAAAAAAAAAAAAAAAS
	
wire	[31:0] instruction_IFID;
wire	[31:0] IR_IFID;
wire	[31:0] PC_IFID;

	/////////////////////FERAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAS///////////
	//WE FORGOT TO SPECIFY THE WIDTH OF THOSE WIRES//////////////
	
wire alusrc_IDEX;
wire mem_read_IDEX;
wire mem_to_reg_IDEX;
wire pc_to_reg_IDEX;
wire mem_write_IDEX;
wire reg_write_IDEX;
wire [31:0]PC_IDEX;
wire [31:0]IR_IDEX;
wire [31:0]read_data1_IDEX;
wire [31:0]read_data2_IDEX;
wire [31:0]sign_ext_IDEX;
wire [4:0]write_addr_IDEX;
wire [3:0]aluop_IDEX;
wire [4:0] RS1_IDEX;
wire [4:0] RS2_IDEX;
	
wire mem_read_EXMEM;
wire mem_to_reg_EXMEM;
wire pc_to_reg_EXMEM;
wire mem_write_EXMEM;
wire reg_write_EXMEM;
wire [31:0]PC_EXMEM;
wire [31:0]IR_EXMEM;	    
wire [31:0]alu_res_EXMEM; 
wire [31:0]Data_forMem_EXMEM;
wire [4:0]write_addr_EXMEM;
wire [31:0]RS2_EXMEM;
wire [31:0]RS1_EXMEM;
wire [31:0] instruction_EXMEM;

wire [31:0] alu_res_MEMWB;
wire [31:0] Dmem_res_MEMWB;
wire [4:0]write_addr_MEMWB;
wire [31:0] IR_MEMWB;
wire [31:0] PC_MEMWB;

//forwarding wires
wire [1:0] ForwardA;

wire [1:0] ForwardB;

//alu input muxes
wire [31:0]alu_input1;
wire [31:0]alu_input2;

	
PC_reg	pc_reg(
	.clock(clk),
	.reset(reset),
	.data_in1(next_instruction),
	.data_out(intruct_address));
	
IFID IF_ID(
	.clock(clk),
	.reset(reset),
	.iIR(instruction),
	.iPC(intruct_address),
	.oIR(instruction_IFID),
	.oPC(PC_IFID));
//FERAAAAAAAAAAAAAAAAS
	/*hazard_detection hdu(
		.forward(forward),
		.alusrc(alusrc),
		.SW_or_Branch(sworbranch),
		.dest_EXE(write_addr_IDEX),
		.dest_MEM(write_addr_EXMEM),
		.Mem_to_Reg_EXE(reg_write_IDEX),
		.Mem_to_Reg(),
		.Mem_to_Reg_MEM(reg_write_EXMEM),
		.IR(IR_IFID),
		.hazard_detected(hazard));*/
		
	
register_file	rf(
	.reg_write(reg_write_MEMWB),
	.clk(clk),
	.reset(reset),
	.read_addr_1(read_address_1),
	.read_addr_2(read_address_2),
	//
	.write_addr(write_addr_MEMWB),
	//FERAAAAAAAAAAAAAAAAAS PROOF READ THE WRITBACKKKKKKKKK
	.write_data(write_data),
	.read_data_1(read_data_1),
	.read_data_2(read_data_2));


sign_extension	signEx(
	.IR(instruction_IFID),
	.sign_out(sign_extended));


write_reg_MUX	write_reg_M(
	//FERAAAS MAKE SURE I DID THIS CORRECTLY
	.data(instruction_IFID),
	.select1(reg_dest),
	.outputdata(write_address));


bmux2to1	Bmux(
	.branchYes(branch_yes),
	.branch(branch),
	.add_out(address_p_4),
	.target(sign_extended),
	.addressBranch(address_branch));


jumpMux	Jmux(
	.addressBranch(address_branch),
	.jump(jump),
	.newAddr(new_address),
	.reg_value(read_data_1),
	.newPc(next_instruction));

// this will change as we shift the branch calculation stage beware of the instruction inputs
jumpShift	Jshift(
	.pcin(address_p_4),
	.target1(instruction_IFID),
	.newAddr(new_address));


mux2to1	ultimate_write_back_M(
	.select1(pc_to_reg_MEMWB),
	.data1(write_back),
	.data2(PC_MEMWB),
	.outputdata(write_data));


adder4	add4(
	.A(intruct_address),
	.add_out(address_p_4));

IDEX ID_EX(
	//inputs
	.hazard_detected(hazard),
	.clock(clk), 
	.reset(reset),
	.imem_read(mem_read),
	.imem_to_reg(mem_to_reg),
	.ipc_to_reg(pc_to_reg),
	.imem_write(mem_write),
	.ialusrc(alusrc),
	.ireg_write(reg_write),
	.iRS1(read_address_1),
	.iRS2(read_address_2),
	.ialuop(aluop),
	//check the original module
		//we are not sure about this FERAAAAAAAAAAAAAAAAAS
	.iwrite_addr(write_address),
	//inputs part2
	.iPC(PC_IFID),
	.iIR(instruction_IFID),
	.iread_data1(read_data_1),
	.iread_data2(read_data_2),
	.isign_ext(sign_extended),
	//outputs
	//execute
	.oalusrc(alusrc_IDEX), 
	.osign_ext(sign_ext_IDEX),
	.oread_data1(read_data1_IDEX),
	.oread_data2(read_data2_IDEX),
	.oRS1(RS1_IDEX),
	.oRS2(RS2_IDEX),
	.oaluop(aluop_IDEX),
	//write back and memory
	.omem_read(mem_read_IDEX),
	.omem_to_reg(mem_to_reg_IDEX),
	.opc_to_reg(pc_to_reg_IDEX),
	.omem_write(mem_write_IDEX),
	.oreg_write(reg_write_IDEX),
	.oPC(PC_IDEX),
	.oIR(IR_IDEX),	    
	.owrite_addr(write_addr_IDEX));

		    
alu	ALU(
	.aluCON(alu_control),
	//input will be from mux forwarding
	.In1(alu_input1),
	.In2(alu_input2),
	.branchYes(branch_yes),
	.result(alu_res));

//inputs will change
aluCON	alu_con(
	.aluop(aluop),
	.IR(IR_IDEX),
	.out_to_alu(alu_control));

forwarding_unit forward(
	.clk(clk),
	.rst(reset),
	.RS1_IDEX(RS1_IDEX),
	.RS2_IDEX(RS2_IDEX),
	.RD_EXMEM(write_addr_EXMEM),
	
	.RD_MEMWB(write_addr_MEMWB),
	.writeBack_EXMEM(reg_write_EXMEM),
	.writeBack_MEMWB(reg_write_MEMWB),
	.ForwardA(ForwardA),
	.ForwardB(ForwardB));
//FERAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAS DO THIS
	mux_4to1 muxA(
		.data_input_0(read_data1_IDEX),
		.data_input_1(write_data),
		.data_input_2(alu_res_EXMEM),
		.data_input_3(),
		.select(ForwardA),
		.data_output(alu_input1));

		mux_4to1 muxB(
		.data_input_0(alu_in_2),
		.data_input_1(write_data),
		.data_input_2(alu_res_EXMEM),
		.data_input_3(),
		.select(ForwardB),
		.data_output(alu_input2));
	
EXMEM EXMEM_buffer(
	//inputs
	.clock(clk), 
	.reset(reset),

	.imem_read(mem_read_IDEX),
	.imem_to_reg(mem_to_reg_IDEX),
	.ipc_to_reg(pc_to_reg_IDEX),
	.imem_write(mem_write_IDEX),
	.ialu_res(alu_res),
	//come back here after muxes
	.iRS2(alu_input2),
	.ireg_write(reg_write_IDEX),
	//inputs part2
	.iPC(PC_IDEX),
	.iIR(IR_IDEX),
	.iwrite_addr(write_addr_IDEX),
	//outputs
	// memory
	.omem_read(mem_read_EXMEM),
	.omem_write(mem_write_EXMEM),
	.oPC(PC_EXMEM),
	.oIR(IR_EXMEM),	
	.oRS2(RS2_EXMEM),
	
	//goes to write back mux
	.oalu_res(alu_res_EXMEM),	
	//write back
	.omem_to_reg(mem_to_reg_EXMEM),
	.owrite_addr(write_addr_EXMEM),
	.opc_to_reg(pc_to_reg_EXMEM),
	.oreg_write(reg_write_EXMEM));


control_unit	con_unit(
	.IR(instruction_IFID),
	.branch(branch),
	.mem_read(mem_read),
	.mem_to_reg(mem_to_reg),
	.pc_to_reg(pc_to_reg),
	.mem_write(mem_write),
	.alusrc(alusrc),
	.reg_write(reg_write),
	.aluop(aluop),
	.jump(jump),
	.reg_dest(reg_dest));


data_memory	Dmemory(
	.clk(clk),
	.reset(reset),
	.mem_read(mem_read_EXMEM),
	.mem_write(mem_write_EXMEM),
	.addr(alu_res_EXMEM),

	.write_data(RS2_EXMEM),

	.read_data(Dmemory_res));


extract_reg_adrr	extract_adrr(
	.IR(instruction_IFID),
	.addr1(read_address_1),
	.addr2(read_address_2));


mux2to1	alu_src_mux(
	.select1(alusrc_IDEX),
	.data1(read_data2_IDEX),
	.data2(sign_ext_IDEX),
	
	.outputdata(alu_in_2));

MEMWB MEMWB_buffer(
	//inputs
	.clock(clk), 
	.reset(reset),


	.imem_to_reg(mem_to_reg_EXMEM),
	.ipc_to_reg(pc_to_reg_EXMEM),

	.ialu_res(alu_res),

	.ireg_write(reg_write_EXMEM),
	//inputs part2
	.iPC(PC_EXMEM),
	.iIR(instruction_EXMEM),
	.iwrite_addr(write_addr_EXMEM),
	.iData_mem_res(Dmemory_res),
	//outputs
	// memory

	.oPC(PC_MEMWB),
	.oIR(IR_MEMWB),	

	
	//goes to write back mux
		
	//write back
	.oData_mem_res(Dmem_res_MEMWB),
	.oalu_res(alu_res_MEMWB),
	.omem_to_reg(mem_to_reg_MEMWB),
	.owrite_addr(write_addr_MEMWB),
	.opc_to_reg(pc_to_reg_MEMWB),
	.oreg_write(reg_write_MEMWB));

mux2to1	writeBack_mux(
	.select1(mem_to_reg_MEMWB),
	.data1(alu_res_MEMWB),
	.data2(Dmem_res_MEMWB),
	.outputdata(write_back));


IR	instruction_memory(
	.address(intruct_address),
	.data(instruction));

endmodule

