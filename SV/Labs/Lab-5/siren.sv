module siren (
    input  logic clk_50MHz,   // system clock (50 MHz)

    output logic dac_MCLK,    // outputs to PMODI2L DAC
    output logic dac_LRCK,
    output logic dac_SCLK,
    output logic dac_SDIN
);

    localparam logic [13:0] lo_tone    = 14'd344; // lower limit of siren = 256 Hz
    localparam logic [13:0] hi_tone    = 14'd687; // upper limit of siren = 512 Hz
    localparam logic [7:0]  wail_speed = 8'd8;    // sets wailing speed

    logic [19:0] tcount = '0;          // timing counter

    logic signed [15:0] data_L;        // 16-bit signed audio data
    logic signed [15:0] data_R;

    logic dac_load_L;                  // timing pulses to load DAC shift reg.
    logic dac_load_R;

    logic slo_clk;
    logic sclk;
    logic audio_CLK;

    //------------------------------------------------------------------
    // this process sets up a 20 bit binary counter clocked at 50MHz.
    // This is used to generate all necessary timing signals.
    // dac_load_L and dac_load_R are pulses sent to dac_if to load
    // parallel data into shift register for serial clocking out to DAC
    //------------------------------------------------------------------
    always_ff @(posedge clk_50MHz) begin

        if ((tcount[9:0] >= 10'h00F) &&
            (tcount[9:0] <  10'h02E))
        begin
            dac_load_L <= 1'b1;
        end
        else begin
            dac_load_L <= 1'b0;
        end

        if ((tcount[9:0] >= 10'h20F) &&
            (tcount[9:0] <  10'h22E))
        begin
            dac_load_R <= 1'b1;
        end
        else begin
            dac_load_R <= 1'b0;
        end

        tcount <= tcount + 20'd1;

    end

    assign dac_MCLK  = ~tcount[1];  // DAC master clock (12.5 MHz)

    assign audio_CLK =  tcount[9];  // audio sampling rate (48.8 kHz)

    assign dac_LRCK  = audio_CLK;   // also sent to DAC as left/right clock

    assign sclk      =  tcount[4];  // serial data clock (1.56 MHz)
    assign dac_SCLK  = sclk;        // also sent to DAC as SCLK

    assign slo_clk   =  tcount[19]; // clock to control wailing of tone (47.6 Hz)

    //------------------------------------------------------------------
    // instantiate parallel to serial DAC interface
    //------------------------------------------------------------------
    dac_if dac (
        .SCLK   (sclk),
        .L_start(dac_load_L),
        .R_start(dac_load_R),
        .L_data (data_L),
        .R_data (data_R),
        .SDATA  (dac_SDIN)
    );

    //------------------------------------------------------------------
    // instantiate wailing siren
    //------------------------------------------------------------------
    wail w1 (
        .lo_pitch  (lo_tone),
        .hi_pitch  (hi_tone),
        .wspeed    (wail_speed),
        .wclk      (slo_clk),
        .audio_clk (audio_CLK),
        .audio_data(data_L)
    );

    // duplicate data on right channel
    assign data_R = data_L;

endmodule