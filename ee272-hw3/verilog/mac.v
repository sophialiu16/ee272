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
  output reg [IFMAP_WIDTH - 1 : 0] ifmap_out,
  output reg [OFMAP_WIDTH - 1 : 0] ofmap_out
);

// logic stuff
  logic [2*IFMAP_WIDTH - 1 : 0] input_weight_product;
  logic [OFMAP_WIDTH - 1 : 0] ofmap_out_reg;
  logic [IFMAP_WIDTH - 1 : 0] ifmap_out_reg;
  // always blocks, etc.
  
  always_ff @(posedge clk, negedge rst_n) begin 
    if(!rst_n) begin 
    //ofmap_out_reg = 0
    //input_weight_product0
    end 
    else if (enable) begin
      input_weight_product <= ifmap_in * weight_in;
      ofmap_out_reg <= ofmap_in + input_weight_product;
    end
  end 
  
  always_ff @(posedge clk, negedge rst_n) begin 
    if (rst_n & enable) begin
    	ifmap_out_reg <= ifmap_in;
    end
  end
  
  always_comb begin
    ifmap_out = ifmap_out_reg;
    ofmap_out = ofmap_out_reg;
  end 

endmodule

