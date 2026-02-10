LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY kbd_protocol IS

    PORT(

        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;
        ps2clk   : IN  STD_LOGIC;
        ps2data  : IN  STD_LOGIC;
        flag     : OUT STD_LOGIC;
        scancode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)    

    );

END kbd_protocol;

ARCHITECTURE rtl OF kbd_protocol IS

    SIGNAL scancode_reg  : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fall_edge     : STD_LOGIC := '0';
    SIGNAL shift         : STD_LOGIC_VECTOR( 9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cnt           : INTEGER RANGE 0 TO 10 := 0;
    SIGNAL f0            : STD_LOGIC := '0';
    SIGNAL ps2clksamples : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL flag_reg      : STD_LOGIC := '0';

    -- 🔹 Εδώ ορίζω τη function
    FUNCTION xor_reduce(v : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS

        VARIABLE r : STD_LOGIC := '0';

        BEGIN

            FOR i IN v'RANGE LOOP

                r := r XOR v(i);

            END LOOP;
            RETURN r;

    END FUNCTION;
        
    BEGIN

        -- συγχρονισμος ps2clk
        PROCESS(clk, rst)

            BEGIN

                IF rst = '1' THEN

                    ps2clksamples <= (OTHERS => '0');

                ELSIF RISING_EDGE(clk) THEN

                    ps2clksamples <= ps2clksamples(6 DOWNTO 0) & ps2clk;

                END IF;

        END PROCESS;

        -- ανιχνευση πτωσης
        fall_edge <= '1' WHEN (ps2clksamples(7 DOWNTO 4) = "1111" AND ps2clksamples(3 DOWNTO 0) = "0000") ELSE
                     '0';

        --FSM πρωτοκόλλου
        PROCESS(clk, rst)

            BEGIN

                IF rst = '1' THEN

                    cnt          <= 0;
                    shift        <= (OTHERS => '0');
                    scancode_reg <= (OTHERS => '0');
                    f0           <= '0';
                    flag_reg     <= '0';

                ELSIF RISING_EDGE(clk) THEN

                    flag_reg     <= '0';

                    IF fall_edge = '1' THEN

                        IF cnt = 10 THEN

                            cnt <= 0;

                            -- ελεγχος start, stop και odd parity
                            IF (shift(0) = '0' AND ps2data = '1' AND XOR_REDUCE(shift(9 DOWNTO 1)) = '1') THEN

                                IF f0 = '1' THEN

                                    scancode_reg <= shift(8 DOWNTO 1);
                                    f0 <= '0';
                                    flag_reg <= '1'; -- νέο scancode έτοιμο

                                ELSIF shift(8 DOWNTO 1) = x"F0" THEN

                                    f0 <= '1';

                                END IF;

                            END IF;

                        ELSE

                            shift <= ps2data & shift(9 DOWNTO 1);
                            cnt <= cnt + 1;

                        END IF;

                    END IF;
                    
                END IF;

                scancode <= scancode_reg;
                flag     <= flag_reg;

          END PROCESS;

END rtl;