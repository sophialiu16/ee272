// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

class pi_ctrl;
    real ki, kp, integ;
    real last_t=0;

    function new(real ki, real kp, real init);
        this.ki = ki;
        this.kp = kp;
        this.integ = init;
    endfunction

    task update(input real err, output real out);
        // calculate change in time
        real dt;
        dt = $realtime - last_t;
        last_t = $realtime;

        // update integral
        integ = integ + ki*err*dt;

        // compute output
        out = kp*err + integ;
    endtask
endclass
