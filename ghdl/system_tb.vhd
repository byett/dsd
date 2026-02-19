library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity system_tb is
end system_tb;

architecture testbench of system_tb is
signal N : integer := 8;
component reg is
    generic (
        N : integer := 8);
    Port ( REG_IN : in STD_LOGIC_VECTOR (N-1 downto 0);
           LD, CLK : in STD_LOGIC;
           REG_OUT : out STD_LOGIC_VECTOR (N-1 downto 0));
end component reg;
component MUX is
    generic (
        N : integer := 8);
    Port ( D1_IN,D2_IN : in STD_LOGIC_VECTOR(N-1 downto 0);
           SEL : in STD_LOGIC;
           MX_OUT : out STD_LOGIC_VECTOR(N-1 downto 0));
end component MUX;
    signal clk, sel   : std_logic;
    signal LD   : std_logic_vector(1 downto 0) := "00"; --disable loading by default
    signal MX_OUT : std_logic_vector(N-1 downto 0);
    signal D1_in, D2_in : std_logic_vector(N-1 downto 0);
    type reg_file is array (1 downto 0) of std_logic_vector(N-1 downto 0);
    signal registers: reg_file;
-- The following values can be changed as needed if you actually need a longer/shorter simulationTime, slower/faster clock period, etc.
constant period : time := 20 ns;
constant simulationTime : time := 240 ns;
begin
    muxComponent: MUX
        generic map (
            N => 8)
        port map (
            D1_in, D2_in, sel, MX_OUT
        );
        registerGeneration: for i in 1 downto 0 generate
        R: reg
        generic map (
            N => 8)
        port map (MX_OUT, LD(i), CLK, registers(i));
        end generate registerGeneration;
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
D1_IN <= conv_std_logic_vector (1,N);
D2_IN <= conv_std_logic_vector (2,N);
wait for 5 ns;
SEL <= '0';
LD(1) <= '1';
wait for 20 ns;
SEL <= '1';
wait for 15 ns;
LD(0) <= '1';
wait for 20 ns;

-- KEEP THIS WAIT STATEMENT! Otherwise your simulation will never complete
wait;
end process inputs_process;
end testbench;
