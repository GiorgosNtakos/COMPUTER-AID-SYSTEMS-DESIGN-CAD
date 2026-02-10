LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt_Single_Seconds IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        ss       : OUT UNSIGNED(3 DOWNTO 0); -- μοναδες (0-9)
        nxt      : OUT STD_LOGIC   -- nxt = 1 οταν ss = 9 
    
    );

END cnt_Single_Seconds;

ARCHITECTURE rtl OF cnt_Single_Seconds IS

    SIGNAL ss_reg : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nxt_in : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                ss_reg <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF nxt_in = '1' THEN

                        ss_reg <= (OTHERS => '0');

                    ELSE 

                        ss_reg <= ss_reg + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        nxt_in <= '1' WHEN ss_reg = 9 ELSE
                  '0';

        nxt    <= nxt_in;

        ss <= ss_reg;

END ARCHITECTURE;