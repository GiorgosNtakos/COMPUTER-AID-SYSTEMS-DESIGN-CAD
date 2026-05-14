LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;


ENTITY fp32_unpack IS
    PORT(
        x : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

        sign_o  : OUT STD_LOGIC;
        exp_o   : OUT UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
        frac_o  : OUT UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);
        mant_o  : OUT UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);
        is_zero : OUT STD_LOGIC  
    );
END ENTITY fp32_unpack;

ARCHITECTURE rtl OF fp32_unpack IS

    SIGNAL exp_int  : UNSIGNED(FP32_EXP_WIDTH-1  DOWNTO 0);
    SIGNAL frac_int : UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);

BEGIN

    -- Extract sign bit (MSB)
    sign_o <= x(FP32_WIDTH-1);

    -- Extract exponent field
    exp_int <= UNSIGNED(x(FP32_WIDTH-2 DOWNTO FP32_FRAC_WIDTH));

    -- Extract fraction field
    frac_int <= UNSIGNED(x(FP32_FRAC_WIDTH-1 DOWNTO 0));
    
    -- Forward raw fields
    exp_o  <= exp_int;
    frac_o <= frac_int;

    PROCESS(exp_int, frac_int)
    BEGIN

        -- Detect exact zero(exp = 0 and frac = 0)
        IF (exp_int = 0) AND (frac_int = 0) THEN
            is_zero <= '1';
            -- Set mantissa to zero to avoid incorrect propagation
            mant_o <=(others => '0');

        ELSE
            is_zero <= '0';
            -- Normalized numbers: implicit leading 1 (hidden bit)
            mant_o <= '1' & frac_int;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;
