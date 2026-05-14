LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_align IS
    PORT(
        exp_a  : IN UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        mant_a : IN UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

        exp_b  : IN UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        mant_b : IN UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

        exp_tmp_o      : OUT UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        mant_a_aligned : OUT UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);
        mant_b_aligned : OUT UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_align;

ARCHITECTURE rtl OF fp32_align IS
BEGIN

    PROCESS(exp_a, mant_a, exp_b, mant_b)
        VARIABLE shift_amt : integer;
    BEGIN
        -- Default assignments
        exp_tmp_o      <= exp_a;
        mant_a_aligned <= mant_a;
        mant_b_aligned <= mant_b;

        IF exp_a > exp_b THEN
            -- A has the larger exponent
            exp_tmp_o      <= exp_a;
            mant_a_aligned <= mant_a;

            shift_amt := TO_INTEGER(exp_a - exp_b);

            IF shift_amt >= FP32_MANT_WIDTH THEN
                mant_b_aligned <= (OTHERS => '0');
            ELSE
                mant_b_aligned <= SHIFT_RIGHT(mant_b, shift_amt);
            END IF;

        ELSIF exp_b > exp_a THEN
            -- B has the larger exponent
            exp_tmp_o      <= exp_b;
            mant_b_aligned <= mant_b;

            shift_amt := TO_INTEGER(exp_b - exp_a);

            IF shift_amt >= FP32_MANT_WIDTH THEN
                mant_a_aligned <= (OTHERS => '0');
            ELSE
                mant_a_aligned <= SHIFT_RIGHT(mant_a, shift_amt);
            END IF;

        ELSE
            -- Same exponents: no alignment shift needed
            exp_tmp_o      <= exp_a;
            mant_a_aligned <= mant_a;
            mant_b_aligned <= mant_b;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;