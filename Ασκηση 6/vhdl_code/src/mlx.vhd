LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY xor_4_bits IS

    PORT (
        
        a   : IN  STD_LOGIC;
        b   : IN  STD_LOGIC;
        c   : IN  STD_LOGIC;
        d   : IN  STD_LOGIC;
        s   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);    
        dp  : OUT STD_LOGIC;
        an  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END xor_4_bits;

ARCHITECTURE rtl OF xor_4_bits IS

    SIGNAL o : STD_LOGIC;

    BEGIN

        -- XOR των 4 switches (SW0 - SW3)
        o <= a XOR b XOR c XOR d;


        WITH o SELECT

            s <= "1000000" WHEN '0',
                 "1111001" WHEN '1',
                 "1111111" WHEN OTHERS;

        dp  <= '0';
        an <= "1110";

END rtl;