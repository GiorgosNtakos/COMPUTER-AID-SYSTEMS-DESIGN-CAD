LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY tb_fp32_add_1cycle IS
END ENTITY;

ARCHITECTURE tb OF tb_fp32_add_1cycle IS

    -- ======================================
    -- |        CLOCK CONFIGURATION         |
    -- ======================================
    CONSTANT clk_period : TIME := 20 ns;

    -- ======================================
    -- |             DUT SIGNALS            |
    -- ======================================
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';

    SIGNAL a_i : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0) := (others => '0');
    SIGNAL b_i : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0) := (others => '0');

    SIGNAL result_o : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

BEGIN

    -- ======================================
    -- |          DUT INSTALATION           |
    -- ======================================
    dut : ENTITY work.fp32_add_1cycle
        PORT MAP(
            clk      => clk,
            rst      => rst,

            a_i      => a_i,
            b_i      => b_i,

            result_o => result_o
        );

    -- ======================================
    -- |           CLOCK GENERATION         |
    -- ======================================
    clk_process : PROCESS
    BEGIN

        WHILE TRUE LOOP

            clk <= '0';
            WAIT FOR clk_period/2;

            clk <= '1';
            WAIT FOR clk_period/2;

        END LOOP;

    END PROCESS;

    -- ======================================
    -- |           STIMULUS PROCESS         |
    -- ======================================
    stim_proc : PROCESS

        FILE vec_file : TEXT OPEN READ_MODE IS "C:/project_fp32/vectors/vectors_clear.txt";
        
        VARIABLE line_v : LINE;

        VARIABLE a_vec      : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE b_vec      : STD_LOGIC_VECTOR(31 DOWNTO 0); 
        VARIABLE expected_v : STD_LOGIC_VECTOR(31 DOWNTO 0);

        VARIABLE errors     : INTEGER := 0;
        VARIABLE testnum    : INTEGER := 0;

    BEGIN

        -- ======================================
        -- |               RESET                |
        -- ======================================
        rst <= '1';

        WAIT FOR clk_period;
        WAIT UNTIL RISING_EDGE(clk);

        rst <= '0';

        -- ======================================
        -- |           READ ALL VECTORS         |
        -- ======================================
        WHILE NOT ENDFILE(vec_file) LOOP

            READLINE(vec_file, line_v);

            -- READ:
            -- A, B, EXPECTED
            hread(line_v, a_vec);
            hread(line_v, b_vec);
            hread(line_v, expected_v);

            -- Apply inputs
            a_i <= a_vec;
            b_i <= b_vec;

            -- First rising edge: DUT samples A and B into input registers
            WAIT UNTIL RISING_EDGE(clk);
            -- Second rising edge: DUT registers the result
            WAIT UNTIL RISING_EDGE(clk);

            -- Small delay so registered outputs settle in simulation
            WAIT FOR 1 NS;

            -- Display current transaction
            REPORT
                "TEST "   & INTEGER'image(testnum) &
                " | A="   & TO_HSTRING(a_vec)      &
                " | B="   & TO_HSTRING(b_vec)      &
                " | OUT=" & TO_HSTRING(result_o)   &
                " | EXP=" & TO_HSTRING(expected_v);

                -- Compare result
                IF result_o /= expected_v THEN

                    REPORT
                        "Mismatch at test " & INTEGER'image(testnum)
                        SEVERITY ERROR;

                    errors := errors + 1;

                END IF;

                testnum := testnum + 1;

            END LOOP;

            -- ======================================
            -- |             FINALREPORT            |
            -- ======================================
            REPORT
                "Simulation completed. Errors = " &
                INTEGER'IMAGE(errors);
            
            WAIT;

    END PROCESS;

END ARCHITECTURE tb;



