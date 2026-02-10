LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY prev_scancode IS

    PORT (
        
        clk      : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;
        flag     : IN  STD_LOGIC;
        scancode : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        operator : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        curr     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);    
        prev     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)

    );

END prev_scancode;

--ARCHITECTURE rtl OF prev_scancode IS
    
 --   SIGNAL temp         : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
 --   SIGNAL ext_flag     : STD_LOGIC                    := '0';
 --   SIGNAL curr_r       : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
 --   SIGNAL prev_r       : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
 --   SIGNAL operator_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '1');
  --  SIGNAL op_pulse     : STD_LOGIC := '0';

  --  BEGIN

   --     PROCESS(clk, rst)

          --  BEGIN

              --  IF rst = '1' THEN

              --      temp         <= (OTHERS => '0');
               --   prev_r       <= (OTHERS => '0');
                --    curr_r       <= (OTHERS => '0');
                 --   operator_reg <= (OTHERS => '1');
                 --   ext_flag     <= '0';
               --     op_pulse     <= '0';

             --   ELSIF RISING_EDGE(clk) THEN
                        
                 --   IF flag = '1' THEN

                     --   IF (scancode = x"79" OR scancode = x"7B" OR scancode = x"7C" OR scancode = x"4A") THEN

                         --   CASE scancode IS

                             --   WHEN x"79" =>

                                 --   operator_reg <= "000";

                              --  WHEN x"7B" =>

                                 --   operator_reg <= "001";

                              --  WHEN x"7C" =>

                             --       operator_reg <= "010";

                             --   WHEN x"4A" =>

                                --    operator_reg <= "011";

                             --   WHEN OTHERS =>

                                 --   operator_reg <= "111";

                         --   END CASE;

                    --    ELSE

                         --   IF ext_flag = '0' THEN

                            --    curr_r   <= scancode;
                             --   temp     <= scancode;
                            --    ext_flag <= '1';

                         --   ELSE

                            --    curr_r <= scancode;
                             --   prev_r <= temp;
                             --   temp   <= scancode;

                          --  END IF;

                          --  operator_reg <= "111"; -- default

                      --  END IF;

                --    END IF;

            --    END IF;

       -- END PROCESS;

     --   curr     <= curr_r;
     --   prev     <= prev_r;
      --  operator <= operator_reg;

--END rtl;*/ -- �?ωδικας που δουλευει με το να δωσεις τους α�?ιθμους και επειτα να πατησει τον τελεστη

--�?ΩΔΙ�?ΑΣ με το να πατησεις 1 α�?ιθμο(previous) μετα τον τελεστη και μετα τον 2 α�?ι�?μο(current)

ARCHITECTURE rtl OF prev_scancode IS
    TYPE state_type IS (IDLE, FIRST_NUM, OPER_ATOR, SECOND_NUM, RESULT);
    SIGNAL state : state_type := IDLE;

    SIGNAL prev_r, curr_r : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
    SIGNAL operator_reg   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
BEGIN

PROCESS(clk, rst)
BEGIN
    IF rst = '1' THEN
        state        <= IDLE;
        prev_r       <= (OTHERS => '0');
        curr_r       <= (OTHERS => '0');
        operator_reg <= "111";

    ELSIF rising_edge(clk) THEN
        IF flag = '1' THEN
            CASE state IS
                -- πε�?ιμένουμε π�?�?το �?ηφίο
                WHEN IDLE =>
                    IF (scancode = x"45" OR scancode = x"16" OR scancode = x"1E" OR
                        scancode = x"26" OR scancode = x"25" OR scancode = x"2E" OR
                        scancode = x"36" OR scancode = x"3D" OR scancode = x"3E" OR
                        scancode = x"46") THEN
                        curr_r <= scancode;
                        state  <= OPER_ATOR;
                    ELSE
                        NULL; -- αγνόησε οτιδήποτε άλλο
                    END IF;

                -- πε�?ιμένουμε τελεστή
                WHEN OPER_ATOR =>
                    CASE scancode IS
                        WHEN x"79" => operator_reg <= "000"; state <= SECOND_NUM; -- +
                        WHEN x"7B" => operator_reg <= "001"; state <= SECOND_NUM; -- -
                        WHEN x"7C" => operator_reg <= "010"; state <= SECOND_NUM; -- *
                        WHEN x"4A" => operator_reg <= "011"; state <= SECOND_NUM; -- /
                        WHEN OTHERS => NULL;
                    END CASE;

                -- πε�?ιμένουμε δε�?τε�?ο �?ηφίο
                WHEN SECOND_NUM =>
                    IF (scancode = x"45" OR scancode = x"16" OR scancode = x"1E" OR
                        scancode = x"26" OR scancode = x"25" OR scancode = x"2E" OR
                        scancode = x"36" OR scancode = x"3D" OR scancode = x"3E" OR
                        scancode = x"46") THEN
                        prev_r <= curr_r;
                        curr_r <= scancode;
                        state  <= RESULT;     
                    ELSE
                        NULL; -- αγνόησε οτιδήποτε άλλο
                    END IF;

                    WHEN RESULT =>
                    -- μένω εδώ μέχρι να πατηθεί κάτι άλλο;
                    IF (scancode = x"45" OR scancode = x"16" OR scancode = x"1E" OR
                        scancode = x"26" OR scancode = x"25" OR scancode = x"2E" OR
                        scancode = x"36" OR scancode = x"3D" OR scancode = x"3E" OR
                        scancode = x"46") THEN
                        prev_r       <= curr_r;   -- ξεκινάω νέα πράξη
                        curr_r       <= scancode;
                        state  <= OPER_ATOR;
                        operator_reg<= "111";
                    ELSE
                        -- Αν πατηθεί τελεστής εδώ, ΑΓΝΟΗΣΕ (δεν θες chaining)
                        NULL;
                    END IF;

                WHEN OTHERS =>
                    state <= IDLE;
            END CASE;
        END IF;
    END IF;
END PROCESS;

curr     <= curr_r;
prev     <= prev_r;
operator <= operator_reg;

END rtl;
