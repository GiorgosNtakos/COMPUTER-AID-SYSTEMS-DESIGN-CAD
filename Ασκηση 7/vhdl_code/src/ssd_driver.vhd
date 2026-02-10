LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY seg_mux IS

    PORT(

        clk   : IN  STD_LOGIC; --100 Mhz
        right : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        left  : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        an    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        seg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

    );

END seg_mux;

ARCHITECTURE rtl OF seg_mux IS

    SIGNAL div_cnt : UNSIGNED(14 DOWNTO 0) := (OTHERS => '0'); -- διαιρετης
    SIGNAL sel     : STD_LOGIC := '0';

    BEGIN

        PROCESS(clk)
        BEGIN

            IF RISING_EDGE(clk) THEN

                IF div_cnt = 24999 THEN  -- overflow = toggle επιλογής
                    
                    sel <= not sel; -- εναλλαγή ψηφίου (~ 2ΚΗz)
                    div_cnt <= (OTHERS => '0');

                ELSE

                    div_cnt <= div_cnt + 1;

                END IF;

            END IF;
        
        END PROCESS;


        -- ενεργοποιηση ψηφίου & segments
        WITH sel SELECT

            an <= "1110" WHEN '0', -- δεξι(μοναδες)
                  "1101" WHEN '1', -- αριστερο(δεκαδες)
                  "1111" WHEN OTHERS;

            seg <= right WHEN sel = '0' ELSE
                   left  WHEN sel = '1' ELSE
                   "1111111";

END rtl;