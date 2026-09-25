module fsmMealy1101 (
    input  logic       X,
    input  logic       CLK,
    input  logic       RESET,
    output logic [2:0] Y,
    output logic       Z
  );

  // The P's and Q's match up with the equations obtained via K-map simplification on the supplemental slides
  logic P, Q, Pnext, Qnext;

  always_ff @(posedge CLK or posedge RESET)
  begin : clockAndReset
    if (RESET == 1'b1)
    begin
      P <= 1'b0;
      Q <= 1'b0;
    end
    else
    begin
      P <= Pnext;
      Q <= Qnext;
    end
  end

  assign Pnext = (P & ~Q) | (~P & Q & X);
  assign Qnext = (P & ~Q & ~X) | (~P & ~Q & X) | (P & Q & X);

  assign Z = P & Q & X;

  assign Y = {1'b0, P, Q}; // Y isn't really necessary but will help tell us our present state still

endmodule


module fsmMoore1101 (
    input  logic       X,
    input  logic       CLK,
    input  logic       RESET,
    output logic [2:0] Y,
    output logic       Z
  );

  // Here with the Moore machine we'll take a more traditional approach
  logic S2, S1, S0, S2next, S1next, S0next;

  always_ff @(posedge CLK or posedge RESET)
  begin : clockAndReset
    if (RESET == 1'b1)
    begin
      S2 <= 1'b0;
      S1 <= 1'b0;
      S0 <= 1'b0;
    end
    else
    begin
      S2 <= S2next;
      S1 <= S1next;
      S0 <= S0next;
    end
  end

  // Binary Encoding: "000" when A,"001" when B, "010" when C,"011" when D,"100" when E
  // Full State Transition Table (first our current state bits and input, then our "output" which is the next state bits)
  // S2 S1 S0 X S2' S1' S0'
  // 0  0  0  0 0   0   0
  // 0  0  0  1 0   0   1
  // 0  0  1  0 0   0   0
  // 0  0  1  1 0   1   0
  // 0  1  0  0 0   1   1
  // 0  1  0  1 0   1   0
  // 0  1  1  0 0   0   0
  // 0  1  1  1 1   0   0
  // 1  0  0  0 0   0   0
  // 1  0  0  1 0   1   0
  // Going to skip some logic simplification intentionally to better relate to the table
  // Feel free to simplify or do some of our other SV "tricks" where it makes sense though
  // So S2' = S2next = ~S2 & S1 & S0 & X
  // S1' = S1next = (~S2 & ~S1 & S0 & X) | (~S2 & S1 & ~S0 & ~X) | (~S2 & S1 & ~S0 & X) | (S2 & ~S1 & ~S0 & X)
  // S0' = S0next = (~S2 & ~S1 & ~S0 & X) | (~S2 & S1 & ~S0 & ~X)
  // Output Table
  // S2 S1 S0 Z
  // 0  0  0  0
  // 0  0  1  0
  // 0  1  0  0
  // 0  1  1  0
  // 1  0  0  1
  // So output equation is just Z = S2

  assign S2next = ~S2 & S1 & S0 & X;

  assign S1next = (~S2 & ~S1 & S0 & X) |
         (~S2 & S1 & ~S0 & ~X) |
         (~S2 & S1 & ~S0 & X) |
         (S2 & ~S1 & ~S0 & X);

  assign S0next = (~S2 & ~S1 & ~S0 & X) |
         (~S2 & S1 & ~S0 & ~X);

  assign Z = S2;

  assign Y = {S2, S1, S0}; // Y isn't really necessary but will help tell us our present state still

endmodule
