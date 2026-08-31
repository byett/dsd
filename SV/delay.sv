// Modified based on example from Greg Stitt, University of Florida
//
// This file illustrates how to implement a delay module structurally
// as a sequence of registers. It introduces the unpacked array construct.
// We are also setting the stage for sequential logic ideas to come after.


// Module: register
// Description: Basic register.

module register #(
    parameter int WIDTH
) (
    input  logic             clk,
    //Leaving these here but rst and en are only needed for the enabled flip-flop/register (see below)
    input  logic             rst,
    input  logic             en,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    //Most basic D flip-flop/register
    // posedge tells us to look for the rising edge of the clock only
    // This is the only time a flip-flop should update - do nothing otherwise
    //Comment this version out if you bring in the more advanced version!
    always_ff @(posedge clk) begin
        out <= in;
    end
    //This version is an enabled flip-flop/register (only changes the output when the EN aka enable signal is high)
    //It is also active high resetable (when the reset signal is high, we "reset" the output to 0)
//    always_ff @(posedge clk or posedge rst) begin
//        if (rst) out <= '0;
//        else if (en) out <= in;
//    end

endmodule  // register


// Module: delay
// Description: This module delays a provided WIDTH-bit input by CYCLES cycles.
//
// See delay.pdf for an illustration of the schematic.

module delay #(
    //Default values for CYCLES to delay and WIDTH of our data in terms of bits
    //But these can be overriden by our testbench still
    parameter int CYCLES = 4,
    parameter int WIDTH  = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             en,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
    // Ideally, every module would validate its parameters because often
    // certain values are undefined. For example, a negative cycles delay
    // doesn't make sense. Similarly, only positive widths make sense.
    // Unfortunately, parameter validation is somewhat lacking in SystemVerilog. 
    // Some of the possibilities are shown below.

    // A preferred method of parameter validation is the following, which seems
    // to be supported by most tools. Try this first before resorting to the following alternatives.
    initial begin
        if (CYCLES < 0) $fatal(1, "ERROR: Cycles must be >= 0.");
        if (WIDTH < 1) $fatal(1, "ERROR: Width must be positive.");
    end

    // Assertions seem like a natural choice for validation, but some simulators ignore
    // these:
    /*
    always_comb assert(CYCLES >= 0);
    assert property (@(posedge clk) CYCLES >= 0);
    */

    // Alternatively, we can use if generates for validation.
    if (CYCLES < 0) begin
        // One workaround to missing validation constructs is to simply call
        // an undefined module with a name that specifies the error.
        cycles_parameter_must_be_ge_0();

        // The SV standard defines the $error function, which prints during
        // compilation. However, not every tool supports it.
        //
        //$error("ERROR: CYCLES parameter must be >= 0.");

        // $fatal does cause some synthesis tools to terminate, but is not 
        // supported by every option.
        //
        //$fatal(1, "ERROR: CYCLES parameter must be >= 0.");
    end
    if (WIDTH < 1) begin
        width_parameter_must_be_gt_0();
        //$error("ERROR: WIDTH parameter must be >= 1.");
        //$fatal(1, "ERROR: WIDTH parameter must be >= 1.");      
    end

    // Create an array of WIDTH-bit signals, which will connect all the registers
    // together (see delay.pdf). The array uses CYCLES+1 elements because there
    // are CYCLES register outputs, plus the input to the first register.
    //
    // When creating an array this way, the CYCLES+1 section creates an unpacked
    // array. The [WIDTH-1:0] section creates a packed array. Packed arrays and
    // unpacked arrays support different operations, but generally you will use
    // the packed section to specify bits, and the unpacked section to specify
    // the total number of elements.
    //
    // The CYCLES+1 notation is short for [0:CYCLES+1-1]. A common convention is
    // to use "downto" syntax for the packed array, and "to" syntax for the
    // unpacked array. Most people are used to thinking of arrays starting at 
    // index 0, and the MSB starting at the highest number.
    //
    // VHDL COMPARISON: packed arrays are missing from VHDL, where you instead 
    // have to create a custom array type. In SV, every signal can become an
    // unpacked array simply by adding [], which is very convenient.
    logic [WIDTH-1:0] regs[CYCLES+1];

    if (CYCLES == 0) begin : cycles_eq_0
        // For CYCLES == 0, there is no delay, so just use a wire.
        assign out = in;
    end else if (CYCLES > 0) begin : cycles_gt_0
        // Create a sequence of CYCLES registers, where each register adds one
        // cycle to the delay.

        // NOTE: Old versions of SV and some tools require the 
        // genvar to be declared outside the loop. 
        for (genvar i = 0; i < CYCLES; i++) begin : reg_array
            register #(
                .WIDTH(WIDTH)
            ) reg_array (
                // If signals share the same name as the I/O, the parentheses can
                // be ommitted. But it can be very error prone when you change the name
                // of either the I/O or the signal.
                .clk,
                .rst,
                .en,
                .in (regs[i]),
                .out(regs[i+1])
            );
        end

        // The first register's input comes from the delay's input.
        assign regs[0] = in;

        // The last register's output goes to the delay's output.
        assign out = regs[CYCLES];
    end
endmodule

