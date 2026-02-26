library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity MUX is
    generic (
        N : integer := 8);
    Port ( D1_IN,D2_IN : in STD_LOGIC_VECTOR(N-1 downto 0);
           SEL : in STD_LOGIC;
           MX_OUT : out STD_LOGIC_VECTOR(N-1 downto 0));
end MUX;

architecture ifMux of MUX is

begin
muxProcess: process(SEL,D1_IN,D2_IN)

begin
if SEL = '0' then MX_OUT <= D1_IN;
elsif SEL = '1' then MX_OUT <= D2_IN;
else MX_OUT <= conv_std_logic_vector (0,N);
end if;
end process muxProcess;
end ifMux;
