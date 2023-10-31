// Copyright (C) 2023  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"
// CREATED		"Sat Oct 28 22:40:54 2023"

module mip32_b(
	clk,
	reset
);


input wire	clk;
input wire	reset;

wire	[7:0] SYNTHESIZED_WIRE_28;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[4:0] SYNTHESIZED_WIRE_3;
wire	[4:0] SYNTHESIZED_WIRE_4;
wire	[4:0] SYNTHESIZED_WIRE_5;
wire	[31:0] SYNTHESIZED_WIRE_6;
wire	[31:0] SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_8;
wire	[3:0] SYNTHESIZED_WIRE_11;
wire	[31:0] SYNTHESIZED_WIRE_12;
wire	[31:0] SYNTHESIZED_WIRE_13;
wire	[2:0] SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	[31:0] SYNTHESIZED_WIRE_30;
wire	[31:0] SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_22;
wire	[31:0] SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_25;
wire	[31:0] SYNTHESIZED_WIRE_27;





IR	b2v_inst(
	.address(SYNTHESIZED_WIRE_28),
	.data(SYNTHESIZED_WIRE_29));


PC_reg	b2v_inst1(
	.clock(clk),
	.reset(reset),
	.data_in1(SYNTHESIZED_WIRE_1),
	.data_out(SYNTHESIZED_WIRE_28));


register_file	b2v_inst10(
	.reg_write(SYNTHESIZED_WIRE_2),
	.clk(clk),
	.reset(reset),
	.read_addr_1(SYNTHESIZED_WIRE_3),
	.read_addr_2(SYNTHESIZED_WIRE_4),
	.write_addr(SYNTHESIZED_WIRE_5),
	.write_data(SYNTHESIZED_WIRE_6),
	.read_data_1(SYNTHESIZED_WIRE_12),
	.read_data_2(SYNTHESIZED_WIRE_31));


sign_extension	b2v_inst11(
	.IR(SYNTHESIZED_WIRE_29),
	.sign_out(SYNTHESIZED_WIRE_24));


write_reg_MUX	b2v_inst12(
	.select1(SYNTHESIZED_WIRE_8),
	.data(SYNTHESIZED_WIRE_29),
	.outputdata(SYNTHESIZED_WIRE_5));


adder4	b2v_inst2(
	.A(SYNTHESIZED_WIRE_28),
	.add_out(SYNTHESIZED_WIRE_1));


alu	b2v_inst3(
	.aluCON(SYNTHESIZED_WIRE_11),
	.In1(SYNTHESIZED_WIRE_12),
	.In2(SYNTHESIZED_WIRE_13),
	
	
	.result(SYNTHESIZED_WIRE_30));


aluCON	b2v_inst4(
	.aluop(SYNTHESIZED_WIRE_14),
	.IR(SYNTHESIZED_WIRE_29),
	.out_to_alu(SYNTHESIZED_WIRE_11));


control_unit	b2v_inst5(
	.IR(SYNTHESIZED_WIRE_29),
	.reg_dest(SYNTHESIZED_WIRE_8),
	
	
	.mem_read(SYNTHESIZED_WIRE_17),
	.mem_to_reg(SYNTHESIZED_WIRE_25),
	.mem_write(SYNTHESIZED_WIRE_18),
	.alusrc(SYNTHESIZED_WIRE_22),
	.reg_write(SYNTHESIZED_WIRE_2),
	.aluop(SYNTHESIZED_WIRE_14));


data_memory	b2v_inst6(
	.clk(clk),
	.reset(reset),
	.mem_read(SYNTHESIZED_WIRE_17),
	.mem_write(SYNTHESIZED_WIRE_18),
	.addr(SYNTHESIZED_WIRE_30),
	.write_data(SYNTHESIZED_WIRE_31),
	.read_data(SYNTHESIZED_WIRE_27));


extract_reg_adrr	b2v_inst7(
	.IR(SYNTHESIZED_WIRE_29),
	.addr1(SYNTHESIZED_WIRE_3),
	.addr2(SYNTHESIZED_WIRE_4));


mux2to1	b2v_inst8(
	.select1(SYNTHESIZED_WIRE_22),
	.data1(SYNTHESIZED_WIRE_31),
	.data2(SYNTHESIZED_WIRE_24),
	.outputdata(SYNTHESIZED_WIRE_13));


mux2to1	b2v_inst9(
	.select1(SYNTHESIZED_WIRE_25),
	.data1(SYNTHESIZED_WIRE_30),
	.data2(SYNTHESIZED_WIRE_27),
	.outputdata(SYNTHESIZED_WIRE_6));


endmodule
