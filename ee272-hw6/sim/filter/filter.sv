`timescale 1s/1fs

module filter #(
    parameter real tau=50e-9
) (
    input real in
);
    // ADD VARIABLE DECLARATIONS HERE AS NECESSARY

    function real out();
        // FILL IN FUNCTION IMPLEMENTATION
    endfunction

    always @(in) begin
        // UPDATE INTERNAL STATE VARIABLES AS NECESSARY
    end
endmodule
