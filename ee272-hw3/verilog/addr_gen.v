module addr_gen
#( 
  parameter CONFIG_WIDTH = 64,
  parameter BANK_ADDR_WIDTH = 32
  // You might need some more parameters that set the max width of the
  // counters.
)(
  input clk,
  input rst_n,
  input addr_enable,
  output [BANK_ADDR_WIDTH - 1 : 0] addr,
  input config_enable,
  input [CONFIG_WIDTH - 1 : 0] config_data
);

  // You will have two address generators for each double buffer. One will
  // generate write addresses and the other will generate read addresses.
  //
  // The address generator receives some configuration data at the beginning
  // of the convolution which sets the layer and schedule parameters in
  // registers inside it.
  //
  // The core logic basically consists of a set of nested counters that
  // generate addresses according to the configuration. There is an
  // addr_enable signal coming from the top level that asks the addr_gen to
  // step (produce the next address).

endmodule
