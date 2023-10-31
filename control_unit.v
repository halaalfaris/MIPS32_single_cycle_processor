module control_unit (IR, reg_dest, branch, jump, mem_read, mem_to_reg, aluop, mem_write, alusrc, reg_write);
	input [31:0] IR;
	output reg reg_dest, branch, jump, mem_read, mem_to_reg, mem_write, alusrc, reg_write;
	output reg [2:0] aluop;
	wire [5:0] opcode;
	assign opcode = IR[31:26];
	
	
	/*
	r-type   0
	sw 		1
	lw 		2
	addi		3
	andi		4
	ori		5
	*/
	always @(*)
		begin 
			case(opcode)
				6'h0:	// r- type
				begin
					reg_dest = 1;
					branch = 0;
					jump = 0;
					mem_read = 0;
					mem_to_reg = 0;	
					mem_write = 0;
					alusrc = 0;
					reg_write = 1;
					aluop = 3'b010;
				end
				6'h1:	// sw
				begin
					reg_dest = 0;
					branch = 0;
					jump = 0;
					mem_read = 0;
					mem_to_reg = 0;	
					mem_write = 1;
					alusrc = 1;
					reg_write = 0;
					aluop = 3'b000;
					end
				6'h2:	//lw
				begin
					reg_dest = 0;
					branch = 0;
					jump = 0;
					mem_read = 1;
					mem_to_reg = 1;	
					mem_write = 0;
					alusrc = 1;
					reg_write = 1;
					aluop = 3'b000;
					end
				6'h3:	//addi
				begin
					reg_dest = 0;
					branch = 0;
					jump = 0;
					mem_read = 0;
					mem_to_reg = 0;	
					mem_write = 0;
					alusrc = 1;
					reg_write = 1;
					aluop = 3'b000;
					end
				6'h4:	//andi
				begin
					reg_dest = 0;
					branch = 0;
					jump = 0;
					mem_read = 0;
					mem_to_reg = 0;	
					mem_write = 0;
					alusrc = 1;
					reg_write = 1;
					aluop = 3'b011;
				end
				6'h5:	//ori
				begin
					reg_dest = 0;
					branch = 0;
					jump = 0;
					mem_read = 0;
					mem_to_reg = 0;	
					mem_write = 0;
					alusrc = 1;
					reg_write = 1;
					aluop = 3'b100;
				end
			endcase
		end
endmodule