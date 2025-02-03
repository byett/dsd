library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Module is
end entity Top_Module;

architecture Struct of Top_Module is
    component Generic_Counter is
    generic (
        N : integer := 4  -- Default bit-width is 4
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        count : out std_logic_vector(N-1 downto 0)
    );
    end component Generic_Counter;
    signal clk   : std_logic;
    signal reset : std_logic;
    signal count_8bit : std_logic_vector(7 downto 0);  -- 8-bit counter
-- The following values can be changed as needed if you actually need a longer/shorter simulationTime, slower/faster clock period, etc.
constant period : time := 20 ns;
constant simulationTime : time := 240 ns;
begin
    U1: entity work.Generic_Counter
        generic map (
            N => 8  -- Override default 4-bit width with 8-bit
        )
        port map (
            clk   => clk,
            reset => reset,
            count => count_8bit
        );
        clk_process: process
begin
CLK <= '0';
wait for period/2;
CLK <= '1';
wait for period/2;
if NOW >= simulationTime then
wait;
end if;
end process clk_process;

inputs_process: process
begin
-- In here, we'd create a sequence of changes to our inputs to test our system
-- This is the main point of the testbench!
-- We could test different inputs to a sequence of gates, different patterns of inputs for a finite state machine, etc.

-- KEEP THIS WAIT STATEMENT! Otherwise your simulation will never complete
wait;
end process inputs_process;
end Struct;
