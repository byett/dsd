--  https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html
entity adder is
  -- `a`, `b`, and the carry-in `ci` are inputs of the adder.
  -- `s` is the sum output, `co` is the carry-out.
  port (ci : in bit; a, b : in bit; s : out bit; co : out bit);
end adder;

architecture rtl of adder is
begin
  --  This full-adder architecture contains two concurrent assignments.
  --  Compute the sum.
  s <= a xor b xor ci;
  --  Compute the carry.
  co <= (a and b) or (a and ci) or (b and ci);
end rtl;
