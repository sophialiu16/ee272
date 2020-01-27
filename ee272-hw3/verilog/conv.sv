module conv  
#(
    parameter IFMAP_SIZE = 4,
    parameter WEIGHTS_SIZE = 4,
    parameter OFMAP_SIZE = 4
) 
(
    input clk,
    input rst_n,
    
    // ifmap
    input [15:0] ifmap_dat,
    output reg ifmap_rdy,
    input ifmap_vld,

    // weights
    input [15:0] weights_dat,
    output reg weights_rdy,
    input weights_vld,

    // ofmap
    output [31:0] ofmap_dat,
    input ofmap_rdy,
    output reg ofmap_vld,
    
    // params
    input layer_params_t layer_params_dat,
    output reg layer_params_rdy,
    input layer_params_vld
);
    
    // -------------------------------------------------------
    // Replace the dummy code below with your implementation
    // -------------------------------------------------------
    
    reg [31:0] gold_ofmap_mem [OFMAP_SIZE-1:0];
    reg [$clog2(OFMAP_SIZE)-1:0] ofmap_idx;
    
    initial begin
        $readmemh("data/layer1_gold_ofmap.mem", gold_ofmap_mem);
    end

    assign ofmap_dat = gold_ofmap_mem[ofmap_idx];

    always_ff @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            ofmap_idx <= 1'b0;
            ifmap_rdy <= 1'b0;
            weights_rdy <= 1'b0;
            ofmap_vld <= 1'b0;
        end
        else begin
            ifmap_rdy <= 1'b1;
            weights_rdy <= 1'b1;
            ofmap_vld <= 1'b1;
            
            if(ofmap_vld & ofmap_rdy) begin
                ofmap_idx <= ofmap_idx + 1'b1;
            end
        end
    end

    // -------------------------------------------------------   
endmodule
