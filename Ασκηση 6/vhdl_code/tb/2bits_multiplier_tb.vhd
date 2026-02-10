LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY multiplier_2bits_tb IS
END multiplier_2bits_tb;

ARCHITECTURE Behavioral OF multiplier_2bits_tb IS

    SIGNAL a1,a0,b1,b0 : STD_LOGIC := '0';
    SIGNAL s       : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL dp      : STD_LOGIC;
    SIGNAL an      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL a1a0b1b0    : STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS => '0');

    BEGIN

        --Instantiate the Unit Under Test (UUT)
        uut : ENTITY work.multiplier_2bits

            PORT MAP(

                a1  => a1,
                a0   => a0,
                b1   => b1,
                b0   => b0,
                s   => s,
                dp  => dp,
                an => an           

            );

    -- Process για να τρεχουμε όλους τους συνδυασμους
    stim_proc : PROCESS

        BEGIN

            FOR i IN 0 TO 15 LOOP

                a1a0b1b0 <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,4));
                WAIT FOR 0 ns;  -- <<< επιτρέπει στο a1a0b1b0 να ανανεωθεί
                b0    <= a1a0b1b0(0);
                b1    <= a1a0b1b0(1);
                a0    <= a1a0b1b0(2);
                a1    <= a1a0b1b0(3);
                WAIT FOR 100 ns;
                
            END LOOP;

            WAIT;

        END PROCESS;

END Behavioral;