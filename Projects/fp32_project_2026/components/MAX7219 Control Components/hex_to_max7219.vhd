LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hex_to_max7219 IS
    PORT(
        hex_i : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        seg_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY hex_to_max7219;

ARCHITECTURE rtl OF hex_to_max7219 IS
BEGIN

    PROCESS(hex_i)
    BEGIN

        CASE hex_i IS
            --         b7 b6 b5 b4 b3 b2 b1 b0
            -- seg_o = DP  A  B  C  D  E  F  G
            WHEN "0000" => seg_o <= "01111110"; -- 0
            WHEN "0001" => seg_o <= "00110000"; -- 1
            WHEN "0010" => seg_o <= "01101101"; -- 2
            WHEN "0011" => seg_o <= "01111001"; -- 3
            WHEN "0100" => seg_o <= "00110011"; -- 4
            WHEN "0101" => seg_o <= "01011011"; -- 5
            WHEN "0110" => seg_o <= "01011111"; -- 6
            WHEN "0111" => seg_o <= "01110000"; -- 7
            WHEN "1000" => seg_o <= "01111111"; -- 8
            WHEN "1001" => seg_o <= "01111011"; -- 9
            WHEN "1010" => seg_o <= "01110111"; -- A
            WHEN "1011" => seg_o <= "00011111"; -- b
            WHEN "1100" => seg_o <= "01001110"; -- C
            WHEN "1101" => seg_o <= "00111101"; -- d
            WHEN "1110" => seg_o <= "01001111"; -- E
            WHEN "1111" => seg_o <= "01000111"; -- F

            WHEN OTHERS => seg_o <= "00000000"; -- blank

        END CASE;

    END PROCESS;

END ARCHITECTURE rtl;