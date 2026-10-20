// Generates a "wailing siren" sound by instancing a "tone" module and
// modulating the pitch of the tone. The pitch is increased until it
// reaches hi_pitch and then decreased until it reaches lo_pitch and
// then increased again, etc.

module wail (
    input  logic [13:0] lo_pitch,    // lowest pitch (in units of 0.745 Hz)
    input  logic [13:0] hi_pitch,    // highest pitch (in units of 0.745 Hz)

    input  logic [7:0]  wspeed,      // speed of wail in pitch units/wclk

    input  logic        wclk,        // wailing clock (47.6 Hz)
    input  logic        audio_clk,   // audio sampling clock (48.8 kHz)

    output logic signed [15:0] audio_data   // output audio sequence (wailing tone)
);

    logic [13:0] curr_pitch;         // current wailing pitch

    //------------------------------------------------------------------
    // This modulates the current pitch. It uses a variable called
    // updn to indicate whether tone is currently rising or falling.
    // Each wclk period it increments (or decrements) the current
    // pitch by wspeed.f When it reaches hi_pitch, it starts counting
    // down. When it reaches lo_pitch, it starts counting up.
    //------------------------------------------------------------------
    always_ff @(posedge wclk) begin
        static logic updn;
        
        if (curr_pitch >= hi_pitch) updn = 1'b0; // check to see if still in range
        else if (curr_pitch <= lo_pitch) updn = 1'b1; // if not, adjust updn
        
        //modulate pitch according to current value of updn
        
        if (updn) curr_pitch <= curr_pitch + wspeed;
        else curr_pitch <= curr_pitch - wspeed;
    end

    //------------------------------------------------------------------
    // instance a tone module
    //------------------------------------------------------------------
    tone tgen (
        .clk   (audio_clk),
        .pitch (curr_pitch), // use curr_pitch to modulate tone
        .data  (audio_data)
    );

endmodule