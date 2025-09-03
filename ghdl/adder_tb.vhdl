--  https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html
--  A testbench has no ports.
entity adder_tb is
end adder_tb;

architecture behav of adder_tb is
  --  Declaration of the component that will be instantiated.
  component adder
    port (ci : in bit; a, b : in bit; s : out bit; co : out bit);
  end component;

  signal a, b, ci, s, co : bit;
begin
  --  Component instantiation.
  adder_0: adder port map (ci => ci, a => a, b => b,
                           s => s, co => co);

  --  This process does the real job.
  process
    type pattern_type is record
      --  The inputs of the adder.
      ci, a, b : bit;
      --  The expected outputs of the adder.
      co, s : bit;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0', '0'),
       ('0', '0', '1', '0', '1'),
       ('0', '1', '0', '0', '1'),
       ('0', '1', '1', '1', '0'),
       ('1', '0', '0', '0', '1'),
       ('1', '0', '1', '1', '0'),
       ('1', '1', '0', '1', '0'),
       ('1', '1', '1', '1', '1'));
  begin
    --  Check each pattern.
    for i in patterns'range loop
      --  Set the inputs.
      a <= patterns(i).a;
      b <= patterns(i).b;
      ci <= patterns(i).ci;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert s = patterns(i).s
        report "bad sum value" severity error;
      assert co = patterns(i).co
        report "bad carry out value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
