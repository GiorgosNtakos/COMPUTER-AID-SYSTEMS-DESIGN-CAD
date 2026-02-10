LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY signed_multiplier_2bits IS 

    PORT ( 

        a0 : IN STD_LOGIC; 
        a1 : IN STD_LOGIC; 
        b0 : IN STD_LOGIC; 
        b1 : IN STD_LOGIC; 
        s : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
        dp : OUT STD_LOGIC; 
        an : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 

    ); 

END signed_multiplier_2bits;

ARCHITECTURE rtl OF signed_multiplier_2bits IS 

    SIGNAL o    : SIGNED(3 DOWNTO 0); 
    SIGNAL A, B : SIGNED(1 DOWNTO 0); 

    BEGIN 

        A <= a1 & a0; 
        B <= b1 & b0; 

        -- Πολλαπλασιασμος των 2 αριθμων a & b 
        o <= A * B; 

        WITH o SELECT 
        s <= "1000000" WHEN "0000", -- o = 0 
             "1111001" WHEN "0001", -- o = +1 
             "0100100" WHEN "0010", -- o = +2 
             "0011001" WHEN "0100", -- o = +4 
             "1111001" WHEN "1111", -- o = -1 
             "0100100" WHEN "1110", -- o = -2 
             "1111111" WHEN OTHERS; 

            -- προσημο dp
            dp <= '0' WHEN o(3) = '1' ELSE  '1'; 

            an <= "1110"; 

END rtl;