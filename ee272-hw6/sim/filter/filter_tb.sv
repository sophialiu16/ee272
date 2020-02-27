// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

module filter_tb;
    real in;
    filter #(
        .tau(123e-9)
    ) filter_i (
        .in(in)
    );

    task check_out_is(input real expct, input real tol=1e-5);
        real out;

        out = filter_i.out();
        $display("At t=%0.1f ns, in=%0.5f and out=%0.5f.  Expecting %0.5f at the output...",
                 $realtime*1e9, in, out, expct);

        if (((expct-tol) <= out) && (out <= (expct+tol))) begin
            $display("OK.");
        end else begin
            $fatal("Check failed.");
        end
    endtask

    initial begin
        // setup
        $shm_open("filter.shm");
        $shm_probe("AS");

        // test 1: step response from t=0
        in=1.23;
        #(234ns);
        check_out_is(1.04647875745617);

        // test 2: intermediate value change
        in=3.45;
        #(45.6ns);
        in=-5.67;
        #(67.8ns);
        check_out_is(-1.37061245526685);

        // test 3: successive updates
        #(78.9ns);
        check_out_is(-3.40628070473501);
        #(89.1ns);
        check_out_is(-4.57295640296259);

        // end simulation
        $display("All tests passed.");
        $finish;
    end
endmodule
