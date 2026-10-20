// Generates a 16-bit signed triangle wave sequence at a sampling rate
// determined by input clk and with a frequency of (clk * pitch) / 65,536

module tone (
    input  logic               clk,    // 48.8 kHz audio sampling clock
    input  logic [13:0]        pitch,  // frequency (in units of 0.745 Hz)

    output logic signed [15:0] data    // signed triangle wave out
);

    logic [15:0] count = '0;           // represents current phase of waveform

    logic [1:0] quad;                  // current quadrant of phase

    logic signed [15:0] index;         // index into current quadrant

    //------------------------------------------------------------------
    // This adds "pitch" to the current phase every sampling
    // period to generate an unsigned 16-bit sawtooth waveform.
    // Frequency is determined by pitch. For example when pitch=1,
    // then frequency will be 0.745 Hz. When pitch=16,384, frequency
    // will be 12.2 kHz.
    //------------------------------------------------------------------
    always_ff @(posedge clk) begin
        count <= count + pitch;
    end

    assign quad = count[15:14];  // splits count range into 4 phases

    assign index = $signed({2'b00, count[13:0]});  // 14-bit index into the current phase

    //------------------------------------------------------------------
    // This converts an unsigned 16-bit sawtooth that ranges from 0 to 65,535 
    // into a signed 12-bit triangle wave that ranges from -16,383 to +16,383
    //------------------------------------------------------------------
    always_comb begin
        case (quad)
            2'b00: data = index;                // 1st quadrant
            2'b01: data = 16'sd16383 - index;  // 2nd quadrant
            2'b10: data = -index;              // 3rd quadrant
            default:
                data = index - 16'sd16383;     // 4th quadrant
        endcase
    end

endmodule