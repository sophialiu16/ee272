module top
#(
  parameter IFMAP_WIDTH = 16,
  parameter WEIGHT_WIDTH = 16,
  parameter OFMAP_WIDTH = 32,
  parameter ARRAY_HEIGHT = 4,
  parameter ARRAY_WIDTH = 4,

  parameter BANK_ADDR_WIDTH = 8,
  parameter COUNTER_WIDTH = 32,
  parameter CONFIG_WIDTH = 32
)(
  input clk,
  input rst_n,
  input [WEIGHT_WIDTH - 1 : 0] weight_write_data
);
  localparam NUM_STATES = 3;
  logic [$clog2(NUM_STATES) : 0] curr_state;
  logic [$clog2(NUM_STATES) : 0] next_state;
  
  logic weight_read_addr_enable, weight_read_config_enable; 
  logic [BANK_ADDR_WIDTH - 1 : 0] weight_read_addr; 
  logic [COUNTER_WIDTH*NUM_PARAMS - 1 : 0] weight_read_config_data;

  logic weight_write_addr_enable, weight_write_config_enable; 
  logic [BANK_ADDR_WIDTH - 1 : 0] weight_write_addr; 
  logic [CONFIG_WIDTH - 1 : 0] weight_write_config_data;

  weight_read_addr_gen #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .NUM_PARAMS(4), //fx,fy,ic1,oc1
    .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
  ) weight_read_addr_gen_U(
    .clk(clk),
    .rst_n(rst_n),
    .addr_enable(weight_read_addr_enable),
    .addr(weight_read_addr),
    .config_enable(weight_read_config_enable),
    .config_data(weight_read_config_data)
  );

  weight_write_addr_gen #(
    .CONFIG_WIDTH(CONFIG_WIDTH),
    .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
  ) weight_write_addr_gen_U (
    .clk(clk),
    .rst_n(rst_n),
    .addr_enable(weight_write_addr_enable),
    .addr(weight_write_addr),
    .config_enable(weight_write_config_data),
    .config_data(weight_write_config_data) // config_ic1_iy0_ix0
  );
 
  logic weight_switch_banks;
  logic [WEIGHT_WIDTH - 1 : 0] weight_read_data;  

  double_buffer #(
    .DATA_WIDTH(WEIGHT_WIDTH),
    .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
  ) weight_double_buffer_U (
    .clk(clk),
    .rst_n(rst_n),
    .switch_banks(weight_switch_banks),
    .ren(weight_read_addr_enable),
    .radr(weight_read_addr),
    .rdata(weight_read_data),
    .wen(weight_write_addr_enable),
    .wadr(weight_write_addr),
    .wdata(weight_write_data)
  );
  

  logic sys_arr_enable;
  logic [IFMAP_WIDTH - 1 : 0] ifmap_in;
  logic [OFMAP_WIDTH - 1 : 0] ofmap_in; 
  logic [OFMAP_WIDTH - 1 : 0] ofmap_out;

  systolic_array #(
    .IFMAP_WIDTH(IFMAP_WIDTH),
    .WEIGHT_WIDTH(WEIGHT_WIDTH),
    .OFMAP_WIDTH(OFMAP_WIDTH),
    .ARRAY_HEIGHT(ARRAY_HEIGHT),
    .ARRAY_WIDTH(ARRAY_WIDTH)
  ) sys_arr_U (
    .clk(clk),
    .rst_n(rst_n),
    .enable(sys_arr_enable),
    .weight_write_enable(weight_write_enable),
    .ifmap_in(ifmap_in),
    .weight_in(weight_read_data),
    .ofmap_in(ofmap_in),
    .ofmap_out(ofmap_out)
  );

  // storage process
  /*always_ff @(posedge clk) begin
    curr_state <= next_state;
  end
  */
  // output process
  // currstate case statement

  // transition process - determines next state
  //always @ (curr_state) begin 
  //end

  
  //systolic_array sys {
  //  
  //}

endmodule 

