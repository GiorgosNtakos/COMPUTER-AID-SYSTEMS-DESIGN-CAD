LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE fp32_pkg IS

-- =========================================================
-- IEEE-754 Single Precision basic widths
-- =========================================================

    CONSTANT FP32_WIDTH      : NATURAL :=  32;
    CONSTANT FP32_SIGN_WIDTH : NATURAL :=   1;
    CONSTANT FP32_EXP_WIDTH  : NATURAL :=   8;
    CONSTANT FP32_FRAC_WIDTH : NATURAL :=  23;

    -- Exponent bias for single precision
    CONSTANT FP32_EXP_BIAS   : NATURAL := 127;

-- =========================================================
-- Internal datapath widths
-- =========================================================

    -- Hidden bit + fraction = 1 + 23 = 24 bits
    CONSTANT FP32_MANT_WIDTH : NATURAL := FP32_FRAC_WIDTH + 1;

    -- Two extra bits on the left for safe signed/2's complement handling
    -- of normalized significands of the form 1.xxxxx
    -- [real sign][overflow carry][24-bit significand]
    CONSTANT FP32_TC_WIDTH : NATURAL := FP32_MANT_WIDTH + 2;

END PACKAGE fp32_pkg;

PACKAGE BODY fp32_pkg IS
END PACKAGE BODY fp32_pkg;
