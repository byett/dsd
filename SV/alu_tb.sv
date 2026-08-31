// Modified based on example from Greg Stitt, University of Florida

`timescale 1 ns / 100 ps

// Module: alu_tb
// Description: Testbench for alu module.

module alu_tb #(
    parameter int NUM_TESTS = 10000,
    parameter int WIDTH = 8
);
    logic signed [WIDTH-1:0] in0, in1, out;
    logic signed [WIDTH:0] correct_result, result;
    logic [1:0] sel;
    logic neg, zero, carry, over, correct_C, correct_V, old_C, old_V;

    alu #(.WIDTH(WIDTH)) DUT (.*);

    // Function to check the status flags
    function void update_flags();
        old_C = correct_C;
        old_V = correct_V;
        if (sel[1] == 1'b0) begin
            correct_C  = correct_result[WIDTH];
        end else begin
            correct_C = old_C;
        end
        
        if ((sel == 2'b00 & in0[WIDTH-1] == in1[WIDTH-1] & in0[WIDTH-1] != correct_result[WIDTH-1]) | (sel == 2'b01 & in0[WIDTH-1] != in1[WIDTH-1] & in0[WIDTH-1] != correct_result[WIDTH-1])) begin
            correct_V  = 1'b1;
        end else if (sel[1] == 1'b0) begin
            correct_V = 1'b0;
        end else begin
            correct_V = old_V;
        end
    endfunction
    
    function void error_check();
        // Check negative flag.
        if (correct_result[WIDTH-1] != neg)
            $display("ERROR (time %0t): neg = %b instead of %b.", $realtime, neg, correct_result[WIDTH-1]);

        // Check zero flag.
        if ((correct_result[WIDTH-1:0] == 0) != zero)
            $display("ERROR (time %0t): zero = %b instead of %b.", $realtime, zero, correct_result[WIDTH-1:0] == 0);

        // Check carry flag.
        if (correct_C != carry)
            $display("ERROR (time %0t): C = %b instead of %b.", $realtime, carry, correct_C);
        
        // Check overflow flag.
        if (correct_V != over)
            $display("ERROR (time %0t): V = %b instead of %b.", $realtime, over, correct_V);
            
        if (out != correct_result[WIDTH-1:0])
            $display("ERROR (time %0t): out = %h instead of %h.", $realtime, out, correct_result[WIDTH-1:0]);
    endfunction
        
    initial begin
        $timeformat(-9, 0, " ns");

        // Test NUM_TESTS random inputs and select values.
        for (int i = 0; i < NUM_TESTS; i++) begin
            in0 = $urandom;
            in1 = $urandom;
            sel = $urandom;
            if (sel == 2'b00) correct_result = in0 + in1;
            else if (sel == 2'b01) correct_result = in0 - in1;
            else if (sel == 2'b10) correct_result = in0 & in1;
            else if (sel == 2'b11) correct_result = in0 | in1;

            update_flags();
            #10;
            error_check();
        end

        $display("Tests completed.");
    end
endmodule
