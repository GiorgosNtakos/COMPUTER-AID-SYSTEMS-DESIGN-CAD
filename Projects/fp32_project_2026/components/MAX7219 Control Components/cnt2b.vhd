LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY cnt2b IS

    PORT( 

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;    
        enable   : IN  STD_LOGIC;
        clkdiv4  : OUT STD_LOGIC   
    
    );

END cnt2b;

ARCHITECTURE rtl OF cnt2b IS

    SIGNAL cnt        : UNSIGNED(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL div4_int : STD_LOGIC;

    BEGIN

        PROCESS (clk, rst)

        BEGIN

            IF rst = '1' THEN

                cnt <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF enable = '1' THEN

                    IF div4_int = '1' THEN

                        cnt <= (OTHERS => '0');

                    ELSE 

                        cnt <= cnt + 1;

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        div4_int <= '1' WHEN cnt = 3 ELSE
                    '0';
        clkdiv4 <= div4_int;

END ARCHITECTURE;