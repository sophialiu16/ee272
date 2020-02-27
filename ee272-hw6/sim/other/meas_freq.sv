// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

module meas_freq (
    input wire logic clk,
    output real freq
);
    real dt;
    real last_t=0.0;
    always @(posedge clk) begin
        // compute time difference
        dt = $realtime - last_t;
        freq = 1.0/dt;
        // update time of last edge
        last_t = $realtime;
    end
endmodule
