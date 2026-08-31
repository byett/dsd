// Modified based on example from Greg Stitt, University of Florida

`timescale 1 ns / 100 ps

// Module: delay_tb
// Description: Testbench for the delay entity. This is a more complicated
// testbench that preserves the correct outputs in an array.

module delay_tb #(
    parameter int NUM_TESTS = 1000,
    parameter int CYCLES = 3,
    parameter int WIDTH = 8
  );

  logic       clk = 1'b0;
  //These are only needed for resetable enabled FF but don't hurt anything so they are left in
  //Same goes for the testing part down below
  logic       rst;
  logic       en;
  logic [WIDTH-1:0] in;
  logic [WIDTH-1:0] out;

  delay #(
          .CYCLES(CYCLES),
          .WIDTH (WIDTH)
        ) DUT (
          .*
        );
  //Basic clock initialization to consistently toggle between a high (1) and low (0) value
initial
begin : generate_clock
  forever
    #5 clk = ~clk;
end

initial
begin
  $timeformat(-9, 0, " ns");

  // Initialize the circuit.
  rst <= 1'b1;
  en  <= 1'b0;
  in  <= '0;
  repeat (5) @(posedge clk);

  rst <= 1'b0;

  // Genereate NUM_TESTS random tests.
  for (int i = 0; i < NUM_TESTS; i++)
  begin
    in <= $urandom;
    en <= $urandom;
    @(posedge clk);
  end
  //This stops the clock that was previously going to toggle forever
  disable generate_clock;
  $display("Tests completed.");
end
//Uncomment these lines to fully test the enabled resetable FF
//    assert property (@(posedge clk) disable iff (rst) en [-> CYCLES] |=> out == $past(in, CYCLES, en));
//    assert property (@(posedge clk) !en |=> $stable(out));
//    assert property (@(posedge clk) rst |=> out == '0);

endmodule  // delay_tb
