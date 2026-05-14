LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_add_1cycle IS
    PORT(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        -- IEEE-754 FP32 sample Inputs on 1st positive edge
        a_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
        b_i : IN STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

        -- IEEE-754 FP32 register result on the next clock's positive edge
        result_o : OUT STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_add_1cycle;

ARCHITECTURE rtl OF fp32_add_1cycle IS

    SIGNAL a_reg : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
    SIGNAL b_reg : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

    SIGNAL core_result : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);
    SIGNAL result_reg  : STD_LOGIC_VECTOR(FP32_WIDTH-1 DOWNTO 0);

BEGIN

    -- Combinational FP32 adder core
    core_inst : ENTITY work.fp32_add_core
    PORT MAP(
        a_i      => a_reg,
        b_i      => b_reg,

        result_o => core_result
    );

    -- Input and output registers
    PROCESS(clk)
    BEGIN

        IF RISING_EDGE(clk) THEN

            IF rst = '1' THEN
                a_reg      <= (OTHERS => '0');
                b_reg      <= (OTHERS => '0');
                result_reg <= (OTHERS => '0');
            
            ELSE
                -- Sample inputs on rising edge
                a_reg <= a_i;
                b_reg <= b_i;

                -- Register result from previous sampled inputs
                result_reg <= core_result;
            END IF;

        END IF;
    END PROCESS;

    result_o <= result_reg;

END ARCHITECTURE rtl;