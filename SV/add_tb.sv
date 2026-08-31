// Modified based on example from Greg Stitt, University of Florida
// Description: This file provides testbenches for the modules in add.sv.

`timescale 1 ns / 10 ps

// Module: half_add_tb
// Description: Use this testbench to test the add module from add.sv.

module half_add_tb ();
    logic A,B,Co,S;
    logic [1:0] CarrySum;
    single_bit_half_adder DUT (.*);

    initial begin
        $timeformat(-9, 0, " ns");
        // Index into the loop counter bits to assign individual inputs.
        for (int i = 0; i < 4; i++) begin
            A = i[1];
            B = i[0];
            CarrySum = A+B;
            #10;
            if (CarrySum[0] != S) $error("[%0t] sum = %d instead of %d.", $realtime, S, CarrySum[0]);
            if (CarrySum[1] != Co) $error("[%0t] carry = %d instead of %d.", $realtime, Co, CarrySum[1]);
        end

        $display("Tests completed.");
    end
endmodule  // half_add_tb

module full_add_tb ();
    logic A,B,Co,S,Cin;
    logic [1:0] CarrySum;
    single_bit_full_adder DUT (.*);

    initial begin
        $timeformat(-9, 0, " ns");
        // Index into the loop counter bits to assign individual inputs.
        for (int i = 0; i < 8; i++) begin
            Cin = i[2];
            A = i[1];
            B = i[0];
            CarrySum = A+B+Cin;
            #10;
            if (CarrySum[0] != S) $error("[%0t] sum = %d instead of %d.", $realtime, S, CarrySum[0]);
            if (CarrySum[1] != Co) $error("[%0t] carry = %d instead of %d.", $realtime, Co, CarrySum[1]);
        end

        $display("Tests completed.");
    end
endmodule  // full_add_tb

// Module: add_tb
// Description: Use this testbench to test the add module from add.sv.

module add_tb #(
    parameter int WIDTH = 16,
    parameter int NUM_TESTS = 1000
);
    logic [WIDTH-1:0] in0, in1;
    logic [WIDTH-1:0] sum;

    add #(.WIDTH(WIDTH)) DUT (.*);

    initial begin
        $timeformat(-9, 0, " ns");

        for (int i = 0; i < NUM_TESTS; i++) begin
            in0 = $urandom;
            in1 = $urandom;
            #10;
            if (sum != in0 + in1) $error("[%0t] sum = %d instead of %d.", $realtime, sum, in0 + in1);
        end

        $display("Tests completed.");
    end
endmodule  // add_tb


// Module: add_carry_out_tb
// Description: Use this testbench to test the add_carry_out modules from 
// add.sv. There are three versions that can be tested by uncommenting the 
// corresponding DUT code below.

module add_carry_out_tb #(
    parameter int WIDTH = 16,
    parameter int NUM_TESTS = 1000
);
    logic [WIDTH-1:0] in0, in1;
    logic [WIDTH-1:0] sum;
    logic       carry_out;

    // Replace DUT with version you would like to test.
    //add_carry_out_bad #(.WIDTH(WIDTH)) DUT (.*);
    //add_carry_out1 #(.WIDTH(WIDTH)) DUT (.*);
    add_carry_out2 #(.WIDTH(WIDTH)) DUT (.*);
    logic [WIDTH-1:0] correct_sum;
    logic correct_carry_out;
    initial begin
        $timeformat(-9, 0, " ns");

        for (int i = 0; i < NUM_TESTS; i++) begin
            in0 = $urandom;
            in1 = $urandom;
             #10;
            // This works, but breaks my formatter. It works because {} generates a 
            // vector that can be sliced.
            // correct_carry_out = {{1'b0, in0} + in1}[WIDTH];
            {correct_carry_out, correct_sum} = in0 + in1;

            if (sum != correct_sum) begin
                $error("[%0t] sum = %d instead of %d.", $realtime, sum, correct_sum);
            end

            if (carry_out != correct_carry_out) begin
                $error("[%0t] carry_out = %d instead of %d.", $realtime, carry_out, correct_carry_out);
            end
           
        end

        $display("Tests completed.");
    end

endmodule  // add_carry_out_tb


// Module: add_carry_inout_tb
// Description: Use this testbench to test the add_carry_inout module in add.sv.

module add_carry_inout_tb #(
    parameter int WIDTH = 16,
    parameter int NUM_TESTS = 1000
);

    logic [WIDTH-1:0] in0, in1;
    logic [WIDTH-1:0] sum;
    logic carry_out, carry_in;

    add_carry_inout #(.WIDTH(WIDTH)) DUT (.*);
    logic [WIDTH-1:0] correct_sum;
    logic correct_carry_out;
    initial begin
        $timeformat(-9, 0, " ns");

        for (int i = 0; i < NUM_TESTS; i++) begin
            in0 = $urandom;
            in1 = $urandom;
            carry_in = $urandom;
            {correct_carry_out, correct_sum} = in0 + in1 + carry_in;
            // Works, but breaks formatter:
            // correct_carry_out = {{1'b0, in0} + in1 + carry_in}[WIDTH];
            #10;
            if (sum != in0 + in1 + carry_in)
                $error("[%0t] sum = %d instead of %d.", $realtime, sum, correct_sum);

            if (carry_out != correct_carry_out)
                $error("[%0t] carry_out = %d instead of %d.", $realtime, carry_out, correct_carry_out);
            
        end
         

        $display("Tests completed.");
    end

endmodule  // add_carry_inout_tb


// Module: add_carry_inout_overflow_tb
// Description: Use this testbench to test the add_carry_inout_overflow module 
// in add.sv.

module add_carry_inout_overflow_tb #(
    parameter int WIDTH = 16,
    parameter int NUM_TESTS = 1000
);
    logic [WIDTH-1:0] in0, in1;
    logic [WIDTH-1:0] sum;
    logic carry_out, carry_in, overflow;
    logic [WIDTH-1:0] correct_sum;
    logic     correct_carry_out;
    logic     correct_overflow;
    add_carry_inout_overflow #(.WIDTH(WIDTH)) DUT (.*);

    initial begin
        $timeformat(-9, 0, " ns");

        for (int i = 0; i < NUM_TESTS; i++) begin
            in0 = $urandom;
            in1 = $urandom;
            carry_in = $urandom;
            {correct_carry_out, correct_sum} = in0 + in1 + carry_in;
            //correct_carry_out = {{1'b0, in0} + in1 + carry_in}[WIDTH];
            correct_overflow = (in0[WIDTH-1] == in1[WIDTH-1]) && (correct_carry_out != in0[WIDTH-1]);
            #10;
            if (sum != in0 + in1 + carry_in)
                $error("[%0t] sum = %d instead of %d.", $realtime, sum, correct_sum);

            if (carry_out != correct_carry_out)
                $error("[%0t] carry_out = %d instead of %d.", $realtime, carry_out, correct_carry_out);

            if (overflow != correct_overflow)
                $error("[%0t] overflow = %d instead of %d.", $realtime, overflow, correct_overflow);
            
        end

        $display("Tests completed.");
    end

endmodule

module final_tb #(
    parameter int WIDTH = 16,
    parameter int NUM_TESTS = 1000
);
//If your testbench does not output values you want after simulation (and you are using Vivado; haven't tested elsewhere),
//copy/paste this into your Tcl Console, save the wcfg file when prompted, then re-run simulation:
//add_wave -recursive /final_tb/tb/*
//You will likely need to repeat this for each test
    //half_add_tb  tb();
    full_add_tb  tb();
//    add_tb #(
//        .WIDTH(WIDTH),
//        .NUM_TESTS(NUM_TESTS)
//    ) tb();

    //add_carry_out_tb #(
    //    .WIDTH(WIDTH),
    //    .NUM_TESTS(NUM_TESTS)
    //) tb();

    //add_carry_inout_tb #(
    //    .WIDTH(WIDTH),
    //    .NUM_TESTS(NUM_TESTS)
    //) tb();

//    add_carry_inout_overflow_tb #(
//        .WIDTH(WIDTH),
//        .NUM_TESTS(NUM_TESTS)
//    ) tb();

endmodule
