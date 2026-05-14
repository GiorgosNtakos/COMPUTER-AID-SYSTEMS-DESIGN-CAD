LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY addr_counter_mod10 IS
    PORT(
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        pulse_i : IN STD_LOGIC;

        addr_o  : OUT UNSIGNED(3 DOWNTO 0)
    );
END ENTITY addr_counter_mod10;

ARCHITECTURE rtl OF addr_counter_mod10 IS

    SIGNAL addr_reg : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');

BEGIN

    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN
            IF rst = '1' THEN
                addr_reg <= (OTHERS => '0');

            ELSIF pulse_i = '1' THEN
                IF addr_reg = 9 THEN
                    addr_reg <= (OTHERS => '0');
                
                ELSE
                    addr_reg <= addr_reg + 1;

                END IF;
            END IF;
        END IF;

    END PROCESS;

    addr_o <= addr_reg;

END ARCHITECTURE rtl;
