-- Half Adder (HA) Test Bench (TB)
-- Author: Nerdy Dave
-- Source: https://youtu.be/H2GyAIYwZbw
library ieee;
use ieee.std_logic_1164.all;

entity ha_tb is
end ha_tb;

architecture test of ha_tb is
    component ha
        port
        (
            a:  in  std_logic;
            b:  in  std_logic;
            s:  out std_logic; -- Sum
            c:  out std_logic  -- Carry
        );
    end component;
    
    signal a, b, s, c : std_logic;
begin
    half_addr: ha port map (a => a, b => b, s => s, c => c);
    
    process begin
    
    a <= 'X';
    b <= 'X';
    wait for 1 ns;
    
    a <= '0';
    b <= '0';
    wait for 1 ns;
    
    a <= '0';
    b <= '1';
    wait for 1 ns;
    
    a <= '1';
    b <= '0';
    wait for 1 ns;
    
    a <= '1';
    b <= '1';
    wait for 1 ns;
    
    assert false report "Reached end of test";
    wait;
    
    end process;
    
end test;
