LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY multiplier_2bits IS

    PORT (
        
        a0   : IN  STD_LOGIC;
        a1   : IN  STD_LOGIC;
        b0   : IN  STD_LOGIC;
        b1   : IN  STD_LOGIC;
        s   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    
        dp  : OUT STD_LOGIC;
        an  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END multiplier_2bits;

ARCHITECTURE rtl OF multiplier_2bits IS

    SIGNAL o    : UNSIGNED(3 DOWNTO 0);
    SIGNAL A, B : UNSIGNED(1 DOWNTO 0);

    BEGIN

        A <= a1 & a0;
        B <= b1 & b0;

        -- Ξ ΞΏΞ»Ξ»Ξ±Ο€Ξ»Ξ±ΟƒΞΉΞ±ΟƒΞΌΞΏΟ‚ Ο„Ο‰Ξ½ 2 Ξ±Ο�ΞΉΞΈΞΌΟ‰Ξ½ a & b
        o <= A * B;


        WITH o SELECT

            s <= "1000000" WHEN "0000", -- o = 0
                 "1111001" WHEN "0001", -- o = 1
                 "0100100" WHEN "0010", -- o = 2
                 "0110000" WHEN "0011", -- o = 3
                 "0011001" WHEN "0100", -- o = 4
                 "0000010" WHEN "0110", -- o = 6
                 "0010000" WHEN "1001", -- o = 9
                 "1111111" WHEN OTHERS;

        dp  <= '1';
        an <= "1110";

END rtl;