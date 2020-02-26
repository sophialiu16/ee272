// macro alternative to $clog2, which isn't supported by some tools
`define CLOG2(x) \
((x <= 1) || (x > 16384)) ? 0 : \
(x <= 2) ? 1 : \
(x <= 4) ? 2 : \
(x <= 8) ? 3 : \
(x <= 16) ? 4 : \
(x <= 32) ? 5 : \
(x <= 64) ? 6 : \
(x <= 128) ? 7: \
(x <= 256) ? 8: \
(x <= 512) ? 9 : \
(x <= 1024) ? 10: \
(x <= 2048) ? 11 : \
(x <= 4096) ? 12 : \
(x <= 8192) ? 13 : \
(x <= 16384) ? 14 : 0

// Wrapper module to create larger memories from smaller generated memories
module sram_512_128(
    clk, csb, web, addr, din, dout
);
    // set these values 
    parameter WRAPPER_DEPTH = 512;
    parameter WRAPPER_WIDTH = 128;
    parameter WRAPPER_ADDR_BITS = 9;

    input clk;
    input csb;
    input web;
    input [WRAPPER_ADDR_BITS-1:0] addr;
    input [WRAPPER_WIDTH-1:0] din;
    output [WRAPPER_WIDTH-1:0] dout;


    // Change these SRAM values:
    parameter SRAM_DEPTH = 128;
    parameter SRAM_WIDTH = 128;
    parameter SRAM_ADDR_BITS = 7;
    parameter num_inst_depth = WRAPPER_DEPTH / SRAM_DEPTH;
    parameter num_inst_width = WRAPPER_WIDTH / SRAM_WIDTH;
    genvar i,j;

    wire [num_inst_depth-1:0] sram_csb;
    wire [num_inst_depth-1:0] sram_web;
    wire [SRAM_ADDR_BITS-1:0] sram_address;
    wire [SRAM_WIDTH-1:0] sram_din [num_inst_width-1:0];
    wire [SRAM_WIDTH-1:0] sram_dout [num_inst_depth-1:0][num_inst_width-1:0];

    // upper bits of address are used as mem_select
    wire [WRAPPER_ADDR_BITS-SRAM_ADDR_BITS-1:0] mem_select;
    assign mem_select = addr[WRAPPER_ADDR_BITS-1:SRAM_ADDR_BITS];
    reg [WRAPPER_ADDR_BITS-SRAM_ADDR_BITS-1:0] output_mem_select;

    assign sram_csb = ~(csb) ? ~(1 << mem_select) : ~0;
    assign sram_web = ~(web) ? ~(1 << mem_select) : ~0;

    always @(posedge clk) begin
        if(csb == 0 & web == 0) begin
            output_mem_select <= mem_select;
        end
    end

    generate
    for(j = 0; j < num_inst_width; j=j+1) begin
        assign dout[(j+1)*SRAM_WIDTH-1:j*SRAM_WIDTH] = sram_dout[output_mem_select][j];
    end
    endgenerate

    generate
    for(i = 0; i < num_inst_depth; i=i+1) begin
        for(j = 0; j < num_inst_width; j=j+1) begin
            sram_128_128 #(.DELAY(1)) memory (
                .clk0(clk),
                .csb0(sram_csb[i]),
                .web0(sram_web[i]),
                .addr0(addr[SRAM_ADDR_BITS-1:0]),
                .din0(din[(j+1)*SRAM_WIDTH-1:j*SRAM_WIDTH]),
                .dout0(sram_dout[i][j])
            );
        end
    end
    endgenerate
endmodule



// synopsys translate_off
`include "/afs/ir.stanford.edu/class/ee272/OpenRAM/generated_memories/1RW/sram_128_128/sram_128_128.v"
//`include "temp/sram_32_128_freepdk45.v"
// synopsys translate_on
