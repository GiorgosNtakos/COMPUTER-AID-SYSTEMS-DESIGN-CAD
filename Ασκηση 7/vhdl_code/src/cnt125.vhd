LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt125 IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        clkdiv125 : OUT STD_LOGIC   
    
    );

END cnt125;

ARCHITECTURE rtl OF cnt125 IS

    SIGNAL cnt       : UNSIGNED(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL div125_int : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                cnt <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF div125_int = '1' THEN

                        cnt <= (OTHERS => '0');

                    ELSE 

                        cnt <= cnt + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        div125_int <= '1' WHEN cnt = 124 ELSE
                     '0';
        clkdiv125 <= div125_int;

END ARCHITECTURE;