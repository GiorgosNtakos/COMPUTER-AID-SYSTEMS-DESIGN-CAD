LIBRARY IEEE;
USE iEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY scan_2_7seg IS

    PORT(

        clk          : IN  STD_LOGIC;
        curr_scan    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        prev_scan    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        result       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        valid_result : IN STD_LOGIC;   
        an           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s            : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) 
   
    );

END scan_2_7seg;

ARCHITECTURE rtl OF scan_2_7seg IS

    SIGNAL cnt      : UNSIGNED        (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL digitSel : UNSIGNED        ( 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL seg_prev : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL seg_curr : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL seg_res  : STD_LOGIC_VECTOR(6 DOWNTO 0);

    BEGIN

        --clock divider
        PROCESS(clk)

            BEGIN

                IF RISING_EDGE(clk) THEN

                    cnt <= cnt + 1;

                END IF;

        END PROCESS;

        digitSel <= cnt(15 downto 14);  -- 2-bit "multiplex selector"

        bin_seg_inst : ENTITY work.bin_to_7seg

            PORT MAP (

                bin => result,
                seg => seg_res

            );

        PROCESS (digitSel, valid_result, seg_prev, seg_curr, seg_res)

            BEGIN

                --defaults
                an <= "1111";
                s  <= "1111111";

                CASE digitSel IS

                    WHEN "00" => --ΑΝ0 (δεξια)

                        an       <= "1110"; -- μονο AN0 ενεργό
                        s        <= seg_prev;

                    WHEN "01" => --ΑΝ1 (αριστερα)

                        an       <= "1101"; -- μονο AN1 ενεργό
                        s        <= seg_curr;

                    WHEN "11" => -- AN3 (τερμα αριστερα)

                        an       <= "0111"; -- μονο AN3 ενεργό

                        IF valid_result = '1' THEN

                            s        <= seg_res;

                        ELSE

                            s <= "1111111";

                        END IF;

                    WHEN OTHERS => --AN2 (σβηστό)

                        an       <= "1111";
                        s        <= "1111111";
                    
                END CASE;

        END PROCESS;

        WITH prev_scan SELECT

            seg_prev <= "1000000" WHEN x"45", -- 0
                        "1111001" WHEN x"16", -- 1
                        "0100100" WHEN x"1E", -- 2
                        "0110000" WHEN x"26", -- 3
                        "0011001" WHEN x"25", -- 4
                        "0010010" WHEN x"2E", -- 5
                        "0000010" WHEN x"36", -- 6
                        "1111000" WHEN x"3D", -- 7
                        "0000000" WHEN x"3E", -- 8
                        "0010000" WHEN x"46", -- 9
                        "1111111" WHEN OTHERS;

        -- curr_scan σε 7seg
        WITH curr_scan SELECT

            seg_curr <= "1000000" WHEN x"45",
                        "1111001" WHEN x"16",
                        "0100100" WHEN x"1E",
                        "0110000" WHEN x"26",
                        "0011001" WHEN x"25",
                        "0010010" WHEN x"2E",
                        "0000010" WHEN x"36",
                        "1111000" WHEN x"3D",
                        "0000000" WHEN x"3E",
                        "0010000" WHEN x"46",
                        "1111111" WHEN OTHERS;

END rtl;