library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Generic_Counter is
    generic (
        N : integer := 4  -- Default bit-width is 4
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        count : out std_logic_vector(N-1 downto 0)
    );
end Generic_Counter;

architecture Behavioral of Generic_Counter is
    signal cnt : std_logic_vector(N-1 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            cnt <= (others => '0');  -- Reset counter to 0
        elsif rising_edge(clk) then
            cnt <= cnt + 1;  -- Increment counter
        end if;
    end process;
    
    count <= cnt;
end Behavioral;
