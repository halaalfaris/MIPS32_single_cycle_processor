module forwarding_unit(
  input [4:0] RS1_IDEX,
  input [4:0] RS2_IDEX,
  input [4:0] RD_EXMEM,
  input [4:0] RD_MEMWB,
  input writeBack_EXMEM,
  input writeBack_MEMWB,
  output [1:0] ForwardA,
  output [1:0] ForwardB)

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      ForwardA <= 2'b00;
      ForwardB <= 2'b00;
      MuxCtrlSourceA <= 2'b00;
      MuxCtrlSourceB <= 2'b00;
    end 
    else begin
      // ForwardA logic
      if((writeBack_EXMEM && (RD_EXMEM != 5'b0) && (RD_EXMEM != RS1_IDEX)))
        ForwardA <= 2'b10;
      if (writeBack_MEMWB && (RD_MEMWB != 5'b0) &&
          !((writeBack_EXMEM && (RD_EXMEM != 5'b0) && (RD_EXMEM != RS1_IDEX))))
        ForwardA <= 2'b01;
      else
        ForwardA <= 2'b00;

      // ForwardB logic
      if((writeBack_EXMEM && (RD_EXMEM != 5'b0) && (RD_EXMEM != RS2_IDEX)))
        ForwardB <= 2'b10;
      if (writeBack_MEMWB && (RD_MEMWB != 5'b0) &&
          !((writeBack_EXMEM && (RD_EXMEM != 5'b0) && (RD_EXMEM != RS2_IDEX))))
        ForwardB <= 2'b01;
      else
        ForwardB <= 2'b00;

    end
    endmodule
