LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TenHertz IS

    PORT( 

        clk    : IN   STD_LOGIC;
        rst    : IN   STD_LOGIC;    
        en_nxt : OUT  STD_LOGIC   
    
    );

END TenHertz;

ARCHITECTURE rtl OF TenHertz IS

    SIGNAl clk10Hz              : STD_LOGIC;
    SIGNAL first, second, third : STD_LOGIC;
    SIGNAL en2, en3             : STD_LOGIC;

    BEGIN

        en2 <= first AND second;
        en3 <= en2   AND  third;

        cnt25_i0 : ENTITY work.cnt25 PORT MAP  (rst => rst, clk => clk, enable => '1',   clkdiv25   =>   first);
        cnt25_i1 : ENTITY work.cnt25 PORT MAP  (rst => rst, clk => clk, enable => first, clkdiv25   =>  second);
        cnt25_i3 : ENTITY work.cnt125 PORT MAP (rst => rst, clk => clk, enable => en2,   clkdiv125  =>   third);
        cnt8b_i4 : ENTITY work.cnt7b PORT MAP  (rst => rst, clk => clk, enable => en3,   clkdiv128  => clk10Hz);

        en_nxt <= en3 AND clk10Hz;


END rtl;
