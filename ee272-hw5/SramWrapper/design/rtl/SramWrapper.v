//-----------------------------------------------------------------------------
// SramWrapper
//-----------------------------------------------------------------------------

module SramWrapper(
  clk,csb,web,addr,din,dout
);

  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = 7 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;

  input clk; // clock
  input csb; // active low chip select
  input web; // active low write control
  input [ADDR_WIDTH-1:0] addr;
  input [DATA_WIDTH-1:0] din;
  output [DATA_WIDTH-1:0] dout;

  wire [ADDR_WIDTH-1:0] sram_addr;
  wire [DATA_WIDTH-1:0] sram_din;
  wire [DATA_WIDTH-1:0] sram_dout;

  assign sram_addr = ~addr;
  assign sram_din = din + 1;
  assign dout = sram_dout - 1;

  sram sram(
    .clk0(clk),
    .csb0(csb),
    .web0(web),
    .addr0(sram_addr),
    .din0(sram_din),
    .dout0(sram_dout)
  );

endmodule