// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

module pll #(
    parameter real ki_ctrl=0,
    parameter real kp_ctrl=0,
    parameter real init_ctrl=0,
    parameter real vdd=0.8,
    parameter integer freq_div_n=30,
    parameter real filter_tau=15.9e-9
) (
    input clkin,
    output clkout
);
    // ring oscillator
    real vdd_ring;
    ringosc ringosc_i (
        .vdd(vdd_ring),
        .out(clkout)
    );

    // frequency divider
    logic divo;
    freq_div #(
        .N(freq_div_n)
    ) freq_div_i (
        .in(clkout),
        .out(divo)
    );

    // XOR gate for phase detector
    logic xor_out;
    assign xor_out = clkin ^ divo;

    // RC filter on XOR gate output
    real filter_in;
    assign filter_in = xor_out * vdd;
    filter #(
        .tau(filter_tau)
    ) filter_i (
        .in(filter_in)
    );

    // Proportional-Integral controller
    pi_ctrl pi_ctrl_i = new(.ki(ki_ctrl),
                            .kp(kp_ctrl),
                            .init(init_ctrl)
                        );

    // updating the VCO input voltage
    real err;
    always @(posedge clkin) begin
        err = filter_i.out() - vdd/2;
        pi_ctrl_i.update(err, vdd_ring);
    end
endmodule
