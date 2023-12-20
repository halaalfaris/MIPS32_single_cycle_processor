//revise this. me
//ask ghaith abt where the outputs go and how many
//what is the second signal in the OR that is coming from the control unit.
module hazard_detection(forward, alusrc, SW_or_Branch, src1_ID, src2_ID, dest_EXE,  dest_MEM, Mem_to_Reg_EXE, Mem_to_Reg_MEM branch_comm, hazard_detected, IR);
  input [4:0] dest_EXE, dest_MEM; //Rd from the pipeline
  input [31:0] IR;
  input forward, Mem_to_Reg_EXE, Mem_to_Reg_MEM, alusrc, SW_or_Branch, Mem_to_Reg; 
  output hazard_detected;
  assign branch_type = IR[31:26];
  assign src1_ID=IR[25:21];
  assign src2_ID=IR[20:16];
  wire src2_is_valid, exe_has_hazard, mem_has_hazard, hazard, instr_is_branch;

  assign src2_is_valid =  (~alusrc) || SW_or_Branch;

  assign exe_has_hazard = Mem_to_Reg_EXE && (src1_ID == dest_EXE || (src2_is_valid && src2_ID == dest_EXE));
  assign mem_has_hazard = Mem_to_Reg_MEM && (src1_ID == dest_MEM || (src2_is_valid && src2_ID == dest_MEM));

  assign hazard = (exe_has_hazard || mem_has_hazard);
  assign instr_is_branch = (branch_comm == 6'h6 || branch_comm == 6'h7);  //just add the branching opcodes

  assign hazard_detected = ~forward_EN ? hazard : (instr_is_branch && hazard) || (Mem_to_Reg && mem_has_hazard); //compare if load-use or branch hazard
endmodule // hazard_detection
