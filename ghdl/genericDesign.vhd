-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity gen_parity_check is
generic (n : positive);
port (x : in std_logic_vector(n-1 downto 0);
	y: out std_logic);
end gen_parity_check;

architecture arch of gen_parity_check is
	begin
    	process(x)
        	variable temp: std_logic;
         begin
         	temp:='0';
            for i in x'range loop
            	temp:= temp XOR x(i);
             end loop;
             y <= temp;
          end process;
end arch;