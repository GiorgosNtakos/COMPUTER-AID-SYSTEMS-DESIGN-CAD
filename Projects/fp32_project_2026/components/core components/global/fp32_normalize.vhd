LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_normalize IS
    PORT(
        -- Sign of the result
        sign_i    : IN STD_LOGIC;

        -- Temporary Exponent after alignment
        exp_i : IN UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);

        -- Unnormalized magnitude from adder datapath
        mag_i : IN UNSIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

        -- Position of leading '1' from LOD component
        lead_pos_i : IN INTEGER RANGE 0 TO FP32_TC_WIDTH-1;

        --Normlized Outputs
        sign_o : OUT STD_LOGIC;
        exp_o  : OUT UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
        mant_o : OUT UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_normalize;

ARCHITECTURE rtl OF fp32_normalize IS

    CONSTANT TARGET_POS : INTEGER := FP32_TC_WIDTH - 3;

BEGIN

    PROCESS(sign_i, exp_i, mag_i, lead_pos_i)

        VARIABLE mag_work  : UNSIGNED(FP32_TC_WIDTH-1  DOWNTO 0);
        VARIABLE exp_work  : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);

        VARIABLE shift_amt : INTEGER;

    BEGIN

        -- Pass sign unchanged
        sign_o <= sign_i;

        --Working copies
        mag_work := mag_i;
        exp_work := exp_i;

        -- =============================================
        -- | Safety check for zero magnitude           |
        -- | Normally prevented by fp32_zero_detect,   |
        -- | but kept for robustness.                  |
        -- =============================================
        IF mag_i = 0 THEN

            exp_o  <= (OTHERS => '0');
            mant_o <= (OTHERS => '0');

        ELSE

            -- =============================================
            -- | Case 1: Overflow after addition           |
            -- | Example: 10.xxxxx...x                     |
            -- =============================================
            IF lead_pos_i > TARGET_POS THEN

                shift_amt := lead_pos_i - TARGET_POS;
                
                mag_work := shift_right(mag_work, shift_amt);

                exp_work := exp_work + to_unsigned(shift_amt, FP32_EXP_WIDTH);

            -- =============================================
            -- | Case 2: Leading 0s after subtraction      |
            -- | Example: 0.0001xxxx...x                   |
            -- =============================================
            ELSIF lead_pos_i < TARGET_POS THEN

                shift_amt := TARGET_POS - lead_pos_i;

                mag_work := shift_left(mag_work, shift_amt);

                exp_work := exp_work - to_unsigned(shift_amt, FP32_EXP_WIDTH);

            END IF;

             -- ============================================
            -- | Remove extra left bit and keep normalized |
            -- | 24-bit significand (+ hidden bit)         |
            -- =============================================
            mant_o <= mag_work(FP32_MANT_WIDTH-1 DOWNTO 0);

            -- Output corrected exponent
            exp_o <= exp_work;

            END IF;
        END PROCESS;

END ARCHITECTURE rtl;