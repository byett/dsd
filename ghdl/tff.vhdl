--  https://electronicstopper.blogspot.com/2017/07/t-flip-flop-in-vhdl-with-testbench.html
library ieee;
use ieee.std_logic_1164.all;

entity TFF is
port( T: in std_logic;
clk: in std_logic;
rst: in std_logic;
Q: out std_logic);
end TFF;

architecture behavioral of TFF is
begin
process(rst,clk,T)
begin
if (rst='1') then
Q<='0';
elsif(rising_edge(clk)) then
Q<=not T;
end if;
end process;

end behavioral;
