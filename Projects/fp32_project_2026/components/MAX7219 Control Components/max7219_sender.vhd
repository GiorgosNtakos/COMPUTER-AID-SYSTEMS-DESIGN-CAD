LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY max7219_sender IS
    PORT(
        clk    : IN STD_LOGIC;
        rst    : IN STD_LOGIC;

        tick_i : IN STD_LOGIC; -- 1 MHz enable pulse

        start_i : IN STD_LOGIC;
        addr_i  : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        data_i  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        
        busy_o : OUT STD_LOGIC;
        done_o : OUT STD_LOGIC;

        max_cs  : OUT STD_LOGIC;
        max_clk : OUT STD_LOGIC;
        max_din : OUT STD_LOGIC
    );
END ENTITY max7219_sender;

ARCHITECTURE rtl OF max7219_sender IS

    TYPE state_t IS (
        IDLE,
        ADDRESS,
        TXDATA,
        FINISHED
    );

    SIGNAL state : state_t := IDLE;

    -- 8-bit address phase:
    -- upper 4 bits are don't care, lower 4 bits are register address
    SIGNAL address_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL bit_cnt  : INTEGER RANGE 0 TO 7 := 7;
    SIGNAL step_cnt : INTEGER RANGE 0 TO 2 := 0;

    SIGNAL cs_reg   : STD_LOGIC := '1';
    SIGNAL clk_reg  : STD_LOGIC := '0';
    SIGNAL din_reg  : STD_LOGIC := '0';

    SIGNAL busy_reg : STD_LOGIC := '0';
    SIGNAL done_reg : STD_LOGIC := '0';

BEGIN

    address_byte <= "0000" & addr_i;

    max_cs  <= cs_reg;
    max_clk <= clk_reg;
    max_din <= din_reg;

    busy_o <= busy_reg;
    done_o <= done_reg;

    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN
        
            IF rst = '1' THEN
                state <= IDLE;
                bit_cnt  <= 7;
                step_cnt <= 0;
                
                cs_reg  <= '1';
                clk_reg <= '0';
                din_reg <= '0';

                busy_reg <= '0';
                done_reg <= '0';

            ELSE
                done_reg <= '0';

                IF tick_i = '1' THEN

                    CASE state IS
                        --====================================================
                        --| Idle:                                            |
                        --| no transmission.                                 |
                        --| When start_i is asserted, pull CS low and begin. |
                        --====================================================
                        WHEN IDLE =>
                            cs_reg   <= '1';
                            clk_reg  <= '0';
                            din_reg  <= '0';
                            busy_reg <= '0';

                            bit_cnt  <= 7;
                            step_cnt <= 0;

                            IF start_i = '1' THEN
                                cs_reg   <= '0';
                                busy_reg <= '1';
                                state    <= ADDRESS;

                            END IF;

                        --====================================================
                        --| Address:                                         |
                        --| send 8 bits:                                     |
                        --| 0000 + addr_i                                    |
                        --| MSB first.                                       |
                        --| Each bit takes 3 tick cycles:                    |
                        --| step 0: put data on DIN                          |
                        --| step 1: CLK high                                 |
                        --| step 2: CLK low and move to next bit             |
                        --====================================================
                        WHEN ADDRESS =>
                            CASE step_cnt IS
                                WHEN 0 =>
                                    din_reg  <= address_byte(bit_cnt);
                                    clk_reg  <= '0';
                                    step_cnt <= 1;

                                WHEN 1 =>
                                    clk_reg  <= '1';
                                    step_cnt <= 2;

                                WHEN OTHERS =>
                                    clk_reg <= '0';

                                    IF bit_cnt = 0 THEN
                                        bit_cnt  <= 7;
                                        step_cnt <= 0;
                                        state    <= TXDATA;

                                    ELSE
                                        bit_cnt  <= bit_cnt - 1;
                                        step_cnt <= 0;
                                    
                                    END IF;
                            END CASE;

                        --====================================================
                        --| TXDATA:                                          |
                        --| send data_i[7:0], MSB first                      |
                        --| Again, each bit takes 3 tick cycles              |
                        --====================================================
                        WHEN TXDATA =>
                            CASE step_cnt IS
                                WHEN 0 =>
                                    din_reg  <= data_i(bit_cnt);
                                    clk_reg  <= '0';
                                    step_cnt <= 1;

                                WHEN 1 =>
                                    clk_reg  <= '1';
                                    step_cnt <= 2;

                                WHEN OTHERS =>
                                    clk_reg <= '0';

                                    IF bit_cnt = 0 THEN
                                        bit_cnt  <= 7;
                                        step_cnt <= 0;
                                        state    <= FINISHED;

                                    ELSE
                                        bit_cnt  <= bit_cnt - 1;
                                        step_cnt <= 0;
                                    
                                    END IF;
                            END CASE;

                        --=====================================================
                        --| FINISHED:                                         |
                        --| raise CS to latch the 16-bit packet into MAX7219. |
                        --| Generate done_o for one tick.                     |
                        --=====================================================
                        WHEN FINISHED =>
                            cs_reg   <= '1';
                            clk_reg  <= '0';
                            busy_reg <= '0';
                            done_reg <= '1';

                            state <= IDLE;

                    END CASE;

                END IF;
            END IF;
         END IF;
    END PROCESS;

END ARCHITECTURE rtl;