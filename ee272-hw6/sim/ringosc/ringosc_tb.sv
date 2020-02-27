// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

module ringosc_tb;
    real vdd;
    logic out;
    ringosc ringosc_i (
        .vdd(vdd),
        .out(out)
    );

    real freq;
    meas_freq meas_freq_i (
        .clk(out),
        .freq(freq)
    );

    task check_freq_is(input real expct, input real tol=1e6);
        $display("At t=%0.1f ns, voltage=%0.3f and frequency=%0.5f GHz.  Expecting %0.5f GHz...", $realtime*1e9, vdd, freq/1e9, expct/1e9);
        if (((expct-tol) <= freq) && (freq <= (expct+tol))) begin
            $display("OK.");
        end else begin
            $fatal("Check failed.");
        end
    endtask

    integer fid;
    initial begin
        // setup
        $shm_open("ringosc.shm");
        $shm_probe("AS");

        // measure frequency vs vdd and write results to a file
        fid = $fopen("ringosc.csv", "w");
        $fwrite(fid, "VDD (V), Frequency (GHz)\n");
        for (vdd=0.0; vdd<1.001; vdd=vdd+10e-3) begin
            #(25ns);
            $fwrite(fid, "%0.10f,%0.10f\n", vdd, freq/1e9);
        end
        $fclose(fid);

        // spot-check at a few specific input voltages
        vdd = 0.0;
        #(25ns);
        check_freq_is(1.60e9);
        vdd = 0.1;
        #(25ns);
        check_freq_is(1.60e9);
        vdd = 0.2;
        #(25ns);
        check_freq_is(1.60e9);
        vdd = 0.3;
        #(25ns);
        check_freq_is(1.60e9);
        vdd = 0.4;
        #(25ns);
        check_freq_is(1.60e9);
        vdd = 0.5;
        #(25ns);
        check_freq_is(2.00e9);
        vdd = 0.6;
        #(25ns);
        check_freq_is(2.66e9);
        vdd = 0.7;
        #(25ns);
        check_freq_is(3.32e9);
        vdd = 0.8;
        #(25ns);
        check_freq_is(3.98e9);
        vdd = 0.9;
        #(25ns);
        check_freq_is(4.00e9);
        vdd = 1.0;
        #(25ns);
        check_freq_is(4.00e9);
    
        // end simulation
        $display("All tests passed.");
        $finish;
    end
endmodule
