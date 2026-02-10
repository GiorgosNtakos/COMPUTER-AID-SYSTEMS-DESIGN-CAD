LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY scancode_converter IS

    PORT (

        scancode : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        decimal  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END scancode_converter;

ARCHITECTURE rtl OF scancode_converter IS


    BEGIN

    WITH scancode SELECT

        decimal <= "0000" WHEN x"45",
                   "0001" WHEN x"16",
                   "0010" WHEN x"1E",
                   "0011" WHEN x"26",
                   "0100" WHEN x"25",
                   "0101" WHEN x"2E",
                   "0110" WHEN x"36",
                   "0111" WHEN x"3D",
                   "1000" WHEN x"3E",
                   "1001" WHEN x"46",
                   "1111" WHEN OTHERS;

END rtl;