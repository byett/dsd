module clk_wiz_0_clk_wiz (
    // Clock in ports
    input  logic clk_in1,

    // Clock out ports
    output logic clk_out1
);

    // Input clock buffering / unused connectors
    logic clk_in1_clk_wiz_0;

    // Output clock buffering / unused connectors
    logic clkfbout_clk_wiz_0;
    logic clkfbout_buf_clk_wiz_0;
    logic clkfboutb_unused;

    logic clk_out1_clk_wiz_0;

    logic clkout0b_unused;
    logic clkout1_unused;
    logic clkout1b_unused;
    logic clkout2_unused;
    logic clkout2b_unused;
    logic clkout3_unused;
    logic clkout3b_unused;
    logic clkout4_unused;
    logic clkout5_unused;
    logic clkout6_unused;

    // Dynamic programming unused signals
    logic [15:0] do_unused;
    logic        drdy_unused;

    // Dynamic phase shift unused signals
    logic psdone_unused;
    logic locked_int;

    // Unused status signals
    logic clkfbstopped_unused;
    logic clkinstopped_unused;

    //------------------------------------------------------------------
    // Input buffering
    //------------------------------------------------------------------

    assign clk_in1_clk_wiz_0 = clk_in1;

    //------------------------------------------------------------------
    // Clocking PRIMITIVE
    //------------------------------------------------------------------
    // Instantiation of the MMCM PRIMITIVE
    //    * Unused inputs are tied off
    //    * Unused outputs are labeled unused
    //------------------------------------------------------------------

    MMCME2_ADV #(
        .BANDWIDTH            ("OPTIMIZED"),
        .CLKOUT4_CASCADE      ("FALSE"),
        .COMPENSATION         ("ZHOLD"),
        .STARTUP_WAIT         ("FALSE"),

        .DIVCLK_DIVIDE        (1),

        .CLKFBOUT_MULT_F      (10.125),
        .CLKFBOUT_PHASE       (0.000),
        .CLKFBOUT_USE_FINE_PS ("FALSE"),

        .CLKOUT0_DIVIDE_F     (25.25),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKOUT0_USE_FINE_PS  ("FALSE"),

        .CLKIN1_PERIOD        (10.0),
        .REF_JITTER1          (0.010)
    ) mmcm_adv_inst (

        // Output clocks
        .CLKFBOUT      (clkfbout_clk_wiz_0),
        .CLKFBOUTB     (clkfboutb_unused),

        .CLKOUT0       (clk_out1_clk_wiz_0),
        .CLKOUT0B      (clkout0b_unused),

        .CLKOUT1       (clkout1_unused),
        .CLKOUT1B      (clkout1b_unused),

        .CLKOUT2       (clkout2_unused),
        .CLKOUT2B      (clkout2b_unused),

        .CLKOUT3       (clkout3_unused),
        .CLKOUT3B      (clkout3b_unused),

        .CLKOUT4       (clkout4_unused),
        .CLKOUT5       (clkout5_unused),
        .CLKOUT6       (clkout6_unused),

        // Input clock control
        .CLKFBIN       (clkfbout_buf_clk_wiz_0),
        .CLKIN1        (clk_in1_clk_wiz_0),
        .CLKIN2        (1'b0),

        // Tied to always select the primary input clock
        .CLKINSEL      (1'b1),

        // Ports for dynamic reconfiguration
        .DADDR         (7'b0),
        .DCLK          (1'b0),
        .DEN           (1'b0),
        .DI            (16'b0),
        .DO            (do_unused),
        .DRDY          (drdy_unused),
        .DWE           (1'b0),

        // Ports for dynamic phase shift
        .PSCLK         (1'b0),
        .PSEN          (1'b0),
        .PSINCDEC      (1'b0),
        .PSDONE        (psdone_unused),

        // Other control and status signals
        .LOCKED        (locked_int),
        .CLKINSTOPPED  (clkinstopped_unused),
        .CLKFBSTOPPED  (clkfbstopped_unused),
        .PWRDWN        (1'b0),
        .RST           (1'b0)
    );

    //------------------------------------------------------------------
    // Output buffering
    //------------------------------------------------------------------

    BUFG clkf_buf (
        .O (clkfbout_buf_clk_wiz_0),
        .I (clkfbout_clk_wiz_0)
    );

    BUFG clkout1_buf (
        .O (clk_out1),
        .I (clk_out1_clk_wiz_0)
    );

endmodule