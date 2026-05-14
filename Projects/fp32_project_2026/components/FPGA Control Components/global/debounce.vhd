LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY debounce IS
    PORT(
        fclk        : IN STD_LOGIC;
        rst         : IN STD_LOGIC;
        push_button : IN STD_LOGIC;
        pulse       : OUT STD_LOGIC
    );
END ENTITY debounce;

ARCHITECTURE rtl OF debounce IS

    SIGNAL pb_samples : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rswitch    : STD_LOGIC;

    SIGNAL counter    : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL debounced  : STD_LOGIC := '0';
    SIGNAL pulse_reg  : STD_LOGIC := '0';

BEGIN

    -- Synchronize asynchronous push button input to fclk
    PROCESS(fclk, rst)
    BEGIN

        IF rst = '1' THEN
            pb_samples <= (OTHERS => '0');
        
        ELSIF RISING_EDGE(fclk) THEN
            pb_samples <= pb_samples(2 DOWNTO 0) & push_button;

        END IF;
    END PROCESS;

    rswitch <= pb_samples(3);

    -- Debounce Logic
    PROCESS(fclk, rst)
    BEGIN

        IF rst = '1' THEN
            counter   <= (OTHERS => '0');
            debounced <= '0';
            pulse_reg <= '0';

        ELSIF RISING_EDGE(fclk) THEN
            pulse_reg <= '0';

            IF debounced = rswitch THEN
                counter <= (OTHERS => '0');

            ELSE
                counter <= counter + 1;

                IF counter = x"FFFF" THEN
                    debounced <= rswitch;

                    -- Generate 1-cycle pulse only on rising button press
                    IF rswitch = '1' THEN
                        pulse_reg <= '1';
                    END IF;

                    counter <= (OTHERS => '0');
                END IF;
            END IF;
        END IF;
    END PROCESS;

    pulse <= pulse_reg;

END ARCHITECTURE rtl;
