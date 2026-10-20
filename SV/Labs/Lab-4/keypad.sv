module keypad (
    input  logic       samp_ck,    // clock to strobe columns

    output logic [4:1] col,        // output column lines
    input  logic [4:1] row,        // input row lines

    output logic [3:0] value,      // hex value of key depressed
    output logic       hit         // indicates when a key has been pressed
);

    logic [4:1] CV1 = 4'b1111;     // column vector of each row
    logic [4:1] CV2 = 4'b1111;
    logic [4:1] CV3 = 4'b1111;
    logic [4:1] CV4 = 4'b1111;

    logic [4:1] curr_col = 4'b1110; // current column code

    //------------------------------------------------------------------
    // This process synchronously tests the state of the keypad buttons.
    // On each edge of samp_ck, this module outputs a column code to the
    // keypad in which one column line is held low while the other three
    // column lines are held high. The row outputs of that column are then
    // read into the corresponding column vector. The current column is
    // then updated ready for the next clock edge. Remember that curr_col
    // is not updated until the process suspends.
    //------------------------------------------------------------------
    always_ff @(posedge samp_ck) begin
        case (curr_col)

            4'b1110: begin
                CV1      <= row;
                curr_col <= 4'b1101;
            end

            4'b1101: begin
                CV2      <= row;
                curr_col <= 4'b1011;
            end

            4'b1011: begin
                CV3      <= row;
                curr_col <= 4'b0111;
            end

            4'b0111: begin
                CV4      <= row;
                curr_col <= 4'b1110;
            end

            default: begin
                curr_col <= 4'b1110;
            end

        endcase
    end

    //------------------------------------------------------------------
    // This process runs whenever any of the column vectors change. Each
    // vector is tested to see if there are any '0's in the vector. This
    // would indicate that a button had been pushed in that column. If so,
    // the value of the button is output and the hit signal is asserted.
    // If no button is pushed, the hit signal is cleared.
    //------------------------------------------------------------------
    always_comb begin
        hit   = 1'b1;

        if (CV1[1] == 1'b0) value = 4'h1;
        else if (CV1[2] == 1'b0) value = 4'h4;
        else if (CV1[3] == 1'b0) value = 4'h7;
        else if (CV1[4] == 1'b0) value = 4'h0;
        else if (CV2[1] == 1'b0) value = 4'h2;
        else if (CV2[2] == 1'b0) value = 4'h5;
        else if (CV2[3] == 1'b0) value = 4'h8;
        else if (CV2[4] == 1'b0) value = 4'hF;
        else if (CV3[1] == 1'b0) value = 4'h3;
        else if (CV3[2] == 1'b0) value = 4'h6;
        else if (CV3[3] == 1'b0) value = 4'h9;
        else if (CV3[4] == 1'b0) value = 4'hE;
        else if (CV4[1] == 1'b0) value = 4'hA;
        else if (CV4[2] == 1'b0) value = 4'hB;
        else if (CV4[3] == 1'b0) value = 4'hC;
        else if (CV4[4] == 1'b0) value = 4'hD;
        else begin
            hit   = 1'b0;
            value = 4'h0;
        end
    end

    assign col = curr_col;

endmodule