LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;


ENTITY fp32_tc_to_signmag IS
    PORT(
        sum_tc    : IN    SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);

        mag_o     : OUT UNSIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
        sign_o    : OUT STD_LOGIC
    );
END ENTITY fp32_tc_to_signmag;

ARCHITECTURE rtl OF fp32_tc_to_signmag IS
BEGIN

    PROCESS(sum_tc)
    BEGIN

        -- Zero Result
        IF sum_tc = 0 THEN
            sign_o <= '0';
            mag_o  <= (OTHERS => '0');
        
        -- Negative Result
        ELSIF sum_tc(FP32_TC_WIDTH-1) = '1' THEN
            sign_o <= '1';
            
            -- Convert back for 2's complement to magnitude
            mag_o <= UNSIGNED(-sum_tc);
        
        -- Positive Result
        ELSE
            sign_o <= '0';
            
            -- sum_tc pass through
            mag_o <= UNSIGNED(sum_tc);
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;