module leddec (
    input  logic [2:0] dig,
    input  logic [3:0] data,
    output logic [7:0] anode,
    output logic [6:0] seg
);

    // Turn on segments corresponding to 4-bit data word.
    // Setting a particular segment of seg to 0 is what turns ON that segment
    // So when data equals 0, we turn on most segments to show a 0
    // When no data is present, we set all segments to 1 to turn it off entirely
    always_comb begin
        case (data)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            4'h2: seg = 7'b0010010;
            4'h3: seg = 7'b0000110;
            4'h4: seg = 7'b1001100;
            4'h5: seg = 7'b0100100;
            4'h6: seg = 7'b0100000;
            4'h7: seg = 7'b0001111;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0000100;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b1100000;
            4'hC: seg = 7'b0110001;
            4'hD: seg = 7'b1000010;
            4'hE: seg = 7'b0110000;
            4'hF: seg = 7'b0111000;
            default: seg = 7'b1111111;
        endcase
    end

    // Turn on anode of 7-segment display addressed by 3-bit digit selector dig
    // A 0 corresponds to turning on that particular anode
    // We should never really have multiple anodes on at the same time
    always_comb begin
        case (dig)
            3'b000: anode = 8'b11111110;
            3'b001: anode = 8'b11111101;
            3'b010: anode = 8'b11111011;
            3'b011: anode = 8'b11110111;
            3'b100: anode = 8'b11101111;
            3'b101: anode = 8'b11011111;
            3'b110: anode = 8'b10111111;
            3'b111: anode = 8'b01111111;
            default: anode = 8'b11111111;
        endcase
    end

endmodule