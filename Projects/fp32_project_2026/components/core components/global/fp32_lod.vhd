LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.fp32_pkg.ALL;

ENTITY fp32_lod IS
    PORT(
        mag_i    : IN UNSIGNED(FP32_TC_WIDTH-1  DOWNTO 0);

        lead_pos : OUT INTEGER RANGE 0 TO FP32_TC_WIDTH-1
    );
END ENTITY fp32_lod;

ARCHITECTURE rtl OF fp32_lod IS
BEGIN

    PROCESS(mag_i)
    BEGIN

        lead_pos <= 0;

        FOR i IN FP32_TC_WIDTH-1 DOWNTO 0  LOOP

            IF mag_i(i) = '1' THEN
                lead_pos <= i;
                EXIT;
            END IF;

        END LOOP;
    END PROCESS;

END ARCHITECTURE rtl;