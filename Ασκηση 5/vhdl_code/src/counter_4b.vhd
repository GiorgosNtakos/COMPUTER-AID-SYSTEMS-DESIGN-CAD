LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter_4bits IS

    PORT (

        clk            :  IN STD_LOGIC; -- ρολοι   
        clr            :  IN STD_LOGIC; -- ασυγχρονος καθαρισμος
        start_stop     :  IN STD_LOGIC; -- enable counting
        load_flag      :  IN STD_LOGIC; -- enable parallel load
        data_in        :  IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- parallel input
        count_out      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- current value of counter

    );

END counter_4bits;

ARCHITECTURE Behavioral OF counter_4bits IS

    SIGNAL cnt_reg : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');

    BEGIN

        PROCESS(clk, clr)

            BEGIN

                IF clr = '1' THEN -- ασυγχρονο clear

                    cnt_reg <= (OTHERS => '0');

                ELSIF RISING_EDGE(clk) THEN

                    IF load_flag = '1' THEN -- παραλληλη φορτωση

                        cnt_reg <= UNSIGNED(data_in);

                    ELSIF start_stop = '1' THEN -- Αυξηση μετρητη

                        cnt_reg <= cnt_reg + 1;

                    END IF;
                END IF;
        END PROCESS;

        count_out <= STD_LOGIC_VECTOR(cnt_reg);

END Behavioral;
