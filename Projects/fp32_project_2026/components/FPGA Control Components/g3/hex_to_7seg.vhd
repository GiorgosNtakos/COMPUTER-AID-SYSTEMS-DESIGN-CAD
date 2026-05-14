LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hex_to_7seg IS
    PORT(
        hex_i : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY hex_to_7seg;

ARCHITECTURE rtl OF hex_to_7seg IS
BEGIN

    PROCESS(hex_i)
    BEGIN

        CASE hex_i IS

            --abcdefg
            WHEN "0000" => seg_o <= "0000001"; -- 0
            WHEN "0001" => seg_o <= "1001111"; -- 1
            WHEN "0010" => seg_o <= "0010010"; -- 2
            WHEN "0011" => seg_o <= "0000110"; -- 3
            WHEN "0100" => seg_o <= "1001100"; -- 4
            WHEN "0101" => seg_o <= "0100100"; -- 5
            WHEN "0110" => seg_o <= "0100000"; -- 6
            WHEN "0111" => seg_o <= "0001111"; -- 7
            WHEN "1000" => seg_o <= "0000000"; -- 8
            WHEN "1001" => seg_o <= "0000100"; -- 9
            WHEN "1010" => seg_o <= "0001000"; -- A
            WHEN "1011" => seg_o <= "1100000"; -- b
            WHEN "1100" => seg_o <= "0110001"; -- C
            WHEN "1101" => seg_o <= "1000010"; -- d
            WHEN "1110" => seg_o <= "0110000"; -- E
            WHEN "1111" => seg_o <= "0111000"; -- F

            WHEN OTHERS => seg_o <= "1111111";

        END CASE;

    END PROCESS;

END ARCHITECTURE rtl;