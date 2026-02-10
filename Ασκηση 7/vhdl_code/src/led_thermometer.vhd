LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY ledThermometer IS

    PORT( 

        tenths : IN  UNSIGNED        (3 DOWNTO 0);
        leds   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    
    );

END ledThermometer;

ARCHITECTURE rtl OF ledThermometer IS

    BEGIN

        -- thermometer output
        PROCESS(tenths)
        
            BEGIN

                leds <= (OTHERS=>'0');

                    FOR i IN 0 TO 9 LOOP

                        IF i <= to_integer(tenths) THEN

                            leds(i) <= '1'; -- άναψε LED

                        END IF;

                    END LOOP;

        END PROCESS;

END rtl;



