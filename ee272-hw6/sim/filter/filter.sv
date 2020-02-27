`timescale 1s/1fs

module filter #(
    parameter real tau=50e-9
) (
    input real in
);
    // ADD VARIABLE DECLARATIONS HERE AS NECESSARY
   real prev_out, delta_t, prev_t;
    function real out();
         // FILL IN FUNCTION IMPLEMENTATION
         out = $exp(-delta_t/tau) * prev_out + (1 - $exp(-delta_t/tau)) * in;
    endfunction

    initial begin
          delta_t = 0;
          prev_t = $realtime;
          prev_out = 0;
    end

    always @(in) begin
          delta_t = $realtime - prev_t;
          prev_t = $realtime;
          prev_out = out();
        // UPDATE INTERNAL STATE VARIABLES AS NECESSARY
    end
endmodule
