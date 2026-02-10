LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY tb_counter IS
END tb_counter;

ARCHITECTURE behavior OF tb_counter IS

    -- Εισοδος testbench (8 bit)
    SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

    -- Εξοδος Μετρητη (7 bit)
    SIGNAL c : STD_LOGIC_VECTOR(6 DOWNTO 0);

    -- Control Signals
    SIGNAL s_s : STD_LOGIC := '0';
    SIGNAL l   : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL clr : STD_LOGIC := '0';

    BEGIN 

    -- Instantiation του  UUT(counter 7-bit)
    uut : ENTITY work.counter

        PORT MAP (

            clear => clr,
            clock => clk,
            load => l,
            start_stop => s_s,
            data => d(6 DOWNTO 0),
            count => c            

        );

    clk_process : PROCESS

        BEGIN

            WAIT FOR 40 ns;
            clk <= not clk;
    
    END PROCESS;

    -- STIMULUS
    stim_proc : PROCESS

        BEGIN

            -- ΑΡΧΙΚΟΠΟΙΗΣΗ
            d   <= "11110000";  -- 0xF0 = 240, αλλά περνάνε μόνο 7 LSBs (112)
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
            l   <= '1';   -- φορτώνει το data(6 downto 0)
            wait for 200 ns;
            l   <= '0';

            wait;
        end process;

end behavior;
            


    