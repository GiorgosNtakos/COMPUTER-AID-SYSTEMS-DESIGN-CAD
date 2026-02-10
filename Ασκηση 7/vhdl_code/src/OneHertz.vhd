LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY OneHertz IS

    PORT( 

        clk    : IN   STD_LOGIC;
        rst    : IN   STD_LOGIC;    
        en_nxt : OUT  STD_LOGIC   
    
    );

END OneHertz;

ARCHITECTURE rtl OF OneHertz IS

    SIGNAl clk1Hz                       : STD_LOGIC;
    SIGNAL first, second, third, fourth : STD_LOGIC;
    SIGNAL en2, en3, en4                : STD_LOGIC;

    BEGIN

        en2 <= first AND second;
        en3 <= en2   AND  third;
        en4 <= en3   AND fourth;

        cnt25_i0 : ENTITY work.cnt25 PORT MAP (rst => rst, clk => clk, enable => '1',   clkdiv25  =>  first);
        cnt25_i1 : ENTITY work.cnt25 PORT MAP (rst => rst, clk => clk, enable => first, clkdiv25  => second);
        cnt25_i2 : ENTITY work.cnt25 PORT MAP (rst => rst, clk => clk, enable => en2,   clkdiv25  =>  third);
        cnt25_i3 : ENTITY work.cnt25 PORT MAP (rst => rst, clk => clk, enable => en3,   clkdiv25  => fourth);
        cnt8b_i4 : ENTITY work.cnt8b PORT MAP (rst => rst, clk => clk, enable => en4,   clkdiv256 => clk1Hz);

        en_nxt <= en4 AND clk1Hz;


END rtl;
