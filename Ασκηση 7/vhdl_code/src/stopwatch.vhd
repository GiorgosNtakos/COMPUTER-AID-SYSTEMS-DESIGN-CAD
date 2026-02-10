LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY stopwatch IS

    PORT(

        clk           : IN  STD_LOGIC;
        stp           : IN  STD_LOGIC;
        true_tenths   : IN  UNSIGNED(3 DOWNTO 0);
        true_ts       : IN  UNSIGNED(2 DOWNTO 0);
        true_ss       : IN  UNSIGNED(3 DOWNTO 0);
        output_ts     : OUT UNSIGNED(2 DOWNTO 0);
        output_ss     : OUT UNSIGNED(3 DOWNTO 0);
        output_tenths : OUT UNSIGNED(3 DOWNTO 0)    

    );

END ENTITY;

ARCHITECTURE rtl OF stopwatch IS

    SIGNAL ts_reg     : UNSIGNED(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ss_reg     : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tenths_reg : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');

    BEGIN

        PROCESS(clk)

            BEGIN

                IF RISING_EDGE(clk) THEN

                    IF stp = '1' THEN

                        output_ss     <= ss_reg;
                        output_ts     <= ts_reg;
                        output_tenths <= tenths_reg;

                    ELSE

                        ts_reg     <= true_ts;
                        ss_reg     <= true_ss;
                        tenths_reg <= true_tenths; 

                    END IF;

                END IF;
                
        END PROCESS;


    output_ss <=     ss_reg;
    output_ts <=     ts_reg;
    output_tenths <= tenths_reg;

END rtl;

    
