library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_OneHertz is
end tb_OneHertz;

architecture sim of tb_OneHertz is
    signal clk    : std_logic := '0';
    signal rst  : std_logic := '0';
    signal en_nxt : std_logic;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.OneHertz
        port map(
            clk    => clk,
            rst  => rst,
            en_nxt => en_nxt
        );

    -- Clock generation: 100 MHz -> 10 ns period
    clk_process: process
    begin
        while now < 1001 ms loop   -- simulation time
            clk <= '0';
            wait for 5 ns;      -- half period
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;  -- stop simulation
    end process;

    -- Reset stimulus
    stim_proc: process
    begin
       rst <= '0';
        wait for 10 ns;
       rst <= '1';
        wait for 9 ns;
       rst <= '0';
        wait;
    end process;
end sim;
