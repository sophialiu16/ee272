`include "layer_params.svh"
extern void run_conv_gold ( input reg [15:0] array  [158700-1:0] ifmap, 
                    input reg [15:0] array [9408-1:0] weights,
                    output reg [31:0] array [802816-1:0] ofmap,
                    input bit [7:0] ofmap_width,
                    input bit [7:0] ofmap_height,
                    input bit [15:0] ifmap_channels,
                    input bit [15:0] ofmap_channels,
                    input bit [3:0] filter_size,
                    input bit [3:0] stride);
module conv_tb;
    // START CODE HERE
    
    // END CODE HERE
endmodule
