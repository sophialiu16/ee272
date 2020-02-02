`include "../layer_params.svh"

module conv
#(
    parameter IFMAP_SIZE = 16,
    parameter WEIGHTS_SIZE = 16,
    parameter OFMAP_SIZE = 32,

    parameter IFMAP_WIDTH = IFMAP_SIZE,
    parameter WEIGHTS_WIDTH = WEIGHTS_SIZE,
    parameter OFMAP_WIDTH = OFMAP_SIZE,
  
    parameter ARRAY_HEIGHT = 4,
    parameter ARRAY_WIDTH = 4,

    parameter BANK_ADDR_WIDTH = 8,
    parameter COUNTER_WIDTH = 32,
    parameter CONFIG_WIDTH = 32,
    parameter WEIGHTS_NUM_PARAMS = 4,
  
    parameter CONFIG_OX = 12, 
    parameter CONFIG_OY = 12, 
    parameter CONFIG_OX0 = 3,
    parameter CONFIG_OY0 = 3,
    parameter CONFIG_FX = 3,
    parameter CONFIG_FY = 3,
    parameter CONFIG_IC = 8,
    parameter CONFIG_OC = 16,
    parameter CONFIG_OC0 = 4,
    parameter CONFIG_IC0 = 4,
    parameter CONFIG_IC1 = CONFIG_IC/CONFIG_IC0,
    parameter CONFIG_OC1 = CONFIG_OC/CONFIG_OC0,
    parameter STRIDE = 1
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

  logic [15:0] input_accumulator [ARRAY_HEIGHT];
  logic [15:0] weights_accumulator [ARRAY_WIDTH];  	
  logic [15*ARRAY_WIDTH - 1:0] weights_flattened;
  logic [$clog2(ARRAY_HEIGHT) - 1:0] input_cnt;
  logic [$clog2(ARRAY_WIDTH) - 1:0] weights_cnt;
  
  logic weight_read_addr_enable, weight_read_config_enable;
    logic [BANK_ADDR_WIDTH - 1 : 0] weight_read_addr;
    logic [COUNTER_WIDTH*WEIGHTS_NUM_PARAMS - 1 : 0] weight_read_config_data;

    logic [COUNTER_WIDTH*WEIGHTS_NUM_PARAMS - 1 : 0] weight_write_data;

    logic weight_write_addr_enable, weight_write_config_enable;
    logic [BANK_ADDR_WIDTH - 1 : 0] weight_write_addr;

    logic [CONFIG_WIDTH - 1 : 0] weight_write_config_data; //fx, fy, ic1, oc1

  // input FIFO to input double buffer
  always_ff @(posedge clk, negedge rst_n) begin
      if (~rst_n) begin
				input_cnt <= 0;
      end else begin
        if (ifmap_vld) begin
          input_accumulator[input_cnt] <= ifmap_dat;
          if (input_cnt == ARRAY_HEIGHT - 1) begin
            input_cnt <= 0;
          end else begin
            input_cnt = input_cnt + 1;
          end
        end
      end
  end
  
  // weights FIFO to weight double buffer
  always_ff @(posedge clk, negedge rst_n) begin
      if (~rst_n) begin
	weights_cnt <= 0;
      end else begin
        if (weights_vld) begin
          weights_accumulator[weights_cnt] <= weights_dat;
          if (input_cnt == ARRAY_WIDTH - 1) begin
            weights_cnt <= 0;
          end else begin
            weights_cnt = weights_cnt + 1;
          end
        end
      end
  end

  integer i;

  always_comb begin
    for (i = 0; i < ARRAY_WIDTH; i = i + 1) begin
      weights_flattened[i * 16: (i + 1) * 16 - 1] = weights_accumulator[i];
    end
  end
  
  // sets inputs to weight double buffer after accumulation
  always_ff @(posedge clk, negedge rst_n) begin
    if ((input_cnt == ARRAY_WIDTH - 1) && (weights_vld)) begin
      weight_write_addr_enable <= 1;
      weight_write_data <= weights_flattened;
    end
  end
  
  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
  		weight_write_config_enable <= 1;
    	weight_write_config_data <= CONFIG_OC1 * CONFIG_IC1 * CONFIG_FY * CONFIG_FX;
    end else begin
    	weight_write_config_enable <= 0;
    end
  end 
  
    weight_read_addr_gen #(
      .COUNTER_WIDTH(COUNTER_WIDTH),
      .NUM_PARAMS(WEIGHTS_NUM_PARAMS), 
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
      .config_enable(weight_write_config_enable),
      .config_data(weight_write_config_data) // config_ic1_iy0_ix0
    );

    logic weight_switch_banks;
    logic [WEIGHTS_WIDTH - 1 : 0] weight_read_data;  

    double_buffer #(
      .DATA_WIDTH(WEIGHTS_WIDTH),
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
    logic [IFMAP_SIZE - 1 : 0] ifmap_in [ARRAY_HEIGHT - 1 : 0];
    logic [OFMAP_SIZE - 1 : 0] ofmap_in [ARRAY_WIDTH - 1 : 0]; 
    logic [OFMAP_SIZE - 1 : 0] ofmap_out[ARRAY_WIDTH - 1 : 0];
    logic [WEIGHTS_SIZE - 1 : 0] weight_in [ARRAY_WIDTH - 1 : 0];
    logic weight_write_enable_arr;



    systolic_array #(
      .IFMAP_WIDTH(IFMAP_WIDTH),
      .WEIGHTS_WIDTH(WEIGHTS_WIDTH),
      .OFMAP_WIDTH(OFMAP_WIDTH),
      .ARRAY_HEIGHT(ARRAY_HEIGHT),
      .ARRAY_WIDTH(ARRAY_WIDTH)
    ) sys_arr_U (
      .clk(clk),
      .rst_n(rst_n),
      .enable(sys_arr_enable),
      .weight_write_enable(weight_write_enable_arr),
      .ifmap_in(ifmap_in),
      .weight_in(weight_in),
      .ofmap_in(ofmap_in),
      .ofmap_out(ofmap_out)
    ); 
    // -------------------------------------------------------
endmodule

