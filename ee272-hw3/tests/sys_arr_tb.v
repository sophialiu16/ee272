`define IFMAP_WIDTH 4
`define WEIGHT_WIDTH = 4
`define OFMAP_WIDTH = 8
`define ARRAY_HEIGHT = 4
`define ARRAY_HEIGHT = 4

module sys_arr_tb;

  reg clk;
  reg rst_n;
  reg enable;
  reg weight_write_enable;
  reg [4 - 1 : 0] ifmap_in [4-1:0];
  reg [4 - 1 : 0] weight_in [4 - 1 : 0];
  reg [8 - 1 : 0] ofmap_in [4 - 1 : 0];
  reg [8 - 1 : 0] ofmap_out [4 - 1 : 0];

  always #10 clk =~clk;

  systolic_array #(
    .IFMAP_WIDTH(4),
    .WEIGHT_WIDTH(4),
    .OFMAP_WIDTH(8),
    .ARRAY_HEIGHT(4),
    .ARRAY_WIDTH(4)
  ) sys_arr_dut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .weight_write_enable(weight_write_enable),
    .ifmap_in(ifmap_in),
    .weight_in(weight_in),
    .ofmap_in(ofmap_in),
    .ofmap_out(ofmap_out)
  );

  integer i, j;
  initial begin
    clk <= 0;
    rst_n <= 1;
    enable <= 0;
    for (i = 0; i < 4; i = i + 1) begin
       ifmap_in[i] <= 0;
       weight_in[i] <= 0;
       ofmap_in[i] <= 0;
    end
    weight_write_enable <= 0;
    #10
    #20 rst_n <= 0;
    #20 rst_n <= 1;
    
    weight_write_enable <= 1;

    for (i = 0; i < 4; i = i + 1) begin 
      weight_in[i] <= i;
    end
    
    #20

    for (i = 0; i < 20; i = i + 1) begin
      weight_write_enable <= 1;
      enable <= 1;
      for (j = 0; j < 4; j = j + 1) begin
        ifmap_in[j] <= i + j;
        weight_in[j] <= i;
        ofmap_in[j] <= 2*i;
    	end
    end

  end

  initial begin
    $vcdplusfile("sa_dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, sys_arr_tb);
    #20000000;
    $finish(2);
  end
endmodule


