LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_vector_rom IS
    PORT(
        addr : IN UNSIGNED(3 DOWNTO 0);

        a_o  : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
        b_o  : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_vector_rom;

ARCHITECTURE rtl OF fp32_vector_rom IS

    TYPE rom_t IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    
    CONSTANT rom : rom_t := (
        0 => x"3f80000040000000",
        1 => x"bf8000003f800000",
        2 => x"c2de800045155e00",
        3 => x"6b64b2356ac49214",
        4 => x"2ac492146ac49214",
        5 => x"bfc666663fc7ae14",
        6 => x"c565ee8b4565ee8a",
        7 => x"447a4efac47a1ccd",
        8 => x"0000000000000000",
        9 => x"38108900bb908900"
    );

    SIGNAL rom_word : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    PROCESS(addr)
    BEGIN

        IF addr <= 9 THEN
            rom_word <= rom(TO_INTEGER(addr));

        ELSE
            rom_word <= rom(0);

        END IF;

    END PROCESS;

    -- Upper 32 bits: operand A
    a_o <= rom_word(63 DOWNTO 32);

    --Lower 32 bits: operand B
    b_o <= rom_word(31 DOWNTO  0);

END ARCHITECTURE rtl;