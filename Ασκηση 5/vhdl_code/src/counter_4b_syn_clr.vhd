LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter_4bits_syn_clr IS

    PORT (

        clk            :  IN STD_LOGIC; -- ρολοι   
        clr            :  IN STD_LOGIC; -- ασυγχρονος καθαρισμος
        start_stop     :  IN STD_LOGIC; -- enable counting
        load_flag      :  IN STD_LOGIC; -- enable parallel load
        data_in        :  IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- parallel input
        count_out      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- current value of counter

    );

END counter_4bits_syn_clr;

ARCHITECTURE Behavioral OF counter_4bits_syn_clr IS

    SIGNAL cnt_reg : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');

    BEGIN

        PROCESS(clk)

            BEGIN

                IF clr = '1' THEN -- ασυγχρονο clear

                    cnt_reg <= (OTHERS => '0') after 20 ns;

                ELSIF RISING_EDGE(clk) THEN

                    IF load_flag = '1' THEN -- παραλληλη φορτωση

                        cnt_reg <= UNSIGNED(data_in) after 20 ns;

                    ELSIF start_stop = '1' THEN -- Αυξηση μετρητη

                        cnt_reg <= cnt_reg + 1 after 20 ns;

                    END IF;
                END IF;
        END PROCESS;

        count_out <= STD_LOGIC_VECTOR(cnt_reg);

END Behavioral;
