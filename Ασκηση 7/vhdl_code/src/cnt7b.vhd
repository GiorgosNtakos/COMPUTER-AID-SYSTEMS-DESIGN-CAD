LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt7b IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        clkdiv128 : OUT STD_LOGIC   
    
    );

END cnt7b;

ARCHITECTURE rtl OF cnt7b IS

    SIGNAL cnt        : UNSIGNED(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL div128_int : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                cnt <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF div128_int = '1' THEN

                        cnt <= (OTHERS => '0');

                    ELSE 

                        cnt <= cnt + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        div128_int <= '1' WHEN cnt = 127 ELSE
                    '0';
        clkdiv128 <= div128_int;

END ARCHITECTURE;