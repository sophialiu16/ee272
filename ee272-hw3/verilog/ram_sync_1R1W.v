module ram_sync_1R1W
#(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 7,
  parameter DEPTH = 128
)(
	input [ADDR_WIDTH-1:0] radr;
	input [ADDR_WIDTH-1:0] wadr;
	input [DATA_WIDTH-1:0] d;
	input we;
	input re;
	input clk;
	output[DATA_WIDTH-1:0] q;


);

   // synopsys translate_off
	reg [DATA_WIDTH-1:0] q;

	reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
		
	always @(posedge clk) begin
		if (we) begin
			mem[wadr] <= d; // write port
		end
		if (re) begin
			q <= mem[radr] ; // read port
		end
	end
   // synopsys translate_on

endmodule
