// Modified based on example from Greg Stitt, University of Florida

`timescale 1 ns / 100 ps

// Module: mealy_tb
// Description: Testbench for the mealy module, which implements a Mealy FSM.

module mealy_tb #(
    parameter int NUM_CYCLES = 1000
);

    logic clk = 0, rst, X, Z;
    logic [2:0] seq;
    logic [3:0] correct_seq = 4'b1101;
    mealy1101 DUT (.*);

    initial begin : generate_clock
        forever #10 clk = ~clk;
    end

    logic correct_out;

    initial begin
        $timeformat(-9, 0, " ns");

        rst <= 1'b1;
        seq <= 3'b000;
        X <= 1'b0;
        correct_out <= 1'b0;
        repeat (5) @(posedge clk);

        rst <= 1'b0;
//This is different than our Moore testbench!
//Mealy machines react immediately to produce new outputs after receiving new inputs,
//without waiting for the clock rising edge.
        for (int i = 0; i < NUM_CYCLES; i++) begin
            X = $urandom;
            if ({seq,X}==correct_seq) correct_out = 1'b1;
            else correct_out = 1'b0;
            seq = {seq[1:0],X};
            @(posedge clk);
        end

        disable generate_clock;
        $display("Tests completed.");
    end
endmodule
