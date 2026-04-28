library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
 Port ( 
    clk: in std_logic;
    sw: in std_logic_vector(1 downto 0);
    btn : in std_logic_vector(4 downto 0);

    hsync : out std_logic;
    vsync : out std_logic;
    
    vga_r   : out std_logic_vector(3 downto 0);      
    vga_g   : out std_logic_vector(3 downto 0);      
    vga_b   : out std_logic_vector(3 downto 0);
    
    CAT : out STD_LOGIC_VECTOR (6 downto 0);
    AN : out STD_LOGIC_VECTOR (7 downto 0);
    
    fg : in STD_LOGIC_VECTOR(1 downto 0);
    
    mono : out STD_LOGIC;
    amp_sd : out STD_LOGIC;
    sunet : in STD_LOGIC_VECTOR(3 downto 0)
    
    );
end vga;

architecture Behavioral of vga is
signal tick : std_logic_vector(1 downto 0) := "00";
signal h_cnt : std_logic_vector(9 downto 0) := (others => '0'); --800 ~ 640
signal v_cnt : std_logic_vector(9 downto 0) := (others => '0');   --525 ~ 480
signal h_sync : std_logic;
signal v_sync : std_logic;
signal v_sig : std_logic;
signal v_r : std_logic_vector(3 downto 0) := (others => '0');
signal v_g : std_logic_vector(3 downto 0) := (others => '0');
signal v_b : std_logic_vector(3 downto 0) := (others => '0');
signal en : std_logic_vector(4 downto 0) := (others => '0');
signal x_coord: std_logic_vector(9 downto 0) := "0001010001";
signal y_coord: std_logic_vector(9 downto 0) := "0001010001";
signal dx,dy : std_logic_vector(9 downto 0) := (others => '0');
signal dist: std_logic_vector(19 downto 0) := (others => '0');
signal forma_geometrica: std_logic_vector(1 downto 0) := "00";
signal tr_sus,tr_stanga, tr_dreapta : std_logic_vector(9 downto 0) := "0011110000";

signal sound_en : STD_LOGIC := '0';

signal Digit0 : STD_Logic_VECTOR (5 downto 0);
signal Digit1 : STD_Logic_VECTOR (5 downto 0);
signal Digit2 : STD_Logic_VECTOR (5 downto 0);
signal Digit3 : STD_Logic_VECTOR (5 downto 0);
signal Digit4 : STD_Logic_VECTOR (5 downto 0);
signal Digit5 : STD_Logic_VECTOR (5 downto 0);
signal Digit6 : STD_Logic_VECTOR (5 downto 0);
signal Digit7 : STD_Logic_VECTOR (5 downto 0);

signal randomRed : std_logic_vector(3 downto 0) := "1111";
signal randomGreen : std_logic_vector(3 downto 0) := "1111";
signal randomBlue : std_logic_vector(3 downto 0) := "1111";
component MPG is 
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component RandColorGenerator is
    Port ( clk : in STD_LOGIC;
           button : in STD_LOGIC;
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0));
end component;
component SSD is
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
end component;
component SoundGenerator is
    Port ( clk : in STD_LOGIC;
           mono : out STD_LOGIC;
           amp_sd : out STD_LOGIC;
           en : in std_logic;
           sunet : in STD_LOGIC_VECTOR(3 downto 0));
end component;
begin
MPGC: MPG port map(btn(0),clk,en(0)); --center
MPGL: MPG port map(btn(2),clk,en(2)); --left
MPGR: MPG port map(btn(3),clk,en(3)); --right
MPGU: MPG port map(btn(1),clk,en(1)); --up
MPGD: MPG port map(btn(4),clk,en(4)); --down
RCG: RandColorGenerator port map(clk,en(0),randomRed,randomGreen,randomBlue);
SSEG : SSD port map(clk,Digit0,Digit1,Digit2,Digit3,Digit4,Digit5,Digit6,Digit7,CAT,AN);
SOUNDGEN : SoundGenerator port map(clk,mono,amp_sd,sound_en,sunet);
process(clk)
begin

-- Divizor de ceas 100 MHz la 25 MHz
if rising_edge(clk) then
if sw = "10" then
if en(2) = '1' and x_coord > 65  then x_coord <= x_coord - 32;  sound_en <= '1';end if; -- stanga
    if en(3) = '1' and x_coord < 575 then x_coord <= x_coord + 32;  sound_en <= '1';end if; -- dreapta
    if en(1) = '1' and y_coord > 65  then y_coord <= y_coord - 32;  sound_en <= '1';end if; -- sus
    if en(4) = '1' and y_coord < 415 then y_coord <= y_coord + 32;  sound_en <= '1';end if; -- jos
else

if en(2) = '1' and x_coord > 65  then x_coord <= x_coord - 15; sound_en <= '1';end if; -- stanga
    if en(3) = '1' and x_coord < 575 then x_coord <= x_coord + 15; sound_en <= '1';end if; -- dreapta
    if en(1) = '1' and y_coord > 65  then y_coord <= y_coord - 15;  sound_en <= '1';end if; -- sus
    if en(4) = '1' and y_coord < 415 then y_coord <= y_coord + 15;  sound_en <= '1';end if; -- jos
end if;
if en = "00000" then sound_en <= '0'; end if;
    tick <= tick + 1;
    if tick = "11" then 
    if(h_cnt >= 656 and h_cnt <= 751) then
        h_sync <= '0';
    else
        h_sync <= '1';
    end if;
    
    if(v_cnt >= 490 and v_cnt <= 491) then
        v_sync <= '0';
    else
        v_sync <= '1';
    end if;
    
    if(h_cnt < 640 and v_cnt < 480) then
        v_sig <= '1';
    else
        v_sig <= '0';
    end if;

    if h_cnt < 799 then
        h_cnt <= h_cnt + 1;
    else 
        h_cnt <= (others => '0');
            if v_cnt < 524 then
                v_cnt <= v_cnt + 1;
            else 
                v_cnt <= (others => '0');
            end if;
    end if; 


    hsync <= h_sync;
    vsync <= v_sync;
    if v_sig = '1' then
        if sw = "00" then --sah 
Digit0 <= "011101"; -- t
Digit1 <= "001010"; -- A
Digit2 <= "001011"; -- b
Digit3 <= "010101"; -- L
Digit4 <= "001010"; -- A
Digit5 <= "011100"; -- S
Digit6 <= "001010"; -- A
Digit7 <= "010001"; -- H
if ((h_cnt(6) xor v_cnt(6)) = '1' and 
    (h_cnt >= 20 and h_cnt <= 620) and 
    (v_cnt >= 20 and v_cnt <= 460)) then   
     vga_r <= "1111"; vga_g <= "1111"; vga_b <= "1111"; -- Alb
else
    vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000"; -- Negru
end if;

elsif sw = "01" then -- animatie miscare

if fg = "00" then -- patrat
Digit0 <= "011001"; -- P
Digit1 <= "001010"; -- a
Digit2 <= "011101"; -- t
Digit3 <= "011011"; -- r
Digit4 <= "001010"; -- A
Digit5 <= "011101"; -- t
Digit6 <= "111111"; -- 
Digit7 <= "111111"; -- 
if ((h_cnt >=x_coord-50 and h_cnt <= x_coord + 50 )
and (v_cnt >= y_coord -50 and v_cnt <= y_coord+50))   then
    vga_r <= randomRed; vga_g <= randomGreen; vga_b <= randomBlue;
else
    vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000"; -- Negru
end if; 
elsif fg = "01" then -- cerc
Digit0 <= "001100"; -- c
Digit1 <= "001110"; -- e
Digit2 <= "011011"; -- r
Digit3 <= "001100"; -- c
Digit4 <= "111111"; -- 
Digit5 <= "111111"; -- 
Digit6 <= "111111"; -- 
Digit7 <= "111111"; -- 
if (h_cnt > x_coord) then
    dx <= h_cnt - x_coord;
else
    dx <= x_coord - h_cnt;
end if;
if (v_cnt > y_coord) then
    dy <= v_cnt - y_coord;
else
    dy <= y_coord - v_cnt;
end if;
dist <= dy*dy + dx*dx;
if dist < 2500 then
    vga_r <= randomRed; vga_g <= randomGreen; vga_b <= randomBlue; 
else
    vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000"; -- Negru
end if; 
elsif fg = "10" then -- triunghi
Digit0 <= "011101"; -- T
Digit1 <= "011011"; -- r
Digit2 <= "010010"; -- I
Digit3 <= "011110"; -- U
Digit4 <= "010111"; -- n
Digit5 <= "010000"; -- G
Digit6 <= "010001"; -- H
Digit7 <= "010010"; -- I
if (h_cnt > x_coord) then
        dx <= h_cnt - x_coord;
    else
        dx <= x_coord - h_cnt;
    end if;
if (v_cnt >= (y_coord - 50)) and (v_cnt <= (y_coord + 50)) then
            if (dx <= (v_cnt - (y_coord - 50))) then
            vga_r <= randomRed; 
            vga_g <= randomGreen; 
            vga_b <= randomBlue;
        else
            vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000";
        end if;
    else
        vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000";
    end if;
else -- romb
Digit0 <= "011011"; -- r
Digit1 <= "011000"; -- O
Digit2 <= "010110"; -- M 
Digit3 <= "001011"; -- b
Digit4 <= "111111"; -- 
Digit5 <= "111111"; -- 
Digit6 <= "111111"; -- 
Digit7 <= "111111"; --

--bitstream
--documentatie
--fisiere sursa

if (h_cnt > x_coord) then
        dx <= h_cnt - x_coord;
    else
        dx <= x_coord - h_cnt;
    end if;

    if (v_cnt > y_coord) then
        dy <= v_cnt - y_coord;
    else
        dy <= y_coord - v_cnt;
    end if;

    if (dx + dy <= 50) then
        vga_r <= randomRed; 
        vga_g <= randomGreen; 
        vga_b <= randomBlue;
    else
        vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000";
    end if;
end if;

elsif sw = "10" then     -- colorare ecran
Digit0 <= "001101"; -- d
Digit1 <= "001110"; -- E
Digit2 <= "011100"; -- S
Digit3 <= "001110"; -- E
Digit4 <= "010111"; -- n
Digit5 <= "111111"; -- stins
Digit6 <= "111111"; -- stins
Digit7 <= "111111"; -- stins
if ((h_cnt >=x_coord-14 and h_cnt <= x_coord + 14 )
and (v_cnt >= y_coord - 14 and v_cnt <= y_coord+14))   then
    vga_r <= randomRed; vga_g <= randomGreen; vga_b <= randomBlue; -- Alb
elsif (h_cnt >= 20 and h_cnt <= 620 and v_cnt >= 20 and v_cnt <= 460) then
    if (h_cnt(4 downto 0) < 2 or v_cnt(4 downto 0) < 2) then
        vga_r <= "1111"; vga_g <= "1111"; vga_b <= "1111"; -- Liniile grid-ului (Alb)
    else
        vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000"; -- Interiorul celulelor (Negru)
    end if;  
    
else
vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000"; -- Negru
end if; 


elsif sw = "11" then -- altceva

if (h_cnt(6) and v_cnt(6)) = '1' then
    vga_r <= "1000"; vga_g <= "0100"; vga_b <= "0010"; -- Rosu inchis
else
    vga_r <= "0010"; vga_g <= "0100"; vga_b <= "1000"; -- Negru
end if;

else
    vga_r <= "0000"; vga_g <= "0000"; vga_b <= "0000";
end if;

end if;
end if;
end if;
end process;

end Behavioral;
