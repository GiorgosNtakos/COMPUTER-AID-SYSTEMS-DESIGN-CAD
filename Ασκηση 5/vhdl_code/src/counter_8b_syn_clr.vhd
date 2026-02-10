LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter_8bits_syn_clr IS

    PORT (

        clk            :  IN STD_LOGIC; -- ρολοι
        clr            :  IN STD_LOGIC; -- ασυγχρονος καθαρισμος
        start_stop     :  IN STD_LOGIC; -- enable counting
        load_flag      :  IN STD_LOGIC; -- enable parallel load
        data_in        :  IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel input
        count_out      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- current value of counter

    );

END counter_8bits_syn_clr;

ARCHITECTURE rtl OF counter_8bits_syn_clr IS

    -- Δηλωσεις component (ο 4-bit counter)
    COMPONENT counter_4bits IS

        PORT(
            clk        :  IN STD_LOGIC;
            clr        :  IN STD_LOGIC;
            start_stop :  IN STD_LOGIC;
            load_flag  :  IN STD_LOGIC;
            data_in    :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            count_out  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)        

        );

    END COMPONENT;

    SIGNAL cnt_low      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cnt_high     : STD_LOGIC_VECTOR(3 DOWNTO 0);
     -- enable για το high nibble: overflow του low, με ενεργό start_stop
    SIGNAL start_stop_high : STD_LOGIC;

    BEGIN

        -- Εισοδος επιτρεψης του high nibble συνδεεται στην εξοδο μια πυλης 
        -- AND 5 εισοδων μεταξυ των σηματων cnt_low και start_stop διοτι οταν 
        -- cnt_low = 1111 και start_stop = 1 σημαινει οτι το high nibble αυξανεται
        -- κατα 1 το low nibble παει απο 1111 -> 0000.
        start_stop_high <= start_stop AND (cnt_low(3) AND cnt_low(2) AND cnt_low(1) AND cnt_low(0));

        -- Low nibble : μετραει κανονικα με start_stop
        u_low : counter_4bits

            PORT MAP(

                clk        => clk,                
                clr        => clr,
                start_stop => start_stop,
                load_flag  => load_flag,
                data_in    => data_in(3 DOWNTO 0),
                count_out  => cnt_low

            );

        -- High nibble : μετραει μόνο οταν overflow-αρει το low nibble και start_stop = 1
        u_high : counter_4bits

            PORT MAP(

                clk        => clk,                
                clr        => clr,
                start_stop => start_stop_high,
                load_flag  => load_flag,
                data_in    => data_in(7 DOWNTO 4),
                count_out  => cnt_high

            );

        count_out <= cnt_high & cnt_low;

END rtl;

        




