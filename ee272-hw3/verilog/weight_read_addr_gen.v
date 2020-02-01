module weight_read_addr_gen
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

  reg [COUNTER_WIDTH - 1 : 0] config_FX, config_FY, config_IC0, config_IC1;

  always @ (posedge clk) begin
    if (rst_n) begin
      if (config_enable) begin
        {config_FX, config_FY, config_IC1, config_OC1} <= config_data;
      end
    end else begin
      {config_FX, config_FY,  config_IC1, config_OC1} <= 0;
    end
  end

  reg [COUNTER_WIDTH - 1 : 0] fx, fy, ic1, oc1;
  wire [COUNTER_WIDTH - 1 : 0] addrc;

  always @ (posedge clk) begin
    if (rst_n) begin
      if (addr_enable) begin
        fx <=  (fx == config_FX - 1) ?
          0 : fx + 1;
        fy <=  (FX == config_FX - 1) ?
        ((fy == config_FY - 1) ? 0 :fy + 1) : fy;
        ic1  <= ((fx == config_FX - 1) && (fy == config_FY - 1)) ?
        ((ic1 == config_IC1 - 1) ? 0 : ic1 + 1) : ic1;
        oc1  <= ((fx == config_FX - 1) && (fy == config_FY - 1) && (ic1 == config_IC1 - 1)) ?
        ((oc1 == config_OC1 - 1) ? 0 : oc1 + 1) : oc1;
      end
    end else begin
      fx <= 0;
      fy <= 0;
      ic1 <= 0;
      oc1 <= 0;
    end
  end

  assign addrc = (oc1 * config_IC1 * config_FY * config_FX) + (ic1 * config_FY * config_FX) + (fy * config_FX) + fx
  assign addr = addrc[BANK_ADDR_WIDTH - 1 : 0];

endmodule

