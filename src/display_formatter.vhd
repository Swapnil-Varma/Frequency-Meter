library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_formatter is
    port (
        mode       : in  std_logic; -- 0 = frequency kHz, 1 = period us
        frequency_khz : in unsigned(31 downto 0);
        period_us  : in  unsigned(31 downto 0);
        d3, d2, d1, d0 : out std_logic_vector(3 downto 0);
        dp3, dp2, dp1, dp0 : out std_logic
    );
end entity;

architecture rtl of display_formatter is
begin
    process(mode, frequency_khz, period_us)
    begin
        dp3 <= '0'; dp2 <= '0'; dp1 <= '0'; dp0 <= '0';

        if mode = '0' then
            d3 <= std_logic_vector(frequency_khz(15 downto 12));
            d2 <= std_logic_vector(frequency_khz(11 downto 8));
            d1 <= std_logic_vector(frequency_khz(7 downto 4));
            d0 <= std_logic_vector(frequency_khz(3 downto 0));
        else
            d3 <= std_logic_vector(period_us(15 downto 12));
            d2 <= std_logic_vector(period_us(11 downto 8));
            d1 <= std_logic_vector(period_us(7 downto 4));
            d0 <= std_logic_vector(period_us(3 downto 0));
        end if;
    end process;
end architecture;
