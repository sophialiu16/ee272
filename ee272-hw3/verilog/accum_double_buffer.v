module accum_double_buffer
#(
  parameter DATA_WIDTH = 64,
  parameter BANK_ADDR_WIDTH = 32 // There are two banks
)(
  input clk,
  input rst_n,
  input switch_banks,
  input ren_out,
  input ren_sys_arr,
  input [BANK_ADDR_WIDTH - 1 : 0] radr_out,
  input [BANK_ADDR_WIDTH - 1 : 0] radr_sys_arr,
  output [DATA_WIDTH - 1 : 0] rdata_out,
  output [DATA_WIDTH - 1 : 0] rdata_sys_arr,
  input wen,
  input [BANK_ADDR_WIDTH - 1 : 0] wadr,
  input [DATA_WIDTH - 1 : 0] wdata
);

  // Internally keeps track of which bank is being used for reading and which
  // for writing using some state
  reg systolic_bank;

  reg wen0, ren0, wen1, ren1;

  reg [BANK_ADDR_WIDTH - 1 : 0] radr; 
  
  reg [DATA_WIDTH - 1 : 0] rdata_sys_arr_reg; 
  reg [DATA_WIDTH - 1 : 0] rdata_out_reg; 
  reg [DATA_WIDTH - 1 : 0] rdata0, rdata1; 
  
  ram_sync_1r1w #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(BANK_ADDR_WIDTH),
    .DEPTH(128) //todo
  )
  ram0 (
    .clk(clk),
    .wen(wen0),
    .wadr(wadr),
    .wdata(wdata),
    .ren(ren0),
    .radr(radr),
    .rdata(rdata0)
  );

   ram_sync_1r1w #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(BANK_ADDR_WIDTH),
    .DEPTH(128) //todo
  )
  ram1 (
    .clk(clk),
    .wen(wen1),
    .wadr(wadr),
    .wdata(wdata),
    .ren(ren1),
    .radr(radr),
    .rdata(rdata1)
  );
  
  assign rdata_sys_arr = rdata_sys_arr_reg;
  assign rdata_out = rdata_out_reg;

  integer i;
  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      systolic_bank <= 0;
      
      for (i = 0; i < DATA_WIDTH; i = i + 1) begin 
          rdata_sys_arr_reg[i] <= 0; // DATA_WIDTH'b0;
      end 
    end else begin 
      if (ren_sys_arr) begin
        radr <= radr_sys_arr;
        if (systolic_bank) begin
          rdata_sys_arr_reg <= rdata1;
          ren1 <= systolic_bank;
        end else begin
          rdata_sys_arr_reg <= rdata0;
          ren0 <= ~systolic_bank;
        end
     end else begin
      for (i = 0; i < DATA_WIDTH; i = i + 1) begin 
          rdata_sys_arr_reg[i] <= 0;
      end
     end
      
      if (ren_out) begin 
        radr <= radr_out; 
        if (systolic_bank) begin
          rdata_out_reg <= rdata0;
          ren0 <= systolic_bank;
        end else begin
          rdata_out_reg <= rdata1;
          ren1 <= ~systolic_bank;
        end
      end

      if (wen) begin
        wen0 <= ~systolic_bank;
        wen1 <= systolic_bank;
      end

      if (switch_banks) begin
         systolic_bank <= ~systolic_bank;
      end
    end // end reset
  end // end always_ff

endmodule

