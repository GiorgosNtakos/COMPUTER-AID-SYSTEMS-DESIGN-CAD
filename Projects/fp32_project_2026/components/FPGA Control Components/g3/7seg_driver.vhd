LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sevenseg_driver IS
    PORT(
        clk : STD_LOGIC;
        rst : STD_LOGIC;

        hex3_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex2_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex1_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex0_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        an_o  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY sevenseg_driver;

ARCHITECTURE rtl OF sevenseg_driver IS

    SIGNAL refresh_cnt : UNSIGNED(19 DOWNTO 0) := (OTHERS => '0');
    SIGNAL digit_sel   : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL current_hex : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Refresh counter for display multiplexing
    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN
            IF rst = '1' THEN
                refresh_cnt <= (OTHERS => '0');

            ELSE
                refresh_cnt <= refresh_cnt + 1;

            END IF;
        END IF;
    END PROCESS;

    -- Use upper counter bits as digit selector
    digit_sel <= STD_LOGIC_VECTOR(refresh_cnt(19 DOWNTO 18));

    -- Select active digit and corresponding hex nibble
    PROCESS(digit_sel, hex3_i, hex2_i, hex1_i, hex0_i)
    BEGIN
        CASE digit_sel IS
            WHEN "00" =>
                an_o    <= "1110"; -- AN0 active
                current_hex <= hex0_i;
            
            WHEN "01" =>
                an_o    <= "1101"; -- AN1 active
                current_hex <= hex1_i;

            WHEN "10" =>
                an_o    <= "1011"; -- AN2 active
                current_hex <= hex2_i;

            WHEN OTHERS =>
                an_o    <= "0111"; -- AN3 active
                current_hex <= hex3_i;
        END CASE;
    END PROCESS;

    -- Hex to 7-segment decoder
    hex_decoder_inst : ENTITY work.hex_to_7seg
        PORT MAP(
            hex_i => current_hex,
            seg_o => seg_o
        );

END ARCHITECTURE rtl;
