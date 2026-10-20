module leddec16 (
    input  logic [2:0]  dig,    // which digit to currently display
    input  logic [15:0] data,   // 16-bit (4-digit) data

    output logic [7:0]  anode,  // which anode to turn on
    output logic [6:0]  seg     // segment code for current digit
);

    logic [3:0] data4;          // binary value of current digit

    //------------------------------------------------------------------
    // Select digit data to be displayed in this mpx period
    //------------------------------------------------------------------
    always_comb begin
        case (dig)
            3'b000: data4 = data[3:0];     // digit 0
            3'b001: data4 = data[7:4];     // digit 1
            3'b010: data4 = data[11:8];    // digit 2
            default: data4 = data[15:12];  // digit 3
        endcase
    end

    //------------------------------------------------------------------
    // Turn on segments corresponding to 4-bit data word
    //------------------------------------------------------------------
    always_comb begin
        case (data4)
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
            4'hB: seg = 7'b1100000; // B
            4'hC: seg = 7'b0110001; // C
            4'hD: seg = 7'b1000010; // D
            4'hE: seg = 7'b0110000; // E
            4'hF: seg = 7'b0111000; // F
            default: seg = 7'b1111111;
        endcase
    end

    //------------------------------------------------------------------
    // Turn on anode of 7-segment display addressed by
    // 3-bit digit selector dig
    //------------------------------------------------------------------
    always_comb begin
        case (dig)
            3'b000: anode = 8'b11111110; // 0
            3'b001: anode = 8'b11111101; // 1
            3'b010: anode = 8'b11111011; // 2
            3'b011: anode = 8'b11110111; // 3

//          3'b100: anode = 8'b11101111; // 4
//          3'b101: anode = 8'b11011111; // 5
//          3'b110: anode = 8'b10111111; // 6
//          3'b111: anode = 8'b01111111; // 7

            default: anode = 8'b11111111;
        endcase
    end

endmodule