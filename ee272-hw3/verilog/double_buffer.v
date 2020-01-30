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
  logic read_bank;
  logic [DATA_WIDTH - 1 : 0] buffers [1 : 0][BANK_ADDR_WIDTH - 1 : 0]
  
  always_ff @(posedge clk) begin 
    if (~rst_n) begin 
      integer i, j;
      for(i=0; i < BANK_ADDR_WIDTH; i=i+1) begin
        buffers[0][i] <= 0;
        buffers[1][i] <= 0;
      end
      read_bank <= 0;
    end 
    else if begin 
  
    	if (ren) begin
      	rdata <= buffers[read_bank][radr];
    	end 
    
      if (wen) begin
        buffers[~read_bank][wadr] <= wdata;
      end
      
      if (switch_banks) begin 
        read_bank <= ~read_bank;
      end
    end // end reset
  end // end always_ff

endmodule
