LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY keyboard IS

    Port (

        rst     : IN  STD_LOGIC;
        clk     : IN  STD_LOGIC;
        ps2clk  : IN  STD_LOGIC;
        ps2data : IN  STD_LOGIC;
        seg     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        dp      : OUT STD_LOGIC;
        an      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END keyboard;

ARCHITECTURE Structural OF keyboard IS

    SIGNAL scan           : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL flag           : STD_LOGIC;
    SIGNAL curr_scan      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL prev_scan      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL operator       : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL decimal_prev   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL decimal_curr   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL division_res   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL full_result    : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal valid_result   : STD_LOGIC;


BEGIN

    kbd_inst : ENTITY work.kbd_protocol

        PORT MAP (

            rst      => rst,
            clk      => clk,
            flag     => flag,
            ps2clk   => ps2clk,
            ps2data  => ps2data,
            scancode => scan

        );

        prev_scan_inst : ENTITY work.prev_scancode

        PORT MAP (

            rst      => rst,
            clk      => clk,
            flag     => flag,
            operator => operator,
            scancode => scan,
            prev     => prev_scan,
            curr     => curr_scan

        );

        conv_inst1 : ENTITY work.scancode_converter

        PORT MAP (

            scancode     => prev_scan,
            decimal      => decimal_prev

        );

        conv_inst2 : ENTITY work.scancode_converter

        PORT MAP (

            scancode     => curr_scan,
            decimal      => decimal_curr

        );

        divider_inst : ENTITY work.divider

        PORT MAP (

            rst      => rst,
            clk      => clk,
            dividend => decimal_curr,
            divisor  => decimal_prev,
            result   => division_res

        );


        operations_inst : ENTITY work.operations

        PORT MAP (

            curr_dec     => decimal_curr,
            prev_dec     => decimal_prev,
            valid_result => valid_result,
            operator     => operator,
            divs_res     => division_res,
            result       => full_result

        );

    seg_inst : ENTITY work.scan_2_7seg

        PORT MAP (

            clk          => clk,
            curr_scan    => curr_scan,
            prev_scan    => prev_scan,
            valid_result => valid_result,
            result       => full_result,
            s            => seg,
            an           => an

        );

        dp <= '1';
END Structural;
