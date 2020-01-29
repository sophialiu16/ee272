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

  logic [IFMAP_WIDTH - 1 : 0] mac_ifmap_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [WEIGHT_WIDTH - 1 : 0] mac_weight_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] mac_ofmap_in [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [IFMAP_WIDTH - 1 : 0] mac_ifmap_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] mac_ofmap_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];

  // Using generate statements, instantiate MACs and connect them up
	genvar i, j;
  generate for (i = 0; i < ARRAY_HEIGHT; i = i + 1) begin
    generate for (j = 0; j < ARRAY_WIDTH; j = i + 1) begin
      mac_weight_in[i][j] = weight_in[j];
      // left edge
      if (j == 0) begin
        mac_ifmap_in[i][j] = ifmap_in[i];
        if (i == 0) begin // top left corner
          mac_ofmap_in[i][j] = ofmap_in[j]
        end else begin 
          mac_ofmap_in[i][j] = mac_ofmap_out[i-1][j]
        end 
        
      // right edge
      end else if (j == ARRAY_WIDTH - 1) begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1];
        if (i == 0) begin
          mac_ofmap_in[i][j] = ofmap_in[j]
        end else begin
          mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j]
        end
        
      // top edge, not including corners 
      end else if (i == 0) begin 
        mac_ofmap_in[i][j] = ofmap_in[j]
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j-1]
        
      // bottom edge, not including corners
      end else if (i == ARRAY_HEIGHT - 1) begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1]
        mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j]
        
      // array interior
      end else begin
        mac_ifmap_in[i][j] = mac_ifmap_out[i][j - 1]
        mac_ofmap_in[i][j] = mac_ofmap_out[i - 1][j]
      end
      
      mac mac_arr (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .ifmap_in(mac_ifmap_in[i][j]),
        .weight_in(mac_weight_in[i][j]),
        .ofmap_in(mac_ofmap_in[i][j]),
        .ifmap_out(mac_ifmap_out[i][j]),
        .ofmap_out(mac_ofmap_out[i][j])
      );
      
    endgenerate
  endgenerate
      
  // assign output
  generate 
    for (j = 0; j < ARRAY_WIDTH; j = i + 1) begin
    	ofmap_out[j] = mac_ofmap_out[ARRAY_HEIGHT-1][j]
  	end
  endgenerate
      
endmodule

