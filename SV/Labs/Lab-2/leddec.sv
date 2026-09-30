// leddec.sv

module leddec (
    input  logic [1:0] dig,
    input  logic [3:0] data,
    output logic [7:0] anode,
    output logic [6:0] seg
);

    // Seven-segment decoder:
    // Convert a 4-bit hexadecimal value into the corresponding
    // seven-segment pattern (active-low segments).
    // These patterns define the shapes for 0-F and generally
    // should not be modified unless the display wiring changes.
    always_comb begin
        unique case (data)
            4'h0: seg = 7'b0000001; // 0
            4'h1: seg = 7'b1001111; // 1
            4'h2: seg = 7'b0010010; // 2
            4'h3: seg = 7'b0000110; // 3
            4'h4: seg = 7'b1001100; // 4
            4'h5: seg = 7'b0100100; // 5
            4'h6: seg = 7'b0100000; // 6
            4'h7: seg = 7'b0001111; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0000100; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b1100000; // b
            4'hC: seg = 7'b0110001; // C
            4'hD: seg = 7'b1000010; // d
            4'hE: seg = 7'b0110000; // E
            4'hF: seg = 7'b0111000; // F
            default:
                seg = 7'b1111111;   // All segments off
        endcase
    end

    // Digit-select decoder:
    // Enable one of the four seven-segment displays based on the
    // multiplexing selector 'dig'.
    //
    // The display uses active-low anodes:
    // a '0' bit turns the corresponding digit ON,
    // a '1' bit turns the corresponding digit OFF.
    //
    // Only four of the eight available digits are currently used.
    // The commented patterns below show how the remaining four
    // digits could be enabled if the design were expanded.
    always_comb begin
        unique case (dig)
            2'b00: anode = 8'b11111110; // Digit 0
            2'b01: anode = 8'b11111101; // Digit 1
            2'b10: anode = 8'b11111011; // Digit 2
            2'b11: anode = 8'b11110111; // Digit 3
            default:
                anode = 8'b11111111;    // All digits off
        endcase
    end

    // Additional active-low anode patterns that could be used
    // for an 8-digit display:
    //
    // Digit 4: 8'b11101111
    // Digit 5: 8'b11011111
    // Digit 6: 8'b10111111
    // Digit 7: 8'b01111111

endmodule