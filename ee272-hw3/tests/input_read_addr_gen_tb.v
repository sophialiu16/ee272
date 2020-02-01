`define COUNTER_WIDTH 32
`define NUM_PARAMS 8
`define BANK_ADDR_WIDTH 8

module input_read_addr_gen_tb;

  reg clk;
  reg rst_n;
  reg config_enable;
  reg addr_enable;
  reg [`BANK_ADDR_WIDTH - 1 : 0] addr;
  reg [`COUNTER_WIDTH - 1 : 0] config_OX0, config_OY0, config_FX, config_FY, config_STRIDE, config_IX0, config_IY0, config_IC1;

  always #10 clk =~clk;
   
  input_read_addr_gen #( 
    .COUNTER_WIDTH(`COUNTER_WIDTH),
    .NUM_PARAMS(`NUM_PARAMS),
    .BANK_ADDR_WIDTH(`BANK_ADDR_WIDTH)
  ) addr_gen (
    .clk(clk),
    .rst_n(rst_n),
    .addr_enable(addr_enable),
    .addr(addr),
    .config_enable(config_enable),
    .config_data({config_OX0, config_OY0, config_FX, config_FY, config_STRIDE, config_IX0, config_IY0, config_IC1})
  );
  
  initial begin
    clk <= 0;
    rst_n <= 1;
    config_enable <= 0;
    config_OX0 <= 0;
    config_OY0 <= 0;
    config_FX <= 0;
    config_FY <= 0;
    config_STRIDE <= 0;
    config_IX0 <= 0;
    config_IY0 <= 0;
    config_IC1 <= 0;
    addr_enable <= 0;

    #20 rst_n <= 0;
    
    #20 rst_n <= 1;
    config_enable <= 1;
    config_OX0 <= 3;
    config_OY0 <= 3;
    config_FX <= 3;
    config_FY <= 3;
    config_STRIDE <= 1;
    config_IX0 <= 5;
    config_IY0 <= 5;
    config_IC1 <= 2;
    
    #20 config_enable <= 0;
    addr_enable <= 1;

    // kernel at fx = 0, fy = 0
        $display("addr = %d", addr); assert(addr == 0);
    #15 $display("addr = %d", addr); assert(addr == 1);
    #20 $display("addr = %d", addr); assert(addr == 2);

    #20 $display("addr = %d", addr); assert(addr == 5);
    #20 $display("addr = %d", addr); assert(addr == 6);
    #20 $display("addr = %d", addr); assert(addr == 7);
    
    #20 $display("addr = %d", addr); assert(addr == 10);
    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);
    
    // kernel at fx = 1, fy = 0
    #20 $display("addr = %d", addr); assert(addr == 1);
    #20 $display("addr = %d", addr); assert(addr == 2);
    #20 $display("addr = %d", addr); assert(addr == 3);
    
    #20 $display("addr = %d", addr); assert(addr == 6);
    #20 $display("addr = %d", addr); assert(addr == 7);
    #20 $display("addr = %d", addr); assert(addr == 8);

    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);

    // kernel at fx = 2, fy = 0
    #20 $display("addr = %d", addr); assert(addr == 2);
    #20 $display("addr = %d", addr); assert(addr == 3);
    #20 $display("addr = %d", addr); assert(addr == 4);

    #20 $display("addr = %d", addr); assert(addr == 7);
    #20 $display("addr = %d", addr); assert(addr == 8);
    #20 $display("addr = %d", addr); assert(addr == 9);

    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);
    #20 $display("addr = %d", addr); assert(addr == 14);

    // kernel at fx = 0, fy = 1
    #20 $display("addr = %d", addr); assert(addr == 5);
    #20 $display("addr = %d", addr); assert(addr == 6);
    #20 $display("addr = %d", addr); assert(addr == 7);

    #20 $display("addr = %d", addr); assert(addr == 10);
    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);
    
    #20 $display("addr = %d", addr); assert(addr == 15);
    #20 $display("addr = %d", addr); assert(addr == 16);
    #20 $display("addr = %d", addr); assert(addr == 17);
    
    // kernel at fx = 1, fy = 1
    #20 $display("addr = %d", addr); assert(addr == 6);
    #20 $display("addr = %d", addr); assert(addr == 7);
    #20 $display("addr = %d", addr); assert(addr == 8);
    
    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);

    #20 $display("addr = %d", addr); assert(addr == 16);
    #20 $display("addr = %d", addr); assert(addr == 17);
    #20 $display("addr = %d", addr); assert(addr == 18);

    // kernel at fx = 2, fy = 1
    #20 $display("addr = %d", addr); assert(addr == 7);
    #20 $display("addr = %d", addr); assert(addr == 8);
    #20 $display("addr = %d", addr); assert(addr == 9);

    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);
    #20 $display("addr = %d", addr); assert(addr == 14);

    #20 $display("addr = %d", addr); assert(addr == 17);
    #20 $display("addr = %d", addr); assert(addr == 18);
    #20 $display("addr = %d", addr); assert(addr == 19);

    // kernel at fx = 0, fy = 2
    #20 $display("addr = %d", addr); assert(addr == 10);
    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);

    #20 $display("addr = %d", addr); assert(addr == 15);
    #20 $display("addr = %d", addr); assert(addr == 16);
    #20 $display("addr = %d", addr); assert(addr == 17);
    
    #20 $display("addr = %d", addr); assert(addr == 20);
    #20 $display("addr = %d", addr); assert(addr == 21);
    #20 $display("addr = %d", addr); assert(addr == 22);
    
    // kernel at fx = 1, fy = 2
    #20 $display("addr = %d", addr); assert(addr == 11);
    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);
    
    #20 $display("addr = %d", addr); assert(addr == 16);
    #20 $display("addr = %d", addr); assert(addr == 17);
    #20 $display("addr = %d", addr); assert(addr == 18);

    #20 $display("addr = %d", addr); assert(addr == 21);
    #20 $display("addr = %d", addr); assert(addr == 22);
    #20 $display("addr = %d", addr); assert(addr == 23);

    // kernel at fx = 2, fy = 2
    #20 $display("addr = %d", addr); assert(addr == 12);
    #20 $display("addr = %d", addr); assert(addr == 13);
    #20 $display("addr = %d", addr); assert(addr == 14);

    #20 $display("addr = %d", addr); assert(addr == 17);
    #20 $display("addr = %d", addr); assert(addr == 18);
    #20 $display("addr = %d", addr); assert(addr == 19);

    #20 $display("addr = %d", addr); assert(addr == 22);
    #20 $display("addr = %d", addr); assert(addr == 23);
    #20 $display("addr = %d", addr); assert(addr == 24);

    // kernel at fx = 0, fy = 0, ic1 = 1
    #20 $display("addr = %d", addr); assert(addr == 0 + 25);
    #20 $display("addr = %d", addr); assert(addr == 1 + 25);
    #20 $display("addr = %d", addr); assert(addr == 2 + 25);

    #20 $display("addr = %d", addr); assert(addr == 5 + 25);
    #20 $display("addr = %d", addr); assert(addr == 6 + 25);
    #20 $display("addr = %d", addr); assert(addr == 7 + 25);
    
    #20 $display("addr = %d", addr); assert(addr == 10 + 25);
    #20 $display("addr = %d", addr); assert(addr == 11 + 25);
    #20 $display("addr = %d", addr); assert(addr == 12 + 25);
    
    #1440 $display("addr = %d", addr); assert(addr == 24 + 25); 
    #20 $display("addr = %d", addr); assert(addr == 0);
    #3220 $display("addr = %d", addr); assert(addr == 24 + 25); 
  end
  
  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, input_read_addr_gen_tb);
    #20000000;
    $finish(2);
  end

endmodule
