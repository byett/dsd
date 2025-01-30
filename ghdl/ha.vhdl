-- Binary half adder (HA)
-- Author: Nerdy Dave
-- Source: https://youtu.be/H2GyAIYwZbw
library ieee;               
use ieee.std_logic_1164.all;

entity ha is
    port
    (
        a:  in  std_logic; 
        b:  in  std_logic; 
        s:  out std_logic; -- Output sum of a and b
        c:  out std_logic  -- Output carry
    );
end ha;

architecture behave of ha is
begin
    s <= a xor b;
    c <= a and b;
end behave;
