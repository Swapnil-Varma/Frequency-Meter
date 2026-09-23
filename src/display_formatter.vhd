library ieee;
use ieee.std_logic_1164.all;

entity display_formatter is
    port (
        mode : in std_logic; -- 0 = frequency, 1 = period
        frequency_bcd : in std_logic_vector(31 downto 0);
        period_bcd    : in std_logic_vector(31 downto 0);
        d3,d2,d1,d0 : out std_logic_vector(3 downto 0);
        dp3,dp2,dp1,dp0 : out std_logic
    );
end entity;

architecture rtl of display_formatter is
begin
    process(mode, frequency_bcd, period_bcd)
    begin
        d3 <= "0000"; d2 <= "0000"; d1 <= "0000"; d0 <= "0000";
        dp3 <= '0'; dp2 <= '0'; dp1 <= '0'; dp0 <= '0';

        if mode = '0' then
            -- Frequency is measured in Hz.
            -- Display: XX.XX kHz
            -- For 10000 Hz: 10.00 kHz
            -- BCD nibbles are numbered from bit 3:0 upward.
            d3 <= frequency_bcd(19 downto 16); -- 10,000s
            d2 <= frequency_bcd(15 downto 12); -- 1,000s
            d1 <= frequency_bcd(11 downto 8);  -- 100s
            d0 <= frequency_bcd(7 downto 4);   -- 10s
            dp2 <= '1'; -- decimal point: XX.XX
        else
            -- Period is measured in microseconds.
            -- Display: XXX.X us
            -- For 100 us: 100.0 us
            d3 <= period_bcd(11 downto 8); -- 100s
            d2 <= period_bcd(7 downto 4);  -- 10s
            d1 <= period_bcd(3 downto 0);  -- 1s
            d0 <= "0000";                   -- tenths
            dp1 <= '1'; -- decimal point: XXX.X
        end if;
    end process;
end architecture;
