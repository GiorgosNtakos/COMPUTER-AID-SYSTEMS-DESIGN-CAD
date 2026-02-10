LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt_Tenth_Seconds IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        ts       : OUT UNSIGNED(2 DOWNTO 0) -- δεκαδες (0-5)
    
    );

END cnt_Tenth_Seconds;

ARCHITECTURE rtl OF cnt_Tenth_Seconds IS

    SIGNAL ts_reg : UNSIGNED(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL again  : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                ts_reg <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF again = '1' THEN

                        ts_reg <= (OTHERS => '0');

                    ELSE 

                        ts_reg <= ts_reg + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        again <= '1' WHEN ts_reg = 5 ELSE
               '0';

        ts <= ts_reg;

END ARCHITECTURE;