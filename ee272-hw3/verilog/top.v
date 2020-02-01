module top
#(
  // parameters go here
)(
  input clk,
  input rst_n
);
  localparam NUM_STATES = 3;
  logic [$clog2(NUM_STATES) : 0] curr_state;
  logic [$clog2(NUM_STATES) : 0] next_state;
  
  // storage process
  always_ff @(posedge clk) begin
    curr_state <= next_state;
  end
  
  // output process
  // currstate case statement

  // transition process - determines next state
  always @ (curr_state) begin 
  end

  
  //systolic_array sys {
  //  
  //}

endmodule 
/*
  module systolic_array
#(
  parameter IFMAP_WIDTH = 16,
  parameter WEIGHT_WIDTH = 16,
  parameter OFMAP_WIDTH = 32,
  parameter ARRAY_HEIGHT = 4,
  parameter ARRAY_WIDTH = 4
)(
  input clk,
  input rst_n,
  input enable,
  input [IFMAP_WIDTH - 1 : 0] ifmap_in [ARRAY_HEIGHT - 1 : 0],
  input [WEIGHT_WIDTH - 1 : 0] weight_in [ARRAY_WIDTH - 1 : 0],
  input [OFMAP_WIDTH - 1 : 0] ofmap_in [ARRAY_WIDTH - 1 : 0],
  output [OFMAP_WIDTH - 1 : 0] ofmap_out [ARRAY_WIDTH - 1 : 0]
);

endmodule
*/
