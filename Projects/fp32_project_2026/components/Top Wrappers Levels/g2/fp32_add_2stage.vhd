LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_add_2stage IS
    PORT(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        -- IEEE-754 FP32 Inputs
        a_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
        b_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

        -- IEEE-754 FP32 result
        result_o : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_add_2stage;

ARCHITECTURE rtl OF fp32_add_2stage IS

    -- =====================================
    -- |            SAMPLE INPUTS          |
    -- =====================================
    SIGNAL a_reg : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
    SIGNAL b_reg : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);  

    -- =====================================
    -- |      STAGE 1 INTERNAL SIGNALS     |
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

    SIGNAL sum_is_zero_s1 : STD_LOGIC;

    SIGNAL exp_tmp_s1 : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
    
    SIGNAL mant_a_align : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);
    SIGNAL mant_b_align : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

    SIGNAL a_tc_s1 : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
    SIGNAL b_tc_s1 : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

    SIGNAL sum_tc_s1: SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

    -- Pipeline registers between S1 and S2
    SIGNAL sum_tc_reg        : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);


    SIGNAL exp_tmp_reg     : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
    SIGNAL sum_is_zero_reg : STD_LOGIC;

    -- =====================================
    -- |           STAGE 2 SIGNALS         |
    -- =====================================
    SIGNAL sum_tc : SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);


    SIGNAL result_sign : STD_LOGIC; 
    SIGNAL result_mag  : UNSIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
    
    SIGNAL lead_pos : INTEGER RANGE 0 TO FP32_TC_WIDTH-1;

    SIGNAL norm_sign : STD_LOGIC;
    SIGNAL norm_exp  : UNSIGNED(FP32_EXP_WIDTH-1 DOWNTO 0);
    SIGNAL norm_mant : UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

    SIGNAL packed_result : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

    SIGNAL result_reg: STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

BEGIN

    -- =====================================
    -- |       SAMPLE INPUTS PROCESS       |
    -- =====================================
    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN

            IF rst = '1' THEN
                a_reg      <= (OTHERS => '0');
                b_reg      <= (OTHERS => '0');
            
            ELSE
                -- Sample inputs on rising edge
                a_reg <= a_i;
                b_reg <= b_i;

            END IF;

        END IF;
    END PROCESS;

    -- =================================================================
    -- |        S1 : UNPACK, ZERO DETECT, ALIGN, SIGN-MAG TO TC, ADD   |
    -- =================================================================
    unpack_a_inst : ENTITY work.fp32_unpack
        PORT MAP(
            x       => a_reg,
            sign_o  => sign_a,
            exp_o   => exp_a,
            frac_o  => frac_a,
            mant_o  => mant_a,
            is_zero => a_is_zero
        );

    unpack_b_inst : ENTITY work.fp32_unpack
        PORT MAP(
            x       => b_reg,
            sign_o  => sign_b,
            exp_o   => exp_b,
            frac_o  => frac_b,
            mant_o  => mant_b,
            is_zero => b_is_zero
        );

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

            sum_is_zero => sum_is_zero_s1
        );

    align_inst : ENTITY work.fp32_align
        PORT MAP(
            exp_a          => exp_a,
            mant_a         => mant_a,

            exp_b          => exp_b,
            mant_b         => mant_b,

            exp_tmp_o      => exp_tmp_s1,

            mant_a_aligned => mant_a_align,
            mant_b_aligned => mant_b_align
        );

    tc_a_inst : ENTITY work.fp32_signmag_to_tc
        PORT MAP(
            sign_i => sign_a,
            mant_i => mant_a_align,

            tc_o   => a_tc_s1
        );

    tc_b_inst : ENTITY work.fp32_signmag_to_tc
        PORT MAP(
            sign_i => sign_b,
            mant_i => mant_b_align,

            tc_o   => b_tc_s1
        );

    add_inst : ENTITY work.fp32_tc_add
        PORT MAP(
            a_tc   => a_tc_s1,
            b_tc   => b_tc_s1,

            sum_tc => sum_tc_s1
        );

    -- =====================================
    -- |         PIPELINE REGISTERS        |
    -- =====================================
    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN

            IF rst = '1' THEN
                sum_tc_reg      <= (OTHERS => '0');
                exp_tmp_reg     <= (OTHERS => '0');
                sum_is_zero_reg <= '0';
            
            ELSE
                sum_tc_reg      <= sum_tc_s1;
                exp_tmp_reg     <= exp_tmp_s1;
                sum_is_zero_reg <= sum_is_zero_s1;

            END IF;

        END IF;
    END PROCESS;

    -- =================================================================
    -- |         S2: TC TO SIGN-MAG, LOD, NORMALIZE, PACK              |
    -- =================================================================
    tc_to_sm_inst : ENTITY work.fp32_tc_to_signmag
        PORT MAP(
            sum_tc => sum_tc_reg,

            sign_o => result_sign,
            mag_o  => result_mag
        );
    
    lod_inst : ENTITY work.fp32_lod
        PORT MAP(
            mag_i => result_mag,

            lead_pos => lead_pos
        );

    normalize_inst : ENTITY work.fp32_normalize
        PORT MAP(
            sign_i => result_sign,
            exp_i  => exp_tmp_reg,
            mag_i  => result_mag,

            lead_pos_i => lead_pos,

            sign_o => norm_sign,
            exp_o  => norm_exp,
            mant_o => norm_mant
        );

    pack_inst : ENTITY work.fp32_pack
        PORT MAP(
            sign_i => norm_sign,
            exp_i  => norm_exp,
            mant_i => norm_mant,

            fp_o => packed_result
        );

    -- =====================================
    -- |          OUTPUT REGISTERS         |
    -- =====================================
    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN

            IF rst = '1' THEN
                result_reg <= (OTHERS => '0');
            
            ELSE
                -- Early zero bypass propagated through pipeline register
                IF sum_is_zero_reg = '1' THEN
                    result_reg <= (OTHERS => '0');
                ELSE
                    result_reg <= packed_result;
                END IF;

            END IF;

        END IF;
    END PROCESS;

    result_o <= result_reg;

END ARCHITECTURE rtl;
