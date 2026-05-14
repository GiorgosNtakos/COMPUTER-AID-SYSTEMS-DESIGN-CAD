LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt25 IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        clkdiv25 : OUT STD_LOGIC   
    
    );

END cnt25;

ARCHITECTURE rtl OF cnt25 IS

    SIGNAL cnt       : UNSIGNED(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL div25_int : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                cnt <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF div25_int = '1' THEN

                        cnt <= (OTHERS => '0');

                    ELSE 

                        cnt <= cnt + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        div25_int <= '1' WHEN cnt = 24 ELSE
                     '0';
        clkdiv25 <= div25_int;

END ARCHITECTURE;