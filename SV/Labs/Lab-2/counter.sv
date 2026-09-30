// counter.sv

module counter (
    input  logic        clk,
    output logic [15:0] count,
    output logic [1:0]  mpx
);

    logic [38:0] cnt;   // 39-bit counter

    // Increment counter on rising edge of clock
    always_ff @(posedge clk) begin
        cnt <= cnt + 1'b1; 
    end

    // Continuous assignments
    assign count = cnt[38:23];   // 16 bits
    assign mpx   = cnt[18:17];   // 2 bits

endmodule