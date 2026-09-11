// Modified based on example from Greg Stitt, University of Florida

`timescale 1 ns / 10 ps

// Module: tff_tb

module tff_tb();

  logic clk, rst, T, Q = '0;

  tff tff1 (.clk, .rst, .T, .Q);

  initial
  begin : clk_process
    clk <= 1'b0;
    forever
      #5 clk <= ~clk;
  end

  initial
  begin : stim_proc
    $timeformat(-9, 0, " ns");

    rst <= 1'b1;

    #50;

    rst <= 1'b0;
    T <= 1'b0;

    #50;

    rst <= 1'b0;
    T <= 1'b1;

    #50;

    rst <= 1'b1;

    #50;

    disable clk_process;
  end
endmodule
