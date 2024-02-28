-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
-- Reset signal to state A
entity fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(1 downto 0);
    Z : out std_logic);
end fsm;

-- architecture fsmMealy1101 of fsm is
-- 	type state_type is (A, B, C, D);
--     signal PS, NS : state_type;
-- begin 
-- 	clockAndReset: process(CLK, RESET)
--     begin
--     	if (RESET = '1') then PS <= A;
--         elsif (rising_edge(CLK)) then PS <= NS;
--         end if;
--   	end process clockAndReset;
-- -- From state A, a 1 outputs a 0 and goes to state B
-- -- From state A, a 0 outputs a 0 and goes to state A
-- -- B: 1/0 -> C
-- -- B: 0/0 -> A
-- -- C: 1/0 -> C
-- -- C: 0/0 -> D
-- -- D: 0/0 -> A
-- -- D: 1/1 -> B    
--     stateAndOutputLogic : process(PS, X)
--     begin
--     case PS is
--     	when A =>
--         	if (X = '1') then Z<='0'; NS <= B;
--             else Z <= '0'; NS <= A;
--             end if;
--         when B =>
--         	if (X = '1') then Z <= '0'; NS <= C;
--             else Z <= '0'; NS <= A;
--             end if;
--         when C =>
--         	if (X = '1') then Z <= '0'; NS <= C;
--             else Z <= '0'; NS <= D;
--             end if;
--         when D =>
--         	if (X = '1') then Z <= '1'; NS <= B;
--             else Z <= '0'; NS <= A;
--             end if;
--         end case;
--     end process stateAndOutputLogic;
    
--     with PS select
--     Y <= "00" when A,
--     	"01" when B,
--         "10" when C,
--         "11" when D,
--         "00" when others;
-- end fsmMealy1101; 

architecture fsmMealyEquations1101 of fsm is
    signal PS, NS : std_logic_vector(1 downto 0);
begin 
	clockAndReset: process(CLK, RESET)
    begin
    	if (RESET = '1') then PS <= "00";
        elsif (rising_edge(CLK)) then PS <= NS;
        end if;
  	end process clockAndReset;
    
    NS(1) <= '1' when (PS(1) = '0' AND PS(0) = '1' AND X = '1') OR
    					(PS(1) = '1' AND PS(0) = '0' AND X = '0') OR
                        (PS(1) = '1' AND PS(0) = '0' AND X = '1') else '0';
    NS(0) <= '1' when (PS(1) = '0' AND PS(0) = '0' AND X = '1') OR
    					(PS(1) = '1' AND PS(0) = '0' AND X = '0') OR
                        (PS(1) = '1' AND PS(0) = '1' AND X = '1') else '0';
    Z <= '1' when (PS(1) = '1' AND PS(0) = '1' AND X = '1') else '0';
    Y <= PS;
end fsmMealyEquations1101;