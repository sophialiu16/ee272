module input_write_addr_gen
#( 
  parameter CONFIG_WIDTH = 32,
  parameter BANK_ADDR_WIDTH = 32
)(
  input clk,
  input rst_n,
  input addr_enable,
  output [BANK_ADDR_WIDTH - 1 : 0] addr,
  input config_enable,
  input [CONFIG_WIDTH - 1 : 0] config_data
);

  // The address generator receives some configuration data at the beginning
  // of the convolution which sets the layer and schedule parameters in
  // registers inside it.
  
  reg [BANK_ADDR_WIDTH - 1 : 0] config_IC1_IY0_IX0;
  
  always @ (posedge clk) begin
    if (rst_n) begin
      if (config_enable) begin
        config_IC1_IY0_IX0 <= config_data[BANK_ADDR_WIDTH - 1 : 0]; 
        // This is set to IC1 * IY0 * IX0 in the testbench. Make sure this
        // truncation is safe, meaning, the size of the block that you are
        // writing into the double buffer bank should not be greater than the
        // size of the double buffer bank.
      end
    end else begin
      config_IC1_IY0_IX0 <= 0;
    end
  end
  
  // The core logic basically consists of a set of nested counters that
  // generate addresses according to the configuration. There is an
  // addr_enable signal coming from the top level that asks the addr_gen to
  // step (produce the next address). Make sure that you hold addr_enable 
  // low during config, or more generally anytime you want to stall.
 
  reg [BANK_ADDR_WIDTH - 1 : 0] ic1_iy0_ix0;
  
  always @ (posedge clk) begin
    if (rst_n) begin
      if (addr_enable) begin
        // One block coming into the input double buffer is IC1 * IY0 * IX0 deep and 
        // IC0*IFMAP_WIDTH wide, so the counter below just counts up to this
        // depth and then resets to 0 for the next block.

        ic1_iy0_ix0 <= (ic1_iy0_ix0 == config_IC1_IY0_IX0 - 1) ? 0 : ic1_iy0_ix0 + 1;

        // The difficult part here is to make sure that the input blocks have
        // the right overlap as explained in the homework pdf along IY0 and
        // IX0, but it is the responsibility of the testbench to make sure
        // that happens, so your addressing logic is simplified.
      end
    end else begin
      ic1_iy0_ix0 <= 0;
    end
  end

  assign addr = ic1_iy0_ix0;

endmodule
