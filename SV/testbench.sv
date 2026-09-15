`timescale 1ns / 1ps

module testbench(
    );

    logic clk = 1'b0;
    //as long as we have the same names here and in "mydesign",
    //we can use this (.*) as a shortcut for the port mapping
    //otherwise we need to actually declare everything as before
    mydesign DUT (.*);

    initial begin : generate_clock
        forever #10 clk = ~clk;
    end
    
    initial begin : inputs
        $timeformat(-9, 0, " ns");
// In here, we'd create a sequence of changes to our inputs to test our system
// This is the main point of the testbench!
// We could test different inputs to a sequence of gates, different patterns of inputs for a finite state machine, etc.
        
// A good example of how to wait until the rising edge of the clock to do something        
        @(posedge clk);
// Not strictly necessary like in VHDL, but a good ending point regardless
        disable generate_clock;
        $display("Tests completed.");
    end
endmodule