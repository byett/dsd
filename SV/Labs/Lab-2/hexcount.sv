// hexcount.sv

module hexcount (
    input  logic       clk_100MHz,
    output logic [7:0] anode,
    output logic [6:0] seg
);

    // Connects the counter output to the display logic.
    // Holds the four hexadecimal digits to be displayed.
    logic [15:0] S;

    // Multiplexing selector indicating which digit is currently active.
    logic [1:0] dig;

    // The 4-bits currently being sent to the LED decoder.
    logic [3:0] display;

    // Counter instance
    counter C1 (
        .clk   (clk_100MHz),
        .count (S),
        .mpx   (dig)
    );

    // Seven-segment/Eight-anode LED decoder instance
    leddec L1 (
        .dig   (dig),
        .data  (display),
        .anode (anode),
        .seg   (seg)
    );

    // Multiplexer:
    // Select one of the four hexadecimal digits from the 16-bit counter
    // value based on the current multiplexing state.
    always_comb begin
        unique case (dig)
            2'b00: display = S[ 3: 0];
            2'b01: display = S[ 7: 4];
            2'b10: display = S[11: 8];
            default:
                   display = S[15:12];
        endcase
    end

endmodule