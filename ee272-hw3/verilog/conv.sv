module conv
#(
    // size of files -> overwritten by testbench param values
    parameter IFMAP_SIZE = 16,
    parameter WEIGHTS_SIZE = 16,
    parameter OFMAP_SIZE = 32,

    parameter IFMAP_WIDTH = 16,
    parameter WEIGHTS_WIDTH = 16,
    parameter OFMAP_WIDTH = 32,

    // half of weights file length for now, change later
    // divide that by 4 since storing 4 pixels per address
    parameter BANK_ADDR_WIDTH = 16, 
    parameter COUNTER_WIDTH = 32,
    parameter CONFIG_WIDTH = 32,
    parameter WEIGHTS_NUM_PARAMS = 4,
    parameter INPUT_NUM_PARAMS = 8,

    parameter CONFIG_OX = 12,//56,
    parameter CONFIG_OY = 12,//56,
    parameter CONFIG_OX0 = 3,//8,
    parameter CONFIG_OY0 = 3,//8,
    parameter CONFIG_OX1 = CONFIG_OX/CONFIG_OX0,
    parameter CONFIG_OY1 = CONFIG_OY/CONFIG_OY0,
    parameter CONFIG_IX0 = 5,//112,
    parameter CONFIG_IY0 = 5,//112,
    parameter CONFIG_FX = 3,
    parameter CONFIG_FY = 3,
    parameter CONFIG_IC = 8,//64,
    parameter CONFIG_OC = 16, //64,
    parameter CONFIG_OC0 = 4, //16,
    parameter CONFIG_IC0 = 4, //16,
    parameter CONFIG_IC1 = CONFIG_IC/CONFIG_IC0,
    parameter CONFIG_OC1 = CONFIG_OC/CONFIG_OC0,
    parameter STRIDE = 1,

    parameter ARRAY_HEIGHT = CONFIG_OX0,
    parameter ARRAY_WIDTH = CONFIG_OY0
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

  logic [IFMAP_WIDTH*ARRAY_HEIGHT - 1:0] input_flattened;
  logic [$clog2(ARRAY_HEIGHT) - 1:0] input_cnt;
  logic input_read_addr_enable, input_read_config_enable;
  logic [BANK_ADDR_WIDTH - 1 : 0] input_read_addr;
  logic [COUNTER_WIDTH*INPUT_NUM_PARAMS - 1 : 0] input_read_config_data;
  logic [IFMAP_WIDTH*ARRAY_WIDTH - 1 : 0] input_write_data;
  logic input_write_addr_enable, input_write_config_enable;
  logic [BANK_ADDR_WIDTH - 1 : 0] input_write_addr;
  logic [CONFIG_WIDTH - 1 : 0] input_write_config_data;
  logic [$clog2(BANK_ADDR_WIDTH) - 1: 0] input_writes_cnt;
  logic input_switch_banks;
  logic [IFMAP_WIDTH*ARRAY_WIDTH - 1 : 0] input_read_data;
  
  logic [WEIGHTS_WIDTH*ARRAY_WIDTH - 1:0] weights_flattened;
  logic [$clog2(ARRAY_WIDTH) - 1:0] weights_cnt;
  logic weight_read_addr_enable, weight_read_config_enable;
  logic [BANK_ADDR_WIDTH - 1 : 0] weight_read_addr;
  logic [COUNTER_WIDTH*WEIGHTS_NUM_PARAMS - 1 : 0] weight_read_config_data;
  logic [WEIGHTS_WIDTH*ARRAY_WIDTH - 1 : 0] weight_write_data;
  logic weight_write_addr_enable, weight_write_config_enable;
  logic [BANK_ADDR_WIDTH - 1 : 0] weight_write_addr;
  logic [CONFIG_WIDTH - 1 : 0] weight_write_config_data; //fx, fy, ic1, oc1
  logic [$clog2(BANK_ADDR_WIDTH) - 1: 0] weight_writes_cnt;
  logic weight_switch_banks;
  logic [WEIGHTS_WIDTH*ARRAY_WIDTH - 1 : 0] weight_read_data;
  logic [$clog2(ARRAY_HEIGHT) - 1: 0] weight_read_cnt;
 
  logic sys_arr_enable;
  logic [IFMAP_WIDTH - 1 : 0] ifmap_in [ARRAY_HEIGHT - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] ofmap_in [ARRAY_WIDTH - 1 : 0];
  logic [OFMAP_WIDTH - 1 : 0] ofmap_out[ARRAY_WIDTH - 1 : 0];
  logic [WEIGHTS_WIDTH - 1 : 0] weight_in [ARRAY_WIDTH - 1 : 0];
  logic weight_write_enable_arr;


  // input FIFO to input double buffer
  always_ff @(posedge clk, negedge rst_n) begin
      if (~rst_n) begin
        input_cnt <= 0;
        input_writes_cnt <= 0;
      end else begin
        if (ifmap_vld) begin
          input_flattened[input_cnt*IFMAP_WIDTH +: IFMAP_WIDTH] <= ifmap_dat;
          if (input_cnt == ARRAY_HEIGHT - 1) begin
            input_cnt <= 0;
            input_writes_cnt <= input_writes_cnt + 1;
          end else begin
            input_cnt = input_cnt + 1;
          end
        end
      end
  end

  // weights FIFO to weight double buffer
  always_ff @(posedge clk, negedge rst_n) begin
      weights_rdy <= 1;
      if (~rst_n) begin
        weights_cnt <= 0;
        weight_writes_cnt <= 0;
      end else begin
        if (weights_vld) begin
          weights_flattened[weights_cnt*WEIGHTS_WIDTH +: WEIGHTS_WIDTH] <= weights_dat;
          if (weights_cnt == ARRAY_WIDTH - 1) begin
            weights_cnt <= 0;
            weight_writes_cnt <= weight_writes_cnt + 1;
          end else begin
            weights_cnt = weights_cnt + 1;
          end
        end
      end
  end

  assign weight_write_data = weights_flattened;
  assign input_write_data = input_flattened;
  // sets inputs to weight double buffer after accumulation
  always_comb begin
    if ((weights_cnt == 0) && (weights_vld)) begin
      weight_write_addr_enable <= 1;
    end else begin
      weight_write_addr_enable <= 0;
    end

    if ((weight_write_addr_enable == 1) && (weight_writes_cnt == BANK_ADDR_WIDTH - 1)) begin
      weight_switch_banks <= 1;
    end else begin
      weight_switch_banks <= 0;
    end
  end

  always_comb begin
    if ((input_cnt == 0) && (ifmap_vld)) begin
      input_write_addr_enable <= 1;
    end else begin
      input_write_addr_enable <= 0;
    end
    
    if ((input_write_addr_enable == 1) && (input_writes_cnt == BANK_ADDR_WIDTH - 1)) begin
      input_switch_banks <= 1;
    end else begin
      input_switch_banks <= 0;
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
  
  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        input_write_config_enable <= 1;
        input_write_config_data <= CONFIG_IC1 * CONFIG_IY0 * CONFIG_IX0;
    end else begin
        input_write_config_enable <= 0;
    end
  end
  
  // read in weight data to sys arr
  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      weight_read_config_enable <= 1;
      weight_read_config_data <= {CONFIG_FX, CONFIG_FY, CONFIG_IC1, CONFIG_OC1};
    end else begin
      weight_read_config_enable <= 0;
    end
  end
  
  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      weight_read_addr_enable <= 0;	  
      weight_read_cnt <= 0;
    end else begin
      if (weight_read_cnt == ARRAY_HEIGHT - 1) begin
        weight_read_addr_enable <= 1;
        weight_read_cnt <= 0;
      end else begin
        weight_read_addr_enable <= 0;
        weight_read_cnt <= weight_read_cnt + 1;
      end
    end
  end

always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      input_read_config_enable <= 1;
      input_read_config_data <= {config_OX0, config_OY0, config_FX, config_FY,
          config_STRIDE, config_IX0, config_IY0, config_IC1};
    end else begin
      input_read_config_enable <= 0;
    end
  end

  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      input_read_addr_enable <= 0;
      input_read_cnt <= 0;
    end else begin
      if (input_read_cnt == ARRAY_HEIGHT - 1) begin
        input_read_addr_enable <= 1;
        input_read_cnt <= 0;
      end else begin
        input_read_addr_enable <= 0;
        input_read_cnt <= input_read_cnt + 1;
      end
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

    double_buffer #(
      .DATA_WIDTH(WEIGHTS_WIDTH*ARRAY_WIDTH),
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

    input_read_addr_gen #(
      .COUNTER_WIDTH(COUNTER_WIDTH),
      .NUM_PARAMS(INPUT_NUM_PARAMS),
      .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
     ) input_read_addr_gen_U(
      .clk(clk),
      .rst_n(rst_n),
      .addr_enable(input_read_addr_enable),
     .addr(input_read_addr),
     .config_enable(input_read_config_enable),
     .config_data(input_read_config_data)
    );
  
  	input_write_addr_gen #(
      .CONFIG_WIDTH(CONFIG_WIDTH),
      .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
    ) input_write_addr_gen_U (
      .clk(clk),
      .rst_n(rst_n),
      .addr_enable(input_write_addr_enable),
      .addr(input_write_addr),
      .config_enable(input_write_config_enable),
      .config_data(input_write_config_data) // config IC1 IY0 IX0
    );
  
  	double_buffer #(
      .DATA_WIDTH(IFMAP_WIDTH*ARRAY_WIDTH),
      .BANK_ADDR_WIDTH(BANK_ADDR_WIDTH)
    ) input_double_buffer_U (
      .clk(clk),
      .rst_n(rst_n),
      .switch_banks(input_switch_banks),
      .ren(input_read_addr_enable),
      .radr(input_read_addr),
      .rdata(input_read_data),
      .wen(input_write_addr_enable),
      .wadr(input_write_addr),
      .wdata(input_write_data)
    );

    systolic_array #(
      .IFMAP_WIDTH(IFMAP_WIDTH),
      .WEIGHT_WIDTH(WEIGHTS_WIDTH),
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
endmodule

