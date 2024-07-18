-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(2 downto 0);
    Z : out std_logic);
end fsm;

 architecture fsmMealy1101 of fsm is
 	type state_type is (A, B, C, D);
     signal PS, NS : state_type;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then PS <= A;
         elsif (rising_edge(CLK)) then PS <= NS;
         end if;
   	end process clockAndReset;
 -- From state A, a 1 outputs a 0 and goes to state B
 -- From state A, a 0 outputs a 0 and goes to state A
 -- B: 1/0 -> C
 -- B: 0/0 -> A
 -- C: 1/0 -> C
 -- C: 0/0 -> D
 -- D: 0/0 -> A
 -- D: 1/1 -> B    
     stateAndOutputLogic : process(PS, X)
     begin
     case PS is
     	when A =>
         	if (X = '1') then Z<='0'; NS <= B;
             else Z <= '0'; NS <= A;
             end if;
         when B =>
         	if (X = '1') then Z <= '0'; NS <= C;
             else Z <= '0'; NS <= A;
             end if;
         when C =>
         	if (X = '1') then Z <= '0'; NS <= C;
             else Z <= '0'; NS <= D;
             end if;
         when D =>
         	if (X = '1') then Z <= '1'; NS <= B;
             else Z <= '0'; NS <= A;
             end if;
         end case;
     end process stateAndOutputLogic;
    
     with PS select
     Y <= "000" when A,
     	  "001" when B,
          "010" when C,
          "011" when D,
          "000" when others;
 end fsmMealy1101; 
 
 architecture fsmMoore1101 of fsm is
 	type state_type is (A, B, C, D, E);
     signal PS, NS : state_type;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then PS <= A;
         elsif (rising_edge(CLK)) then PS <= NS;
         end if;
   	end process clockAndReset;
 -- States A through D output 0's
 -- State E outputs 1
 -- From state A, a 1 goes to state B
 -- From state A, a 0 goes to state A
 -- B: 1 -> C
 -- B: 0 -> A
 -- C: 1 -> C
 -- C: 0 -> D
 -- D: 0 -> A
 -- D: 1 -> E
 -- E: 0 -> A
 -- E: 1 -> C    
     stateAndOutputLogic : process(PS, X)
     begin
     case PS is
     	when A =>
     	    Z <= '0';
         	if (X = '1') then NS <= B;
             else NS <= A;
             end if;
         when B =>
            Z <= '0';
         	if (X = '1') then NS <= C;
             else NS <= A;
             end if;
         when C =>
            Z <= '0';
         	if (X = '1') then NS <= C;
             else NS <= D;
             end if;
         when D =>
            Z <= '0';
         	if (X = '1') then NS <= E;
             else NS <= A;
             end if;
         when E =>
            Z <= '1';
            if (X = '1') then NS <= C;
            else NS <= A;
            end if;
         end case;
     end process stateAndOutputLogic;
    
     with PS select
     Y <= "000" when A,
     	  "001" when B,
          "010" when C,
          "011" when D,
          "100" when E,
          "000" when others;
 end fsmMoore1101; 
