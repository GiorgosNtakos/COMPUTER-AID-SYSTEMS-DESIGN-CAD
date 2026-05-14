LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_signmag_to_tc IS
    PORT(
        sign_i : IN STD_LOGIC;
        mant_i : IN UNSIGNED(FP32_MANT_WIDTH-1 DOWNTO 0);

        tc_o   : OUT SIGNED(FP32_TC_WIDTH-1 DOWNTO 0)
    );
END ENTITY fp32_signmag_to_tc;

ARCHITECTURE rtl OF fp32_signmag_to_tc IS
    SIGNAL mag_ext_u : UNSIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
    SIGNAL mag_ext_s :   SIGNED(FP32_TC_WIDTH-1 DOWNTO 0);
BEGIN

    -- Extend aligned mantissa by two bits on the left:
    -- bit FP32_TC_WIDTH-1 : signed MSB
    -- bit FP32_TC_WIDTH-2 : significand overflow/carry room
    -- lower bits          : 24-bit aligned significand
    mag_ext_u <= "00" & mant_i;
    
    -- Reinterpret the extended magnitude as signed.
    -- Since MSB is 0, this is always a positive signed value.
    mag_ext_s <= SIGNED(mag_ext_u);

    PROCESS(sign_i, mag_ext_s)
    BEGIN

        IF sign_i = '1' THEN
            -- Negative input: convert magnitude to 2's complement
            tc_o <= -mag_ext_s;
        ELSE
            -- Positive input: keep magnitude unchanged
            tc_o <= mag_ext_s;
        END IF;
    
    END PROCESS;
END ARCHITECTURE rtl;