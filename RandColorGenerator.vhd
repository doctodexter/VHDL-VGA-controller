library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity RandColorGenerator is
    Port ( clk : in STD_LOGIC;
           button : in STD_LOGIC;
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0));
end RandColorGenerator;
architecture Behavioral of RandColorGenerator is
    signal counter : std_logic_vector(30 downto 0) := (others => '0');
    signal r_reg, g_reg, b_reg : std_logic_vector(3 downto 0) := "1111"; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;

            if button = '1' then
            r_reg <= counter(15 downto 12); 
            g_reg <= counter(19 downto 16); 
            b_reg <= counter(23 downto 20); 
            end if;
        end if;
    end process;

    red   <= r_reg;
    green <= g_reg;
    blue  <= b_reg;
end Behavioral;
