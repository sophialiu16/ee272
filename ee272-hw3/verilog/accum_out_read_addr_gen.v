module accum_out_read_addr_gen
#(
  parameter COUNTER_WIDTH = 32,
  parameter NUM_PARAMS = 8,
  parameter BANK_ADDR_WIDTH = 8
)(
  input clk,
  input rst_n,
  input addr_enable,
  output [BANK_ADDR_WIDTH - 1 : 0] addr,
  input config_enable,
  input [COUNTER_WIDTH*NUM_PARAMS - 1 : 0] config_data
);

  reg [COUNTER_WIDTH - 1 : 0] config_OX0, config_OY0, config_OC1;

  always @ (posedge clk) begin
    if (rst_n) begin
      if (config_enable) begin
        {config_OX0, config_OY0, config_OC1} <= config_data;
      end
    end else begin
      {config_OX0, config_OY0, config_OC1} <= 0;
    end
  end

  reg [COUNTER_WIDTH - 1 : 0] ox0, oy0, oc1;
  wire [COUNTER_WIDTH - 1 : 0] addrc;

  always @ (posedge clk) begin
    if (rst_n) begin
      if (addr_enable) begin
        ox0 <=  (ox0 == config_OX0 - 1) ?
          0 : ox0 + 1;
        oy0 <=  (ox0 == config_OX0 - 1) ?
          ((oy0 == config_OY0 - 1) ? 0 : oy0 + 1) : oy0;
        oc1  <= ((ox0 == config_OX0 - 1) && (oy0 == config_OY0 - 1)) ?
        ((oc1 == config_OC1 - 1) ? 0 : oc1 + 1) : oc1;
      end
    end else begin
      ox0 <= 0;
      oy0 <= 0;
      oc1 <= 0;
    end
  end

  assign addrc = oc1 * config_OX0 * config_OY0 + oy0 * config_OX0 + ox0;

  assign addr = addrc[BANK_ADDR_WIDTH - 1 : 0];

endmodule

