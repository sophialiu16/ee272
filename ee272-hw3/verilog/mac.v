module mac
#(
  parameter IFMAP_WIDTH = 16,
  parameter WEIGHT_WIDTH = 16,
  parameter OFMAP_WIDTH = 32
)(
  input clk,
  input rst_n,
  input enable,
  input weight_write_enable,
  input [IFMAP_WIDTH - 1 : 0] ifmap_in,
  input [WEIGHT_WIDTH - 1 : 0] weight_in,
  input [OFMAP_WIDTH - 1 : 0] ofmap_in,
  output reg [IFMAP_WIDTH - 1 : 0] ifmap_out,
  output reg [OFMAP_WIDTH - 1 : 0] ofmap_out
);

// logic stuff
  logic [OFMAP_WIDTH - 1 : 0] ofmap_out_reg;
  logic [IFMAP_WIDTH - 1 : 0] ifmap_out_reg;
  reg [WEIGHT_WIDTH - 1 : 0] weight_in_reg;
  // always blocks, etc.
  
  always_ff @(posedge clk, negedge rst_n) begin 
    if(~rst_n) begin 
      ofmap_out_reg <= 0;
    end 
    else if (enable) begin
      ofmap_out_reg <= ofmap_in + ifmap_in * weight_in_reg;
    end
  end 
  
  always_ff @(posedge clk, negedge rst_n) begin 
   if(~rst_n) begin 
      ifmap_out_reg <= 0;
   end 
   else if (rst_n & enable) begin
    	ifmap_out_reg <= ifmap_in;
    end
  end
  
  always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin 
      weight_in_reg <= 0;
    end 
    else if (weight_write_enable) begin
    	weight_in_reg <= weight_in;
    end
  end
  
  always_comb begin
    ifmap_out = ifmap_out_reg;
    ofmap_out = ofmap_out_reg;
  end 

endmodule
