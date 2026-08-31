// Modified based on example from Greg Stitt, University of Florida

`timescale 1 ns / 100 ps

// Module: moore_tb
// Description: Testbench for the moore module, which implements a Moore FSM.
// Note that if moore is changed to use the 1-process version, this testbench
// will start to report errors because of the 1-cycle delay for the outputs.
// It is left as an exercise to adapt the testbench to work for both models.

module moore_tb #(
    parameter int NUM_CYCLES = 1000
);

    logic clk = 0, rst, X, Z;
    logic [2:0] seq;
    logic [3:0] correct_seq = 4'b1101;
    moore1101 DUT (.*);

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

        for (int i = 0; i < NUM_CYCLES; i++) begin
            X <= $urandom;
            @(posedge clk);
            if ({seq,X}==correct_seq) correct_out <= 1'b1;
            else correct_out <= 1'b0;
            seq <= {seq[1:0],X};
        end

        disable generate_clock;
        $display("Tests completed.");
    end
endmodule
