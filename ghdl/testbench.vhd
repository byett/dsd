-- Code your testbench here
-- As always, there are other ways this can be done, but this should do the job for our purposes
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is
component mycomponent is
-- Change "mycomponent" to the name of the entity you created on the design side
-- Copy/paste the ports you created in the entity on the design side inside here
end component mycomponent;
-- Any inputs or outputs of your entity should be created as signals here
-- Don't double create CLK if your entity has them too!
signal CLK: std_logic;
-- The following values can be changed as needed if you actually need a longer/shorter simulationTime, slower/faster clock period, etc.
constant period : time := 20 ns;
constant simulationTime : time := 240 ns;
begin

--Change mycomponent to what you changed "mycomponent" to above
--Inside the parentheses, include all ports from your component
mytestingcomponent: mycomponent port map();

--Generally should keep this part the same as it allows our simulation to have a standardized clock
--It also forces the simulation to end at time "simulationTime"
clk_process: process
begin
CLK <= '0';
wait for period/2;
CLK <= '1';
wait for period/2;
if NOW >= simulationTime then
wait;
end if;
end process clk_process;

inputs_process: process
begin
-- In here, we'd create a sequence of changes to our inputs to test our system
-- This is the main point of the testbench!
-- We could test different inputs to a sequence of gates, different patterns of inputs for a finite state machine, etc.

-- KEEP THIS WAIT STATEMENT! Otherwise your simulation will never complete
wait;
end process inputs_process;
end tb;