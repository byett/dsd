library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8 is
    Port ( REG_IN : in STD_LOGIC_VECTOR (7 downto 0);
           LD, CLK : in STD_LOGIC;
           REG_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end reg8;

architecture reg8 of reg8 is
begin
    reg: process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (LD = '1') then
                REG_OUT <= REG_IN;
            end if;
        end if;
    end process;        
end reg8;
