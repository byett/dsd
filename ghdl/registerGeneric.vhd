library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    generic (
        N : integer := 8);
    Port ( REG_IN : in STD_LOGIC_VECTOR (N-1 downto 0);
           LD, CLK : in STD_LOGIC;
           REG_OUT : out STD_LOGIC_VECTOR (N-1 downto 0));
end reg;

architecture reg of reg is
begin
    reg: process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (LD = '1') then
                REG_OUT <= REG_IN;
            end if;
        end if;
    end process;        
end reg;