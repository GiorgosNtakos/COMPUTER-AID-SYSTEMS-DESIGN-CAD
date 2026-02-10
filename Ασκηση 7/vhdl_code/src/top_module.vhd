LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- TOP: 1 Hz seconds counter -> δυο 7-seg (δεκαδες/μοναδες) με multiplexing
ENTITY led_clock IS

    PORT(
      
        clk  : IN  STD_LOGIC;                    -- 100 MHz(CLK100MHz)
        rst  : IN  STD_LOGIC;                    -- active-high reset(SW0)
        stp  : IN  STD_LOGIC;                    -- active-high stop(SW1)   
        an   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- anodes, active-low
        seg  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- segments, g...a, active-low
        leds : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Leds, active-high
        dp   : OUT STD_LOGIC                     -- decimal point, active-low    

    );
END led_clock;


ARCHITECTURE rtl OF led_clock IS

    -- απο τον μετ�?ητή δευτε�?ολέπτων
    SIGNAL ts           : UNSIGNED(2 DOWNTO 0); -- δεκαδες (0...5) system
    SIGNAL ts_int       : STD_LOGIC_VECTOR(3 DOWNTO 0); -- ts 3 bits ενω το x στο bin_2_7 είναι 4 bit α�?α κανουμε επεκταση του ts απο 3 σε 4 bit
    SIGNAL ss           : UNSIGNED(3 DOWNTO 0); -- μοναδες (0...9) system
    SIGNAL msecs        : UNSIGNED(3 DOWNTO 0); -- δεκαδατα (0...9) system
    SIGNAL en_1s        : STD_LOGIC;            -- enable παλμος 1 Hz
    SIGNAL en_10s       : STD_LOGIC;            -- enable παλμος 10 Hz
    SIGNAL en_msec_off  : STD_LOGIC;            -- off επειοδη δεν οδηγαει πουθενα αλλα θα γινεται '1' οταν ικανοποιει τη συνθηκη που πρεπει μη μας κανει εντυπωση
    SIGNAL ts_display   : UNSIGNED(2 DOWNTO 0);    
    SIGNAL ss_display   : UNSIGNED(3 DOWNTO 0);
    SIGNAL tens_display : UNSIGNED(3 DOWNTO 0);

    
    --αποκοδικοποιημένα patterns για τα δυο �?ηφία (active-low)
    SIGNAL left_disp, right_disp : STD_LOGIC_VECTOR(6 DOWNTO 0);

    BEGIN

        ------------------------------------------------------------------------
        -- 1) Διαιρέτης 100MHz -> 1Hz (enable pulse)
        ------------------------------------------------------------------------
        i_div1 : ENTITY work.OneHertz

            PORT MAP(

                rst  => rst,
                clk    => clk,
                en_nxt => en_1s

            );

        ------------------------------------------------------------------------
        -- 2) Διαιρέτης 100MHz -> 10Hz (enable pulse)
        ------------------------------------------------------------------------
        i_div10 : ENTITY work.TenHertz

            PORT MAP(

                rst  => rst,
                clk    => clk,
                en_nxt => en_10s

            );

        ------------------------------------------------------------------------
        -- 3) Μετρητής Δεκατων 0...9 
        ------------------------------------------------------------------------
        i_tens : ENTITY work.cnt_Single_Seconds

            PORT MAP(

                rst    => rst,
                clk    => clk,
                enable => en_10s,
                ss     => msecs,
                nxt    => en_msec_off
            );

        ------------------------------------------------------------------------
        -- 4) Μετρητής Δευτερολέπτων 00...59 (BCD: ts/ss)
        ------------------------------------------------------------------------
        i_secs : ENTITY work.Timer_Clock

            PORT MAP(

                rst    => rst,
                clk    => clk,
                enable => en_1s,
                ts     => ts,
                ss     => ss            

            );

        ------------------------------------------------------------------------
        -- 5) BCD -> 7-seg(active-low patterns για Basys3)
        --    Προσοχή : ts είναι 3-bit, βάζουμε '0' μπροστά για 4-bit είσοδο
        ------------------------------------------------------------------------

        ts_int <= '0' & STD_LOGIC_VECTOR(ts_display);

        i_bcd_left : ENTITY work.bin_2_7

            PORT MAP(

                x => ts_int, -- δεκάδες
                s => left_disp

            );

        i_bcd_rigt : ENTITY work.bin_2_7

            PORT MAP(

                x => STD_LOGIC_VECTOR(ss_display), -- μονάδες
                s => right_disp

            );

        ------------------------------------------------------------------------
        -- 6) Multiplexing δυο ψηφιων (προτεινομενο ~2 KHz toggle -> ~1 KHz/ψηφιο)
        ------------------------------------------------------------------------
        i_mux_seg : ENTITY work.seg_mux

            PORT MAP(

                clk   => clk,
                left  => left_disp, -- δεκάδες (2ο απο δεξια)
                right => right_disp, -- μονάδες (δεξιοτερο)
                an    => an,
                seg   => seg                 

            );

           ------------------------------------------------------------------------
           -- 7) Stopwatch ωστε να παγωνει την τιμη στα ssd αλλα ο μηχανισμος μετραει
           ------------------------------------------------------------------------
            i_stopwatch : ENTITY work.stopwatch

                PORT MAP(

                    clk           => clk,
                    stp           => stp,
                    true_tenths   => msecs,
                    true_ts       => ts, -- μονάδες (δεξιοτερο)
                    true_ss       => ss,
                    output_ts     => ts_display,                  
                    output_ss     => ss_display,
                    output_tenths => tens_display
                    
                );

            ------------------------------------------------------------------------
            -- 8) Thermometr Led Bar active-high
            ------------------------------------------------------------------------
            i_ledthermometer : ENTITY work.ledThermometer

                PORT MAP(

                    tenths => tens_display,
                    leds   => leds                 

                );


        -- DP σβηστ�? (active-low) : '1' = off
        dp <= '1';

END rtl;
