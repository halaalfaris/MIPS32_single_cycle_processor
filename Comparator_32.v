module Comparator_32bit (
  input wire [31:0] In1,
  input wire [31:0] In2,
  input wire [31:0] IR,
  input wire clk,
  input wire rst,
  output wire branchYes
);
  wire [5:0]opcode= [31:26]IR;
  reg eq, lt, gt, ge, le;

  always @(posedge clk or posedge rst) begin
    if (rst == 1) branch <=0;
    else begin
    case(opcode) begin
        6'h8: begin if(In1 == In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        6'h9: begin if(In1 != In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        6'hA: begin if(In1 >= In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        6'hB: begin if(In1 > In2) branchYes <= 1; else branchYes<= 0;  res <= In1 - In2;  end
        6'hC: begin if(In1 <= In2) branchYes <= 1; else branchYes<= 0; res <= In1 - In2; end
        6'hD: begin if(In1 < In2) branchYes <= 1; else branchYes<= 0;  res <= In1 - In2;  end
      endcase
      end
  end

endmodule
