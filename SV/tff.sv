//A Single-Bit TFF
module tff  (
    input  logic             clk,
    input  logic             rst,
    input  logic             T, //This now controls how we toggle instead of directly controlling inputs
    output logic             Q
  );
  always_ff @(posedge clk or posedge rst)
  begin
    Q <= ~T;
    if (rst)
      Q <= '0;
  end
endmodule  // tff
