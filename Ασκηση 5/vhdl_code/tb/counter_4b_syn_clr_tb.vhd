LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY tb_counter_4b_syn_clr IS
END tb_counter_4b_syn_clr;

ARCHITECTURE behavior OF tb_counter_4b_syn_clr IS

    -- Εισοδος testbench (5 bit)
    SIGNAL d : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');

    -- Εξοδος Μετρητη (4 bit)
    SIGNAL c : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Control Signals
    SIGNAL s_s : STD_LOGIC := '0';
    SIGNAL l   : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL clr : STD_LOGIC := '0';

    BEGIN 

    -- Instantiation του  UUT(counter 7-bit)
    uut : ENTITY work.counter_4bits_syn_clr

        PORT MAP (

            clr        => clr,
            clk        => clk,
            load_flag  => l,
            start_stop => s_s,
            data_in    => d(3 DOWNTO 0),
            count_out  => c            

        );

    clk_process : PROCESS

        BEGIN

            WAIT FOR 40 ns;
            clk <= NOT clk;
    
    END PROCESS;

    -- STIMULUS
    stim_proc : PROCESS

        BEGIN

            -- ΑΡΧΙΚΟΠΟΙΗΣΗ
            d   <= "10011";  -- 0x13 = 19, αλλά περνάνε μόνο 4 LSBs (3)
            clr <= '0';
            l   <= '0';
            s_s <= '0';
            wait for 100 ns;

            -- Pulse στο clear
            clr <= '1';
            wait for 50 ns;
            clr <= '0';

            -- Enable counting
            wait for 250 ns;
            s_s <= '1';
            wait for 3000 ns;
            s_s <= '0';

            -- Δοκιμή load
            wait for 500 ns;
            s_s <= '1';
            wait for 200 ns;
            l   <= '1';   -- φορτώνει το data(3 downto 0)
            wait for 200 ns;
            l   <= '0';

            wait;
        end process;

end behavior;