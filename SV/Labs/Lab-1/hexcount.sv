module hexcount (
    input  logic       clk_100MHz,
    output logic [7:0] anode,
    output logic [6:0] seg
);

    logic [3:0] S;

    // Counter instance
    counter C1 (
        .clk   (clk_100MHz),
        .count (S)
    );

    // 7-segment decoder instance
    leddec L1 (
        .dig   (3'b000),
        .data  (S),
        .anode (anode),
        .seg   (seg)
    );

endmodule