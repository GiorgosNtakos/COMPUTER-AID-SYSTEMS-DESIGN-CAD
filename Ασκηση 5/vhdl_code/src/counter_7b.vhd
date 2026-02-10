LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS

    PORT (

        clock      :  IN STD_LOGIC; -- ρολοι
        clear      :  IN STD_LOGIC; --ασυγχρονο reset
        load       :  IN STD_LOGIC; -- φορτωση δεδομενων
        start_stop :  IN STD_LOGIC; -- enable
        data       :  IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- εισοδος για παλληλη φορτωση
        count      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- τρεχουσα τιμη μετρητη
        
    );

END counter;

ARCHITECTURE Behavioral OF counter IS

    SIGNAL cnt_reg : unsigned(6 downto 0) := (others => '0');

    BEGIN

        PROCESS(clock, clear)

            BEGIN

                IF clear = '1' THEN -- ασυγχρονο rst

                    cnt_reg <= (others => '0');

                ELSIF RISING_EDGE(CLOCK) THEN

                    IF load = '1' THEN -- φορτωση τιμης

                        cnt_reg <= unsigned(data);

                    ELSIF start_stop = '1' THEN --Αυξηση μετρητη

                        cnt_reg <= cnt_reg + 1;

                    END IF;
                END IF;
        END PROCESS;

        count <= std_logic_vector(cnt_reg);

END Behavioral;

