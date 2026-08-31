// Greg Stitt
// University of Florida

`timescale 1 ns / 100 ps

module ripple_carry_adder_tb;

    localparam int NUM_TESTS = 1000;
    localparam int WIDTH = 8;
    logic [WIDTH-1:0] A, B, S, correct_sum;
    logic Cin, Co, correct_Co;

    ripple_carry_adder UUT (.*);

    initial begin
        $timeformat(-9, 0, " ns");

        for (int i = 0; i < NUM_TESTS; i++) begin
            A   = $urandom;
            B   = $urandom;
            Cin = $urandom;
            {correct_Co, correct_sum} = A + B + Cin;
            #10;
            if (S != correct_sum)
                $display("ERROR (time %0t): sum = %d instead of %d.", $realtime, S, correct_sum);

            if (Co != correct_Co)
                $display("ERROR (time %0t): cout = %b instead of %b.", $realtime, Co, correct_Co);
        end

        $display("Tests completed.");
    end

endmodule  // ripple_carry_adder_tb
