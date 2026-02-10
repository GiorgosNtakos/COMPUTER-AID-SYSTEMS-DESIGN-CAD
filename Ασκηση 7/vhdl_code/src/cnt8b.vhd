LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt8b IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        clkdiv256 : OUT STD_LOGIC   
    
    );

END cnt8b;

ARCHITECTURE rtl OF cnt8b IS

    SIGNAL cnt        : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL div256_int : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                cnt <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF div256_int = '1' THEN

                        cnt <= (OTHERS => '0');

                    ELSE 

                        cnt <= cnt + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        div256_int <= '1' WHEN cnt = 255 ELSE
                    '0';
        clkdiv256 <= div256_int;

END ARCHITECTURE;