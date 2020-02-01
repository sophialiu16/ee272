//`include "mac.v"

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
  input weight_write_enable,
  input [IFMAP_WIDTH - 1 : 0] ifmap_in [ARRAY_HEIGHT - 1 : 0],
  input [WEIGHT_WIDTH - 1 : 0] weight_in [ARRAY_WIDTH - 1 : 0],
  input [OFMAP_WIDTH - 1 : 0] ofmap_in [ARRAY_WIDTH - 1 : 0],
  output reg [OFMAP_WIDTH - 1 : 0] ofmap_out [ARRAY_WIDTH - 1 : 0]
);

  logic [IFMAP_WIDTH - 1 : 0] mac_ifmap_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [WEIGHT_WIDTH - 1 : 0] mac_weight_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] mac_ofmap_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [IFMAP_WIDTH - 1 : 0] mac_ifmap_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] mac_ofmap_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic mac_weight_write_enable [ARRAY_HEIGHT - 1 : 0];
  
  genvar i, j;
  for (i= 0; i < ARRAY_HEIGHT; i = i + 1) begin
    for (j = 0; j < ARRAY_WIDTH; j = j + 1) begin
     mac #(
       .IFMAP_WIDTH(4),
       .WEIGHT_WIDTH(4),
       .OFMAP_WIDTH(8)
     ) mac_arr (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .weight_write_enable(mac_weight_write_enable[i]),
        .ifmap_in(mac_ifmap_in[i][j]),
        .weight_in(mac_weight_in[i][j]),
        .ofmap_in(mac_ofmap_in[i][j]),
        .ifmap_out(mac_ifmap_out[i][j]),
        .ofmap_out(mac_ofmap_out[i][j])
      );
    end
  end
  
  logic [$clog2(ARRAY_HEIGHT) - 1: 0] counter;
  always_ff @(posedge clk, negedge rst_n) begin 
    if (rst_n & weight_write_enable) begin 
      if (counter < ARRAY_HEIGHT - 1) begin 
      counter <= counter + 1'b1; 
      end else begin 
        counter <= 0;
      end 
    end
  end

  always_ff @(posedge clk, negedge rst_n) begin
  // instantiate MACs and connect them up
  integer i, j;

    if (rst_n) begin 
  for (i = 0; i < ARRAY_HEIGHT; i = i + 1) begin
    for (j = 0; j < ARRAY_WIDTH; j = j + 1) begin
      if (~rst_n) begin
        mac_ifmap_in[i][j] = 0;
        mac_weight_in[i][j] = 0;
        mac_ofmap_in[i][j] = 0;
      end else begin
      mac_weight_in[i][j] = weight_in[j];
      // left edge
      if (j == 0) begin
        mac_ifmap_in[i][j] = ifmap_in[i];
        if (i == 0) begin // top left corner
          mac_ofmap_in[i][j] = ofmap_in[j];
        end else begin 
          mac_ofmap_in[i][j] = mac_ofmap_out[i-1][j];
        end 
        
      // right edge
      end else if (j == ARRAY_WIDTH - 1) begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1];
        if (i == 0) begin
          mac_ofmap_in[i][j] = ofmap_in[j];
        end else begin
          mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j];
        end
        
      // top edge, not including corners 
      end else if (i == 0) begin 
        mac_ofmap_in[i][j] = ofmap_in[j];
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j-1];
        
      // bottom edge, not including corners
      end else if (i == ARRAY_HEIGHT - 1) begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1];
        mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j];
        
      // array interior
      end else begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1];
        mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j];
      end
      end
    end
    end
  end
      
      
  // assign output
    for (j = 0; j < ARRAY_WIDTH; j = i + 1) begin
    	ofmap_out[j] = mac_ofmap_out[ARRAY_HEIGHT-1][j];
    end
      
  end
endmodule
