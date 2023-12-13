module Comparator_32bit (
  input wire [31:0] A,
  input wire [31:0] B,
  input wire clk,
  input wire rst,
  output wire eq,
  output wire lt,
  output wire gt,
  output wire ge,
  output wire le
);

  reg eq, lt, gt, ge, le;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      eq <= 1'b0;
      lt <= 1'b0;
      gt <= 1'b0;
      ge <= 1'b0;
      le <= 1'b0;
    end else begin
      if (A == B) begin
        eq <= 1'b1;
        lt <= 1'b0;
        gt <= 1'b0;
        le <= 1'b1;
        ge <= 1'b1;
      end else if (A < B) begin
        eq <= 1'b0;
        lt <= 1'b1;
        gt <= 1'b0;
        le <= 1'b1;
        ge <= 1'b0;
      end else begin
        eq <= 1'b0;
        lt <= 1'b0;
        gt <= 1'b1;
        le <= 1'b0;
        ge <= 1'b1;
      end
    end
  end

endmodule
