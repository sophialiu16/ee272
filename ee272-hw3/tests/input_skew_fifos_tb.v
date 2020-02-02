`define IFMAP_WIDTH 16
`define ARRAY_HEIGHT 4

module input_skew_fifos_tb;

  reg clk;
  reg rst_n;
  wire full_n_w [`ARRAY_HEIGHT - 1 : 0];
  wire empty_n_w [`ARRAY_HEIGHT - 1 : 0];
  reg enq_r [`ARRAY_HEIGHT - 1 : 0];
  reg deq_r [`ARRAY_HEIGHT - 1 : 0];
  reg signed [`IFMAP_WIDTH - 1 : 0] d_in_r [`ARRAY_HEIGHT - 1 : 0];
  wire signed [`IFMAP_WIDTH - 1 : 0] d_out_w [`ARRAY_HEIGHT - 1 : 0];

  always #10 clk =~clk;
  input_skew_fifos
  #(
    .IFMAP_WIDTH(`IFMAP_WIDTH),
    .ARRAY_HEIGHT(`ARRAY_HEIGHT)
  ) input_skew_fifos_inst (
    .clk(clk),
    .rst_n(rst_n),
    .full_n(full_n_w),
    .enq(enq_r),
    .d_in(d_in_r),
    .empty_n(empty_n_w),
    .deq(deq_r),
    .d_out(d_out_w)
  );

  integer y;

  initial begin
    clk <= 0;
    rst_n <= 1;
    for (y = 0; y < `ARRAY_HEIGHT; y = y + 1) enq_r[y] <= 0;
    for (y = 0; y < `ARRAY_HEIGHT; y = y + 1) deq_r[y] <= 0;
    #20 rst_n <= 0;
    #20 rst_n <= 1;
    // At the beginning all FIFOs are empty
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) enq_r[y] <= 1;
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) if (empty_n_w[y]) deq_r[y] <= 1;
    d_in_r[0] = 1;
    d_in_r[1] = 2;
    d_in_r[2] = 3;
    d_in_r[3] = 4;
    #20 
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) if (empty_n_w[y]) deq_r[y] <= 1;
    d_in_r[0] = 2;
    d_in_r[1] = 3;
    d_in_r[2] = 4;
    d_in_r[3] = 5;
    assert(d_out_w[1] == 2);
    #20
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) if (empty_n_w[y]) deq_r[y] <= 1;
    d_in_r[0] = 3;
    d_in_r[1] = 4;
    d_in_r[2] = 5;
    d_in_r[3] = 6;
    assert(d_out_w[1] == 3);
    assert(d_out_w[2] == 3);
    #20
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) if (empty_n_w[y]) deq_r[y] <= 1;
    d_in_r[0] = 4;
    d_in_r[1] = 5;
    d_in_r[2] = 6;
    d_in_r[3] = 7;
    assert(d_out_w[1] == 4);
    assert(d_out_w[2] == 4);
    assert(d_out_w[3] == 4);
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) enq_r[y] <= 0;
    for (y = 0; y <`ARRAY_HEIGHT; y = y + 1) deq_r[y] <= 0;
  end

  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, input_skew_fifos_tb);
    #20000000;
    $finish(2);
  end

endmodule 
