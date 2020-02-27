`timescale 1s/1fs

module ringosc (
    input real vdd,
    output var logic out
);
    // YOUR IMPLEMENTATION HERE
    real freq;
    real period; 
    logic temp;
    
    initial 
    begin 
    temp = 0; 
    end 

    always_comb begin
        freq = 6.6 * 10 **9 * vdd - 1.3 * 10 **9;
	if (freq < 1.6 * 10 **9) begin 
    		freq = 1.6 * 10 **9;
    	end else if (freq > 4.0 * 10 **9) begin
        	freq = 4.00 * 10 **9;
    	end
    end
    assign period = 1/freq;
    
    always 
    	#(period/2) temp = ~temp;
    
    assign out = temp;
endmodule

