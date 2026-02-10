LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Timer_CLock_tb IS
END ENTITY;

ARCHITECTURE sim OF Timer_Clock_tb IS

    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL ts  : UNSIGNED(2 DOWNTO 0);
    SIGNAL ss  : UNSIGNED(3 DOWNTO 0);

    BEGIN

        -- Instantiate CUT
        uut : ENTITY work.Timer_clock PORT MAP(clk => clk, rst => rst, enable => '1', ts => ts, ss => ss);

        -- CLock generation (125 MHz -> 8ns)
        clk_process : PROCESS

            BEGIN

                WHILE now < 2000 ms LOOP

                    clk <= '0';

                    WAIT FOR 4 ns;

                    clk <= '1';

                    WAIT FOR 4 ns;

                END LOOP;
                WAIT;
        END PROCESS;

        -- Reset Pulse
        stim_proc : PROCESS

        BEGIN

            rst <= '1';
            WAIT FOR 10 ns;
            rst <= '0';
            WAIT;

        END PROCESS;
END ARCHITECTURE;