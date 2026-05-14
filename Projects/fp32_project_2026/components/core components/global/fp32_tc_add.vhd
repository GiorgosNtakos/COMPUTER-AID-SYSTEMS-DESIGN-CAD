LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_tc_add IS
    PORT(
        a_tc   : IN  SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
        b_tc   : IN  SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

        sum_tc : OUT SIGNED(FP32_TC_WIDTH-1 DOWNTO 0)

    );
END ENTITY fp32_tc_add;

ARCHITECTURE rtl OF fp32_tc_add IS
BEGIN

    -- Add 2 alinged significands in two's complement form.
    -- Since both operands are signed, this handles both addition
    -- and subtraction cases automically
    sum_tc <= a_tc + b_tc;

END ARCHITECTURE rtl;
