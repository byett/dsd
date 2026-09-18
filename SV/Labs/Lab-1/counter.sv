module counter (
    input  logic       clk,
    output logic [3:0] count
);

    logic [28:0] cnt;  // 29-bit counter

    // Increment counter on rising edge of clock
    always_ff @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    // Output the upper 4 bits
    assign count = cnt[28:25];

endmodule