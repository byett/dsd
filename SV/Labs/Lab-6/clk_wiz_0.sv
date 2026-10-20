//------------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//------------------------------------------------------------------------------
// CLK_OUT1___108.000______0.000______50.0______127.691_____97.646
//
//------------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//------------------------------------------------------------------------------
// __primary_________100.000____________0.010
//------------------------------------------------------------------------------

module clk_wiz_0 (
    // Clock in ports
    input  logic clk_in1,

    // Clock out ports
    output logic clk_out1
);

    clk_wiz_0_clk_wiz U0 (

        // Clock in ports
        .clk_in1 (clk_in1),

        // Clock out ports
        .clk_out1(clk_out1)

    );

endmodule