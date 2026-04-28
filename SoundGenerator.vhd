library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity SoundGenerator is
    Port ( clk : in STD_LOGIC;
           mono : out STD_LOGIC;
           amp_sd : out STD_LOGIC;
           en : in std_logic;
           sunet : in STD_LOGIC_VECTOR(3 downto 0));
end SoundGenerator;

architecture Behavioral of SoundGenerator is
signal counter : std_logic_vector(21 downto 0) := (others => '0');
signal numarator_timp : std_logic_vector(23 downto 0) := (others => '0');
signal stare : std_logic;
signal semnal_ales : std_logic;
begin
process(clk)    
begin
if rising_edge(clk) then
counter <= counter+1;
if en = '1' then
    amp_sd <= '1';
    stare <= '1';
    numarator_timp <= (others => '0');
elsif stare = '1' then
    if numarator_timp(23 downto 20) = "1111" then
    amp_sd <= '0';
    stare <= '0';
    numarator_timp <= (others => '0');
    else 
        numarator_timp <= numarator_timp + 1;
    end if;
else 
    amp_sd <= '0';
    numarator_timp <= (others => '0');
end if;
end if;
end process;
process(sunet, counter)
begin
    case sunet is
        when "0001" => semnal_ales <= counter(16);                          
        when "0010" => semnal_ales <= counter(15);                         
        when "0011" => semnal_ales <= counter(17);                          
        when "0100" => semnal_ales <= counter(16) xor counter(15);           
        when "0101" => semnal_ales <= counter(17) xor counter(16);           
        when "0110" => semnal_ales <= counter(16) and counter(20);          
        when "0111" => semnal_ales <= counter(15) and counter(21);        
        when "1000" => semnal_ales <= counter(16) xor counter(14) xor counter(12); 
        when "1001" => semnal_ales <= counter(17) or counter(16);            
        when "1010" => semnal_ales <= counter(16) xor counter(10);          
        when "1011" => semnal_ales <= counter(18);                         
        when "1100" => semnal_ales <= counter(16) xor counter(21);           
        when "1101" => semnal_ales <= (counter(16) xor counter(15)) and counter(20); 
        when "1110" => semnal_ales <= counter(14);                         
        when "1111" => semnal_ales <= counter(19);                         
        when others => semnal_ales <= '0';                                  
    end case;
end process;
mono <= semnal_ales and stare;
end Behavioral;
