LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY divider IS

    PORT (

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;
        dividend : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        divisor  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        result   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END divider;

ARCHITECTURE rtl OF divider IS

    SIGNAL div_res_reg  : UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL counter      : UNSIGNED(3 DOWNTO 0) := "0001"; 
    SIGNAL temp         : UNSIGNED(7 DOWNTO 0);         

    BEGIN

    PROCESS(clk,rst)

        BEGIN

            IF rst = '1' THEN

                counter     <= "0001";
                div_res_reg <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN

                IF divisor = "0001" THEN
                
                    div_res_reg <= unsigned(dividend);

                ELSIF divisor = "0000" THEN

                    div_res_reg <= "0000";

                ELSIF UNSIGNED(dividend) < UNSIGNED(divisor) THEN

                    div_res_reg <= (OTHERS => '0');

                ELSIF UNSIGNED(dividend) = UNSIGNED(divisor) THEN

                    div_res_reg <= "0001";

                ELSIF UNSIGNED(dividend) > UNSIGNED(divisor) THEN

                    IF temp >= UNSIGNED(divisor) THEN

                        counter <= counter + 1;
                    
                    ELSE

                        div_res_reg <= counter;
                        counter     <= "0001"; -- reset counter για επ�?μενη π�?άξη

                    END IF;

                END IF;

            END IF;

        END PROCESS;

        temp   <= UNSIGNED(dividend) - (counter * UNSIGNED(divisor));

        result <= STD_LOGIC_VECTOR(div_res_reg);

END rtl;