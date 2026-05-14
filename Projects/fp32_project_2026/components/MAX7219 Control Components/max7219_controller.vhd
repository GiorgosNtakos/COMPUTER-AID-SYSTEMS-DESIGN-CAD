LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY max7219_controller IS
    PORT(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        tick_i : IN STD_LOGIC;

        value_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        max_cs  : OUT STD_LOGIC;
        max_clk : OUT STD_LOGIC;
        max_din : OUT STD_LOGIC
    );
END ENTITY max7219_controller;

ARCHITECTURE rtl OF max7219_controller IS

    SIGNAL reg_index : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');

    SIGNAL sender_start : STD_LOGIC := '0';
    SIGNAL sender_busy  : STD_LOGIC;
    SIGNAL sender_done  : STD_LOGIC;

    SIGNAL sender_addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sender_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL seg_digit0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit6 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL seg_digit7 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- Convert each hex nibble of the 32 bit value to MAX7219 segment pattern.
    -- Digit 7 is the MS hex digit.
    hex0_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(3 DOWNTO 0),
            seg_o => seg_digit0
        );
    
    hex1_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(7 DOWNTO 4),
            seg_o => seg_digit1
        );

    hex2_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(11 DOWNTO 8),
            seg_o => seg_digit2
        );

    hex3_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(15 DOWNTO 12),
            seg_o => seg_digit3
        );

    hex4_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(19 DOWNTO 16),
            seg_o => seg_digit4
        );

    hex5_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(23 DOWNTO 20),
            seg_o => seg_digit5
        );

    hex6_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(27 DOWNTO 24),
            seg_o => seg_digit6
        );

    hex7_inst : ENTITY work.hex_to_max7219
        PORT MAP(
            hex_i => value_i(31 DOWNTO 28),
            seg_o => seg_digit7
        );

        -- Low-lever serial sender(SPI)
        sender_inst : ENTITY work.max7219_sender
            PORT MAP(
                clk     => clk,
                rst     => rst,
                tick_i => tick_i,

                start_i => sender_start,
                addr_i  => sender_addr,
                data_i  => sender_data,

                busy_o => sender_busy,
                done_o => sender_done,

                max_cs  => max_cs,
                max_clk => max_clk, 
                max_din => max_din
            );

    -- Select which MAX7219 register/data pair to send
    PROCESS(reg_index,
            seg_digit0, seg_digit1, seg_digit2, seg_digit3,
            seg_digit4, seg_digit5, seg_digit6, seg_digit7)
    BEGIN

        CASE reg_index IS

            -- No-op register
            WHEN x"0" =>
                sender_addr  <= x"0";
                sender_data <= x"00";

            -- Digit Registers
             WHEN x"1" =>
                sender_addr  <= x"1";
                sender_data <= seg_digit0;

             WHEN x"2" =>
                sender_addr  <= x"2";
                sender_data <= seg_digit1;

             WHEN x"3" =>
                sender_addr  <= x"3";
                sender_data <= seg_digit2;

             WHEN x"4" =>
                sender_addr  <= x"4";
                sender_data <= seg_digit3;

             WHEN x"5" =>
                sender_addr  <= x"5";
                sender_data <= seg_digit4;

             WHEN x"6" =>
                sender_addr  <= x"6";
                sender_data <= seg_digit5;

             WHEN x"7" =>
                sender_addr  <= x"7";
                sender_data <= seg_digit6;

             WHEN x"8" =>
                sender_addr  <= x"8";
                sender_data <= seg_digit7;

            -- Decode mode: no decode for all digits
            WHEN x"9" =>
                sender_addr  <= x"9";
                sender_data <= x"00";

            -- Intensity: medium brightness
            WHEN x"A" =>
                sender_addr  <= x"A";
                sender_data <= x"07";

            -- Scan limit: use all 8 digits
            WHEN x"B" =>
                sender_addr  <= x"B";
                sender_data <= x"07";

            -- Shutdown register: normal operation
            WHEN x"C" =>
                sender_addr  <= x"C";
                sender_data <= x"01";

            -- Unused Addresses D/E, send no-op like zeros
            WHEN x"D" =>
                sender_addr  <= x"D";
                sender_data <= x"00";

             WHEN x"E" =>
                sender_addr  <= x"E";
                sender_data <= x"00";

            -- Display test: normal operation
             WHEN OTHERS =>
                sender_addr  <= x"F";
                sender_data <= x"00";

        END CASE;

    END PROCESS;

    -- Register index controller.
    -- Starts a sender transaction whever sender is idle.
    -- After each completed transaction, move to the next MAX7219 register.
    PROCESS(clk)
    BEGIN

        IF  RISING_EDGE(clk) THEN
        
            IF rst = '1' THEN
                reg_index    <= (OTHERS => '0');
                sender_start <= '0';

            ELSE
                sender_start <= '0';

                IF sender_busy = '0' THEN
                    sender_start <= '1';
                
                END IF;

                IF sender_done = '1' THEN
                    reg_index <= reg_index + 1;

                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;