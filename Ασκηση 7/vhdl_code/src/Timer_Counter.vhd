LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Timer_Clock IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        ss       : OUT UNSIGNED(3 DOWNTO 0); -- μοναδες (0-9)
        ts       : OUT UNSIGNED(2 DOWNTO 0)    -- δεκαδες (0-5)
    
    );

END Timer_Clock;

ARCHITECTURE rtl OF Timer_Clock IS

    SIGNAL ent    : STD_LOGIC;
    SIGNAL en_ts  : STD_LOGIC;

    BEGIN

        in0_ss : ENTITY work.cnt_Single_Seconds PORT MAP (clk => clk, rst => rst, enable => enable, ss => ss, nxt => ent);

        en_ts <= enable AND ent;

        in1_ts : ENTITY work.cnt_Tenth_Seconds PORT MAP (clk => clk, rst => rst, enable => en_ts, ts => ts);

END ARCHITECTURE;