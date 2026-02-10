LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY number_displayer_tb IS
END number_displayer_tb;

ARCHITECTURE Behavioral OF number_displayer_tb IS

    SIGNAL a,b,c,d : STD_LOGIC := '0';
    SIGNAL s       : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL dp      : STD_LOGIC;
    SIGNAL an      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL abcd    : STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS => '0');

    BEGIN

        --Instantiate the Unit Under Test (UUT)
        uut : ENTITY work.number_displayer

            PORT MAP(

                a   => a,
                b   => b,
                c   => c,
                d   => d,
                s   => s,
                dp  => dp,
                an => an           

            );

    -- Process για να τρεχουμε όλους τους συνδυασμους
    stim_proc : PROCESS

        BEGIN

            FOR i IN 0 TO 15 LOOP

                abcd <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,4));
                WAIT FOR 0 ns;  -- <<< επιτρέπει στο abcd να ανανεωθεί
                a    <= abcd(0);
                b    <= abcd(1);
                c    <= abcd(2);
                d    <= abcd(3);
                WAIT FOR 100 ns;
                
            END LOOP;

            WAIT;

        END PROCESS;

END Behavioral;