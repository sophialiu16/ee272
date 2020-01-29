module mac
#(
  parameter IFMAP_WIDTH = 16,
  parameter WEIGHT_WIDTH = 16,
  parameter OFMAP_WIDTH = 32
)(
  input clk,
  input rst_n,
  input enable,
  input [IFMAP_WIDTH - 1 : 0] ifmap_in,
  input [WEIGHT_WIDTH - 1 : 0] weight_in,
  input [OFMAP_WIDTH - 1 : 0] ofmap_in,
  output [IFMAP_WIDTH - 1 : 0] ifmap_out,
  output [OFMAP_WIDTH - 1 : 0] ofmap_out
);

endmodule
