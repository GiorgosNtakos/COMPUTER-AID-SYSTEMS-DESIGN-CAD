LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_pack IS
    PORT(
        -- Final normalized sign
        sign_i : IN STD_LOGIC;

        -- Final normalized exponent
        exp_i : IN UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);

        -- Final normalized significand (+ hidden bit)
        mant_i : IN UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

        -- IEEE-754 packed output
        fp_o : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_pack;

ARCHITECTURE rtl OF fp32_pack IS
BEGIN

    PROCESS(sign_i, exp_i, mant_i)

        VARIABLE fp_tmp : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

    BEGIN

        -- =================================
        -- |         Pack sign bit         |
        -- =================================
        fp_tmp(FP32_WIDTH-1) := sign_i;

        -- =================================
        -- |       Pack exponet field      |
        -- =================================
        fp_tmp(FP32_WIDTH-2 DOWNTO FP32_FRAC_WIDTH) := STD_LOGIC_VECTOR(exp_i);
        
        -- =================================
        -- |      Pack fraction field      |
        -- =================================
        fp_tmp(FP32_FRAC_WIDTH-1 DOWNTO 0) := STD_LOGIC_VECTOR(mant_i(FP32_FRAC_WIDTH-1 DOWNTO 0));

        -- Final packed fp word
        fp_o <= fp_tmp;

    END PROCESS;

END ARCHITECTURE rtl;