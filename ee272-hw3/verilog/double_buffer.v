module double_buffer
#(
  parameter DATA_WIDTH = 64,
  parameter BANK_ADDR_WIDTH = 32 // There are two banks
)(
  input clk,
  input rst_n,
  input switch_banks,
  input ren,
  input [BANK_ADDR_WIDTH - 1 : 0] radr,
  output [DATA_WIDTH - 1 : 0] rdata,
  input wen,
  input [BANK_ADDR_WIDTH - 1 : 0] wadr,
  input [DATA_WIDTH - 1 : 0] wdata
);

  // Internally keeps track of which bank is being used for reading and which
  // for writing using some state
  reg read_bank;
  reg wen0, ren0, wen1, ren1;

  reg [DATA_WIDTH - 1 : 0] rdata_reg; 
  reg [DATA_WIDTH - 1 : 0] rdata0, rdata1; 
  

  ram_sync_1r1w #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(BANK_ADDR_WIDTH),
    .DEPTH(BANK_ADDR_WIDTH)
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
    .DEPTH(BANK_ADDR_WIDTH)
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
  
  assign rdata = rdata_reg;
 
  always_ff @(posedge clk) begin
    if (~rst_n) begin
      read_bank <= 0;
    end
    else begin
      if (ren) begin
        ren0 <= ~read_bank;
        ren1 <= read_bank;
        if (read_bank) begin
          rdata_reg <= rdata1;
        end else begin 
          rdata_reg <= rdata0;
        end
     end

      if (wen) begin
        wen0 <= read_bank;
        wen1 <= ~read_bank;
      end

      if (switch_banks) begin
        read_bank <= ~read_bank;
      end
    end // end reset
  end // end always_ff

endmodule


