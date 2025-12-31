`timescale 1ns/1ps
module multiplier (
  input clk,
  input [15:0] in1,
  input [15:0] in2,
  output reg [31:0] out
);

  always @(posedge clk) begin
    out <= in1 * in2;
  end

endmodule
