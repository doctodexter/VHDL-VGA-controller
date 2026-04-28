library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity SSD is
    Port ( clk : in STD_LOGIC;
           Digit0 : in STD_Logic_VECTOR (5 downto 0);
           Digit1 : in STD_Logic_VECTOR (5 downto 0);
           Digit2 : in STD_Logic_VECTOR (5 downto 0);
           Digit3 : in STD_Logic_VECTOR (5 downto 0);
           Digit4 : in STD_Logic_VECTOR (5 downto 0);
           Digit5 : in STD_Logic_VECTOR (5 downto 0);
           Digit6 : in STD_Logic_VECTOR (5 downto 0);
           Digit7 : in STD_Logic_VECTOR (5 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;
 
architecture Behavioral of SSD is
 
signal count: std_logic_vector (16 downto 0) := (others => '0');
signal cnt: std_logic_vector (2 downto 0) := (others => '0');
signal mux1: std_logic_vector (5 downto 0) := (others => '0');
 
begin
 
cnt(2) <= count(16);
cnt(1) <= count(15);
cnt(0) <= count(14);
 
process (clk)
begin
    if rising_edge(clk) then
        count <= count + 1;
    end if;
end process;
 
process (cnt)
begin
    case cnt is
        when "000" => AN <= "11111110";
        when "001" => AN <= "11111101";
        when "010" => AN <= "11111011";
        when "011" => AN <= "11110111";
        when "100" => AN <= "11101111";
        when "101" => AN <= "11011111";
        when "110" => AN <= "10111111";
        when others => AN <= "01111111";
    end case;
end process;
 
process(cnt, digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7)
begin
    case cnt is
        when "000" => mux1 <= digit0;
        when "001" => mux1 <= digit1;
        when "010" => mux1 <= digit2;
        when "011" => mux1 <= digit3;
        when "100" => mux1 <= digit4;
        when "101" => mux1 <= digit5;
        when "110" => mux1 <= digit6;
        when others => mux1 <= digit7;
    end case;
end process;
 
process (mux1)
begin
    case mux1 is
-- CIFRE (0-9)
when "000000" => CAT <= "1000000"; -- 0
    when "000001" => CAT <= "1111001"; -- 1
    when "000010" => CAT <= "0100100"; -- 2
    when "000011" => CAT <= "0110000"; -- 3
    when "000100" => CAT <= "0011001"; -- 4
    when "000101" => CAT <= "0010010"; -- 5
    when "000110" => CAT <= "0000010"; -- 6
    when "000111" => CAT <= "1111000"; -- 7
    when "001000" => CAT <= "0000000"; -- 8
    when "001001" => CAT <= "0010000"; -- 9

       when "001010" => CAT <= "0001000"; -- A

    when "001011" => CAT <= "0000011"; -- b

    when "001100" => CAT <= "1000110"; -- C

    when "001101" => CAT <= "0100001"; -- d

    when "001110" => CAT <= "0000110"; -- E

    when "001111" => CAT <= "0001110"; -- F

    when "010000" => CAT <= "1000010"; -- G

    when "010001" => CAT <= "0001001"; -- H

    when "010010" => CAT <= "1111001"; -- I 

    when "010011" => CAT <= "1100001"; -- J

    when "010100" => CAT <= "0001010"; -- K 
    when "010101" => CAT <= "1000111"; -- L
    when "010110" => CAT <= "0101010"; -- M 
    when "010111" => CAT <= "1101010"; -- n
    when "011000" => CAT <= "1000000"; -- O 
    when "011001" => CAT <= "0001100"; -- P
    when "011010" => CAT <= "0011000"; -- q
    when "011011" => CAT <= "0101111"; -- r
    when "011100" => CAT <= "0010010"; -- S 
    when "011101" => CAT <= "0000111"; -- t
    when "011110" => CAT <= "1000001"; -- U
    when "011111" => CAT <= "1100011"; -- v
    when "100000" => CAT <= "0010101"; -- W 
    when "100001" => CAT <= "0110111"; -- X 
    when "100010" => CAT <= "0010001"; -- Y
    when "100011" => CAT <= "0100100"; -- Z 
    when "100100" => CAT <= "0111111"; -- minus
    
    when others   => CAT <= "1111111"; -- stins
     end case;
end process;

 
end Behavioral;
