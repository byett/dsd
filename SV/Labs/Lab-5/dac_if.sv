module dac_if (
    input  logic               SCLK,      // serial clock (1.56 MHz)
    input  logic               L_start,   // strobe to load LEFT data
    input  logic               R_start,   // strobe to load RIGHT data

    input  logic signed [15:0] L_data,    // LEFT data (15-bit signed)
    input  logic signed [15:0] R_data,    // RIGHT data (15-bit signed)

    output logic               SDATA      // serial data stream to DAC
);

    logic [15:0] sreg;                    // 16-bit shift register to do parallel to serial conversion

    //------------------------------------------------------------------
    // SREG is used to serially shift data out to DAC, MSBit first.
    // Left data is loaded into SREG on falling edge of SCLK when L_start is active.
    // Right data is loaded into SREG on falling edge of SCLK when R_start is active.
    // At other times, falling edge of SCLK causes SREG to logically shift one bit left.
    //------------------------------------------------------------------
        
    always_ff @(negedge SCLK) begin
        if (L_start)
            sreg <= L_data; // load LEFT data into SREG
        else if (R_start)
            sreg <= R_data; // load RIGHT data into SREG
        else
            sreg <= {sreg[14:0], 1'b0}; // logically shift SREG one bit left
    end

    // Serial data to DAC is MSBit of SREG
    assign SDATA = sreg[15];

endmodule