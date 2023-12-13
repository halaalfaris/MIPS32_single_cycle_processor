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



module mip32(
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
wire	[31:0] Dmemory_to_mux;
wire	[31:0] instruction_IFID;
wire	[31:0] IR_IFID;
wire	[7:0] PC_IFID;



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


	
register_file	rf(
	.reg_write(reg_write),
	.clk(clk),
	.reset(reset),
	.read_addr_1(read_address_1),
	.read_addr_2(read_address_2),
	.write_addr(write_address),
	.write_data(write_data),
	.read_data_1(read_data_1),
	.read_data_2(read_data_2));


sign_extension	signEx(
	.IR(instruction_IFID),
	.sign_out(sign_extended));


write_reg_MUX	write_reg_M(
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


mux2to1	write_back_M(
	.select1(pc_to_reg),
	.data1(write_back),
	.data2(address_p_4),
	.outputdata(write_data));


adder4	add4(
	.A(intruct_address),
	.add_out(address_p_4));


alu	ALU(
	.aluCON(alu_control),
	.In1(read_data_1),
	.In2(alu_in_2),
	.branchYes(branch_yes),
	
	.result(alu_res));

//inputs will change
aluCON	alu_con(
	.aluop(aluop),
	.IR(),
	.out_to_alu(alu_control));


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
	.mem_read(mem_read),
	.mem_write(mem_write),
	.addr(alu_res),
	.write_data(read_data_2),
	.read_data(Dmemory_to_mux));


extract_reg_adrr	extract_adrr(
	.IR(instruction_IFID),
	.addr1(read_address_1),
	.addr2(read_address_2));


mux2to1	alu_src_mux(
	.select1(alusrc),
	.data1(read_data_2),
	.data2(sign_extended),
	.outputdata(alu_in_2));


mux2to1	Dmemory_mux(
	.select1(mem_to_reg),
	.data1(alu_res),
	.data2(Dmemory_to_mux),
	.outputdata(write_back));


IR	instruction_memory(
	.address(intruct_address),
	.data(instruction));


endmodule

