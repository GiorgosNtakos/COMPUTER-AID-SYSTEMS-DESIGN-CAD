LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY tb_fp32_add_2stage IS
END ENTITY;

ARCHITECTURE tb OF tb_fp32_add_2stage IS

    -- ======================================
    -- |        CLOCK CONFIGURATION         |
    -- ======================================
    CONSTANT clk_period : TIME := 20 ns;
    CONSTANT latency    : INTEGER := 3;

    -- ======================================
    -- |             DUT SIGNALS            |
    -- ======================================
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';

    SIGNAL a_i : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0) := (others => '0');
    SIGNAL b_i : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0) := (others => '0');

    SIGNAL result_o : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

    TYPE slv32_array_t IS ARRAY (0 TO latency-1) OF STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);


BEGIN

    -- ======================================
    -- |          DUT INSTALATION           |
    -- ======================================
    dut : ENTITY work.fp32_add_2stage
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

        VARIABLE expected_pipe : slv32_array_t := (OTHERS => (OTHERS => '0'));
        VARIABLE valid_pipe    : STD_LOGIC_VECTOR(0 TO latency-1) := (OTHERS => '0');

        VARIABLE errors     : INTEGER := 0;
        VARIABLE testnum    : INTEGER := 0;
        VARIABLE checks     : INTEGER := 0;

    BEGIN

        -- ======================================
        -- |               RESET                |
        -- ======================================
        rst <= '1';

        WAIT FOR clk_period;
        WAIT UNTIL RISING_EDGE(clk);

        rst <= '0';

        -- ===========================================================
        -- |    STREAMING PHASE: APPLY ONE VECTOR PER CLOCK CYCLE    |
        -- ===========================================================
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
            WAIT FOR 1 NS;

            -- Shift expected/valid pipeline
            expected_pipe(latency-1) := expected_pipe(latency-2);
            valid_pipe(latency-1)    := valid_pipe(latency-2);

            FOR i IN latency-2 DOWNTO 1 LOOP
                expected_pipe(i) := expected_pipe(i-1);
                valid_pipe(i)    := valid_pipe(i-1);
            END LOOP;

            expected_pipe(0) := expected_v;
            valid_pipe(0)    := '1';

            -- Check output only when expected value is valid
            IF valid_pipe(latency-1) = '1' THEN

                REPORT
                    "CEHCK "  & INTEGER'IMAGE(checks) &
                    " | OUT=" & TO_HSTRING(result_o)   &
                    " | EXP=" & TO_HSTRING(expected_pipe(latency-1));

                -- Compare result
                IF result_o /= expected_pipe(latency-1) THEN

                    REPORT
                        "Mismatch at test " & INTEGER'IMAGE(checks)
                        SEVERITY ERROR;

                    errors := errors + 1;

                END IF;

                checks := checks + 1;

            END IF;

            testnum := testnum + 1;

        END LOOP;

        -- ===========================================================
        -- |   FLUSH PHASE: PIPELINE STILL CONTAINS EXPECTED VALUES  |
        -- ===========================================================
        FOR flush_i IN 0 TO latency-1 LOOP

            -- Drive zeros after vectors are exhausted
            a_i <= (OTHERS => '0');
            b_i <= (OTHERS => '0');

            WAIT UNTIL RISING_EDGE(clk);
            WAIT FOR 1 NS;

            expected_pipe(latency-1) := expected_pipe(latency-2);
            valid_pipe(latency-1)    :=valid_pipe(latency-2);

            FOR i IN latency-2 DOWNTO 1 LOOP
                expected_pipe(i) := expected_pipe(i-1);
                valid_pipe(i)    := valid_pipe(i-1);
            END LOOP;

            expected_pipe(0) := (OTHERS => '0');
            valid_pipe(0)    := '0';

            IF valid_pipe(latency-1) = '1' THEN

                REPORT
                    "CEHCK "   & INTEGER'image(checks) &
                    " | OUT=" & TO_HSTRING(result_o)   &
                    " | EXP=" & TO_HSTRING(expected_pipe(latency-1));

                 IF result_o /= expected_pipe(latency-1) THEN

                    REPORT
                        "Mismatch at test " & INTEGER'image(checks)
                        SEVERITY ERROR;

                    errors := errors + 1;

                END IF;

                checks := checks + 1;

            END IF;

        END LOOP;

            -- ======================================
            -- |             FINALREPORT            |
            -- ======================================
            REPORT
                "Simulation completed. Tests applied = " &
                INTEGER'IMAGE(testnum)                   &
                ", Checks = "                            &
                INTEGER'image(checks)                    &
                ", Errors = "                            &
                INTEGER'image(errors); 
            
            WAIT;

    END PROCESS;

END ARCHITECTURE tb;



