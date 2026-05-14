LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;


ENTITY fp32_zero_detect IS
    PORT(
        sign_a    : IN STD_LOGIC;
        exp_a     : IN UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        frac_a    : IN UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);
        a_is_zero : IN STD_LOGIC;

        sign_b    : IN STD_LOGIC;
        exp_b     : IN UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        frac_b    : IN UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);
        b_is_zero : IN STD_LOGIC;

        sum_is_zero : OUT STD_LOGIC
    );
END ENTITY fp32_zero_detect;

ARCHITECTURE rtl of fp32_zero_detect IS
BEGIN

    PROCESS(sign_a, exp_a, frac_a, a_is_zero,
            sign_b, exp_b, frac_b, b_is_zero)
    BEGIN

        -- Default Output
        sum_is_zero <= '0';

        -- Case 1: Both Inputs are exactly zero
        IF(a_is_zero = '1') AND (b_is_zero = '1') THEN
            sum_is_zero <= '1';

        -- Case 2: Equal magnitude and opposite signs
        ELSIF (exp_a = exp_b) AND (frac_a = frac_b) AND (sign_a /= sign_b) THEN
            sum_is_zero <= '1';
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;