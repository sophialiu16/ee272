// NO NEED TO MODIFY THIS FILE

`timescale 1s/1fs

module freq_div #(
    parameter integer N=30
) (
    input wire logic in,
    output var logic out=1'b0
);
    integer count=0;
    always @(posedge in) begin
        if (count==(N/2)-1) begin
            out <= ~out;
            count <= 0;
        end else begin
            out <= out;
            count <= count+1;
        end
    end
endmodule
