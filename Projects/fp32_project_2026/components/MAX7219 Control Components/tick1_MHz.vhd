LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Generate a one-cycle enable pulse every 100 clk cycles.
-- 100 MHz / (25 * 4) = 1 MHz

ENTITY tick_1MHz IS

    PORT( 

        clk    : IN   STD_LOGIC;
        rst    : IN   STD_LOGIC;    
        en_nxt : OUT  STD_LOGIC   
    
    );

END tick_1MHz;

ARCHITECTURE rtl OF tick_1MHz IS

    SIGNAl clk1MHz    : STD_LOGIC;
    SIGNAL en_cnt4b   : STD_LOGIC;

    BEGIN

        cnt25_i0 : ENTITY work.cnt25 PORT MAP (rst => rst, clk => clk, enable => '1',       clkdiv25  =>  en_cnt4b);
        cnt2b_i1 : ENTITY work.cnt2b PORT MAP (rst => rst, clk => clk, enable => en_cnt4b,  clkdiv4   => clk1MHz  );

        en_nxt <= en_cnt4b AND clk1MHz;


END rtl;
