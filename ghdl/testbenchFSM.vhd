-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is
component fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(1 downto 0);
    Z : out std_logic);
end component fsm;
signal X, CLK, RESET, Z : std_logic;
signal Y : std_logic_vector(1 downto 0);

constant period : time := 20 ns;
constant simulationTime : time := 240 ns;
begin

oct12: fsm port map(X, CLK, RESET, Y, Z);

clk_process: process
begin
CLK <= '0';
wait for period/2;
CLK <= '1';
wait for period/2;
if NOW >= simulationTime then
wait;
end if;
end process;

inputs_process: process
begin

RESET <= '1';
wait for 20 ns;

RESET <= '0';
X <= '1';
wait for 20 ns;

X <= '1';
wait for 20 ns;

X <= '0';
wait for 20 ns;

X <= '1';
wait for 20 ns;

X <= '1';
wait for 20 ns;

X <= '0';
wait for 20 ns;

X <= '1';
wait for 20 ns;

X <= '0';
wait for 20 ns;

X <= '1';
wait for 20 ns;

RESET <= '1';
wait;

end process;
end tb;

