LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY top_fp32_basys3 IS
    PORT(
        clk100 : IN STD_LOGIC; -- Basys3 100 MHz clock
        rst_sw : IN STD_LOGIC; -- Use SW0 as reset
        btn_c  : IN STD_LOGIC; -- Use BTNC to advance ROM address
        
        led    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

        seg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        an     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        dp     : OUT STD_LOGIC
    );
END ENTITY top_fp32_basys3;

ARCHITECTURE rtl OF top_fp32_basys3 IS

    SIGNAL btn_pulse : STD_LOGIC;

    SIGNAL rom_addr  : UNSIGNED(3 DOWNTO 0);

    SIGNAL rom_a : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
    SIGNAL rom_b : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

    SIGNAL fp_result : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

BEGIN

    -- =====================================
    -- |       PUSH BUTTON DEBOUNCE        |
    -- ===================================== 
    debounce_inst : ENTITY work.debounce
        PORT MAP(
            fclk        => clk100,
            rst         => rst_sw,
            push_button => btn_c,
            pulse       => btn_pulse
        );

    -- ==========================================
    -- |     ADDRESS COUNTER for ROM VECTORS    |
    -- ==========================================
    addr_counter_inst : ENTITY work.addr_counter_mod10
        PORT MAP(
            clk     => clk100,
            rst     => rst_sw,
            pulse_i => btn_pulse,
            addr_o  => rom_addr
        );

    -- ====================================================
    -- |     ROM CONTAINING FP32 OPERAND PAIRS VECTORS    |
    -- ====================================================
    rom_inst : ENTITY work.fp32_vector_rom
        PORT MAP(
            addr => rom_addr,
            a_o  => rom_a,
            b_o  => rom_b
        );

    -- ==========================================
    -- |      2-STAGE PIPELINED FP32 ADDER      |
    -- ==========================================
    adder_inst : ENTITY work.fp32_add_2stage
        PORT MAP(
            clk      => clk100,
            rst      => rst_sw,
            a_i      => rom_a,
            b_i      => rom_b,
            result_o => fp_result
        );

    -- ==========================================
    -- |     SHOW ROM ADDRESS ON LEDS[3:0]      |
    -- ==========================================
    led(3 DOWNTO 0) <= STD_LOGIC_VECTOR(rom_addr);

    -- ======================================================
    -- |     ZERO FLAG, SIGN FLAG, RESET FLAG, PULSE FLAG   |
    -- ======================================================
    led(15) <= fp_result(31); -- Sign bit
    led(14) <= '1' WHEN fp_result = x"00000000" ELSE '0'; -- Result is zero
    led(13) <= rst_sw; -- Reset on = 1

    -- Rest leds = 0
    led(12 DOWNTO 4) <= (OTHERS => '0');

    -- ========================================================================
    -- |     SHOW 4 MOST SIGNIFICANT HEX DIGITS OF RESULT ON 7-SEG DISPLAY    |
    -- ========================================================================
    sevenseg_inst : ENTITY work.sevenseg_driver
        PORT MAP(
            clk    => clk100,
            rst    => rst_sw,

            hex3_i => fp_result(31 DOWNTO 28),
            hex2_i => fp_result(27 DOWNTO 24),
            hex1_i => fp_result(23 DOWNTO 20),
            hex0_i => fp_result(19 DOWNTO 16),

            seg_o  => seg,
            an_o   => an
        );

    -- Decimal Point off, active-low
    dp <= '1';

END ARCHITECTURE rtl;