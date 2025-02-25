-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(2 downto 0);
    Z : out std_logic);
end fsm;

 architecture fsmMealy1101 of fsm is
 -- The P's and Q's match up with the equations obtained via K-map simplification on the supplemental slides
 signal P,Q,Pnext,Qnext : std_logic;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then P<='0'; Q<='0';
         elsif (rising_edge(CLK)) then P<=Pnext; Q<=Qnext;
         end if;
   	end process clockAndReset;   
 Pnext <= (P and NOT(Q)) OR (NOT(P) AND Q AND X);
 Qnext <= (P AND NOT(Q) AND NOT(X)) OR (NOT(P) AND NOT(Q) AND X) OR (P AND Q AND X);
 Z <= P AND Q AND X; 
 Y <= '0' & P & Q; --Y isn't really necessary but will help tell us our present state still
 end fsmMealy1101; 
 
 architecture fsmMoore1101 of fsm is
 --Here with the Moore machine we'll take a more traditional approach
signal S2, S1, S0, S2next, S1next, S0next: std_logic;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then S2 <= '0'; S1<= '0'; S0 <= '0';
         elsif (rising_edge(CLK)) then S2 <= S2next; S1 <= S1next; S0 <= S0next;
         end if;
   	end process clockAndReset;
 -- Binary Encoding: "000" when A,"001" when B, "010" when C,"011" when D,"100" when E
 -- Full State Transition Table (first our current state bits and input, then our "output" which is the next state bits)
 -- S2 S1 S0 X S2' S1' S0'
 -- 0  0  0  0 0   0   0
 -- 0  0  0  1 0   0   1
 -- 0  0  1  0 0   0   0
 -- 0  0  1  1 0   1   0
 -- 0  1  0  0 0   1   1
 -- 0  1  0  1 0   1   0
 -- 0  1  1  0 0   0   0
 -- 0  1  1  1 1   0   0
 -- 1  0  0  0 0   0   0
 -- 1  0  0  1 0   1   0
 -- Going to skip some logic simplification intentionally to better relate to the table
 -- Feel free to simplify or do some of our other VHDL "tricks" where it makes sense though
 -- So S2' = S2next <= NOT(S2) AND S1 AND S0 AND X
 -- S1' = S1next <= (NOT(S2) AND NOT(S1) AND S0 and X) OR (NOT(S2) AND S1 AND NOT(S0) AND NOT(X)) OR (NOT(S2) AND S1 AND NOT(S0) AND X) OR (S2 AND NOT(S1) AND NOT(S0) AND X)
 -- S0' = S0next <= (NOT(S2) AND NOT(S1) AND NOT(S0) AND X) OR (NOT(S2) AND S1 AND NOT(S0) AND NOT(X))
 -- Output Table
 -- S2 S1 S0 Z
 -- 0  0  0  0
 -- 0  0  1  0
 -- 0  1  0  0
 -- 0  1  1  0
 -- 1  0  0  1
 -- So output equation is just Z = S2

    S2next <= NOT(S2) AND S1 AND S0 AND X;
    S1next <= (NOT(S2) AND NOT(S1) AND S0 and X) OR (NOT(S2) AND S1 AND NOT(S0) AND NOT(X)) OR (NOT(S2) AND S1 AND NOT(S0) AND X) OR (S2 AND NOT(S1) AND NOT(S0) AND X);
    S0next <= (NOT(S2) AND NOT(S1) AND NOT(S0) AND X) OR (NOT(S2) AND S1 AND NOT(S0) AND NOT(X));
    Z <= S2;
    Y <= S2 & S1 & S0; --Y isn't really necessary but will help tell us our present state still
 end fsmMoore1101; 
