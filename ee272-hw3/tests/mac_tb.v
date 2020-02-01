`include "../verilog/mac.v"
`define IFMAP_WIDTH 4
`define WEIGHT_WIDTH = 4
`define OFMAP_WIDTH = 8

module mac_tb;

  reg clk;
  reg rst_n;
  reg enable;
  reg weight_write_enable;
  reg [4 - 1 : 0] ifmap_in;
  reg [4 - 1 : 0] weight_in;
  reg [8 - 1 : 0] ofmap_in;
  
  reg [4 - 1 : 0] ifmap_out;
  reg [8 - 1 : 0] ofmap_out;
  
  always #10 clk =~clk;

  mac #(
    .IFMAP_WIDTH(4),
    .OFMAP_WIDTH(8),
    .WEIGHT_WIDTH(4)
  ) mac_dut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .weight_write_enable(weight_write_enable),
    .ifmap_in(ifmap_in),
    .weight_in(weight_in),
    .ofmap_in(ofmap_in),
    .ifmap_out(ifmap_out),
    .ofmap_out(ofmap_out)
  );

  initial begin
    clk <= 0;
    rst_n <= 1;
    enable <= 0;
    ifmap_in <= 0;
    weight_in <= 0;
    ofmap_in <= 0;
    weight_write_enable <= 0;

    #20 rst_n <= 0;
    #20 rst_n <= 1;
    weight_write_enable <= 1;   
    weight_in <= 4;
    #20 

    weight_write_enable <= 1;    
    enable <= 1;
    ifmap_in <= 2;
    weight_in <= 3;
    ofmap_in <= 1;
    
    #20
    enable <= 1;
    ifmap_in <= 3;
    weight_in <= 4;
    ofmap_in <= 2;
  end

  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, mac_tb);
    #20000000;
    $finish(2);
  end

endmodule

                                                       
