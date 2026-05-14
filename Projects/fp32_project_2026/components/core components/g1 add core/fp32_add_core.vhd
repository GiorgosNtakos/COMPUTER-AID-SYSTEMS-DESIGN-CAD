LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_add_core IS
    PORT(
        -- IEEE-754 FP32 Inputs
        a_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
        b_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

        -- IEEE-754 FP32 result
        result_o : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_add_core;

ARCHITECTURE structural OF fp32_add_core IS

    -- =====================================
    -- |          UNPACK SIGNALS           |
    -- =====================================
    SIGNAL sign_a : STD_LOGIC;
    SIGNAL sign_b : STD_LOGIC;

    SIGNAL exp_a : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
    SIGNAL exp_b : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);

    SIGNAL frac_a : UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);
    SIGNAL frac_b : UNSIGNED(FP32_FRAC_WIDTH-1 DOWNTO 0);

    SIGNAL mant_a : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);
    SIGNAL mant_b : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

    SIGNAL a_is_zero : STD_LOGIC;
    SIGNAL b_is_zero : STD_LOGIC;

    -- =====================================
    -- |            ZERO DETECT            |
    -- =====================================
    SIGNAL sum_is_zero : STD_LOGIC;

    -- =====================================
    -- |            ALIGN STAGE            |
    -- =====================================
    SIGNAL exp_tmp : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
    
    SIGNAL mant_a_align : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);
    SIGNAL mant_b_align : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

    -- =====================================
    -- |        2's COMPLEMENT STAGE       |
    -- =====================================
    SIGNAL a_tc : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
    SIGNAL b_tc : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

    -- =====================================
    -- |            ADDER STAGE            |
    -- =====================================
    SIGNAL sum_tc : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

    -- =====================================
    -- |       BACK TO SIGN-MAGNITUDE      |
    -- =====================================
    SIGNAL result_sign : STD_LOGIC; 
    SIGNAL result_mag  : UNSIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
    
    -- =====================================
    -- |       LEADING-ONE DETECTOR        |
    -- =====================================
    SIGNAL lead_pos : INTEGER RANGE 0 TO FP32_TC_WIDTH-1;

    -- =====================================
    -- |          NORMALIZE STAGE          |
    -- =====================================
    SIGNAL norm_sign : STD_LOGIC;

    SIGNAL norm_exp : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);

    SIGNAL norm_mant : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

    -- =====================================
    -- |         PACKED FP32 RESULT        |
    -- =====================================
    SIGNAL packed_result : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

BEGIN

    -- =====================================
    -- |               UNPACK A            |
    -- =====================================
    unpack_a_inst : ENTITY work.fp32_unpack
        PORT MAP(
            x       => a_i,
            sign_o  => sign_a,
            exp_o   => exp_a,
            frac_o  => frac_a,
            mant_o  => mant_a,
            is_zero => a_is_zero
        );

    -- =====================================
    -- |               UNPACK B            |
    -- =====================================
    unpack_b_inst : ENTITY work.fp32_unpack
        PORT MAP(
            x       => b_i,
            sign_o  => sign_b,
            exp_o   => exp_b,
            frac_o  => frac_b,
            mant_o  => mant_b,
            is_zero => b_is_zero
        );

    -- =====================================
    -- |       EARLY ZERO DETECTION        |
    -- =====================================
    zero_detect_inst : ENTITY work.fp32_zero_detect
        PORT MAP(
            sign_a      => sign_a,
            exp_a       => exp_a,
            frac_a      => frac_a,
            a_is_zero   => a_is_zero,

            sign_b      => sign_b,
            exp_b       => exp_b,
            frac_b      => frac_b,
            b_is_zero   => b_is_zero,

            sum_is_zero => sum_is_zero
        );

    -- =====================================
    -- |         ALIGN SIGNIFICANDS        |
    -- =====================================
    align_inst : ENTITY work.fp32_align
        PORT MAP(
            exp_a          => exp_a,
            mant_a         => mant_a,

            exp_b          => exp_b,
            mant_b         => mant_b,

            exp_tmp_o      => exp_tmp,

            mant_a_aligned => mant_a_align,
            mant_b_aligned => mant_b_align
        );

    -- =====================================
    -- |     CONVER A to 2's COMPLEMENT    |
    -- =====================================
    tc_a_inst : ENTITY work.fp32_signmag_to_tc
        PORT MAP(
            sign_i => sign_a,
            mant_i => mant_a_align,

            tc_o   => a_tc
        );

    -- =====================================
    -- |     CONVER B to 2's COMPLEMENT    |
    -- =====================================
    tc_b_inst : ENTITY work.fp32_signmag_to_tc
        PORT MAP(
            sign_i => sign_b,
            mant_i => mant_b_align,

            tc_o   => b_tc
        );

    -- =====================================
    -- |           SIGN ADDITION           | 
    -- =====================================
    add_inst : ENTITY work.fp32_tc_add
        PORT MAP(
            a_tc   => a_tc,
            b_tc   => b_tc,

            sum_tc => sum_tc
        );

    -- =========================================
    -- | CONVERT RESULT BACK TO SIGN-MAGNITUDE |
    -- =========================================
    tc_to_sm_inst : ENTITY work.fp32_tc_to_signmag
        PORT MAP(
            sum_tc => sum_tc,

            sign_o => result_sign,
            mag_o  => result_mag
        );
    
    -- =====================================
    -- |        LEADING-ONE DETECTOR       |
    -- =====================================
    lod_inst : ENTITY work.fp32_lod
        PORT MAP(
            mag_i => result_mag,

            lead_pos => lead_pos
        );

    -- =====================================
    -- |          NORMALIZE RESULT         |
    -- =====================================
    normalize_inst : ENTITY work.fp32_normalize
        PORT MAP(
            sign_i => result_sign,
            exp_i  => exp_tmp,
            mag_i  => result_mag,

            lead_pos_i => lead_pos,

            sign_o => norm_sign,
            exp_o  => norm_exp,
            mant_o => norm_mant
        );

    -- =====================================
    -- |     PACK FINAL IEEE-754 RESULT    |
    -- =====================================
    pack_inst : ENTITY work.fp32_pack
        PORT MAP(
            sign_i => norm_sign,
            exp_i  => norm_exp,
            mant_i => norm_mant,

            fp_o => packed_result
        );
    
    -- =====================================
    -- |      FINAL OUTPUT SELECTION       |
    -- =====================================
    PROCESS(sum_is_zero, packed_result)
    BEGIN

        -- Early bypass for exact zero result
        IF sum_is_zero = '1' THEN
            result_o <= (OTHERS => '0');

        ELSE
            result_o <= packed_result;

        END IF;

    END PROCESS;

END ARCHITECTURE structural;