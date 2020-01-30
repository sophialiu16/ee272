`define CONFIG_WIDTH 32
`define BANK_ADDR_WIDTH 8

module input_write_addr_gen_tb;

  reg clk;
  reg rst_n;
  reg config_enable;
  reg [`CONFIG_WIDTH - 1 : 0] config_data;
  reg addr_enable;
  reg [`BANK_ADDR_WIDTH - 1 : 0] addr;

  always #10 clk =~clk;
   
  input_write_addr_gen #( 
    .CONFIG_WIDTH(32),
    .BANK_ADDR_WIDTH(8)
  ) addr_gen (
    .clk(clk),
    .rst_n(rst_n),
    .addr_enable(addr_enable),
    .addr(addr),
    .config_enable(config_enable),
    .config_data(config_data)
  );
  
  initial begin
    clk <= 0;
    rst_n <= 1;
    config_enable <= 0;
    config_data <= 0;
    addr_enable <= 0;
    #20 rst_n <= 0;
    #20 rst_n <= 1;
    config_enable <= 1;
    config_data <= 2*5*5; // For the example in the homework pdf, IC1 = 2, IY0 = 5, IX0 = 5
    #20 config_enable <= 0;
    addr_enable <= 1;
    assert(addr == 0);
    #15 assert(addr == 1);
    #20 assert(addr == 2);
    #20 assert(addr == 3);
    #20 assert(addr == 4);
    #900 assert(addr == 49);
    #20 assert(addr == 0);
    addr_enable <= 0;
    #20 assert(addr == 0);
    addr_enable <= 1;
    #20 assert(addr == 1);
  end
  
  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, input_write_addr_gen_tb);
    #20000000;
    $finish(2);
  end

endmodule
