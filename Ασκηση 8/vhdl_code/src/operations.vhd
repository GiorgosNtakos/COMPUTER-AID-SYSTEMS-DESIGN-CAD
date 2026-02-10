LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY operations IS

    PORT (


        curr_dec     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        prev_dec     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        operator     : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
        divs_res     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        result       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        valid_result : OUT STD_LOGIC

    );

END operations;

ARCHITECTURE rtl OF operations IS

    BEGIN

    PROCESS(curr_dec, prev_dec, operator, divs_res)

        VARIABLE a, b : INTEGER RANGE 0 TO 9;
        VARIABLE r    : INTEGER RANGE 0 TO 9;

        BEGIN

            a := TO_INTEGER(UNSIGNED(curr_dec));
            b := TO_INTEGER(UNSIGNED(prev_dec));
            r := 0;
            valid_result <= '0';


            IF curr_dec = "1111" OR prev_dec = "1111" THEN

                r := 0;
                valid_result <= '0';

            ELSE

                CASE operator IS

                    WHEN "000" => 
                    
                        r := (a + b) mod 10; -- +
                        valid_result <= '1';

                    WHEN "001" => 

                        IF a >= b THEN 

                            r := (a - b); -- -

                        ELSE 

                            r := 0;

                        END IF;

                        valid_result <= '1';


                    WHEN "010" => 
                    
                        r := (a * b) mod 10; -- *
                        valid_result <= '1';

                    WHEN "011" =>

                        r := TO_INTEGER(UNSIGNED(divs_res));
                        valid_result <= '1';

                    WHEN OTHERS => 
                    
                        r := 0; -- no op
                        valid_result <= '0';

                END CASE;

            END IF;

            result <= STD_LOGIC_VECTOR(TO_UNSIGNED(r,4));

        END PROCESS;

END rtl;