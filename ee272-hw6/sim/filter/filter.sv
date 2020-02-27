`timescale 1s/1fs

module filter #(
    parameter real tau=50e-9
) (
    input real in
);
    // ADD VARIABLE DECLARATIONS HERE AS NECESSARY
   real prev_out, prev_t, prev_in;
    function real out();
         // FILL IN FUNCTION IMPLEMENTATION
         out = $exp(-($realtime - prev_t)/tau) * prev_out + (1 - $exp(-($realtime - prev_t)/tau)) * prev_in;
    endfunction

    initial begin
          prev_out = out();
          prev_t = $realtime;
          prev_in = 0;
    end

    always @(in) begin
          //prev_t =  $realtime;
	  prev_out = out();  
          prev_in = in;
          prev_t = $realtime;
        // UPDATE INTERNAL STATE VARIABLES AS NECESSARY
    end
endmodule
