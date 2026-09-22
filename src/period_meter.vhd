library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity period_meter is
    generic (
        CLK_FREQ_HZ : positive := 100_000_000
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        pulse_rise : in  std_logic;
        period_us  : out unsigned(31 downto 0)
    );
end entity;

architecture rtl of period_meter is
    constant US_TICKS : positive := CLK_FREQ_HZ / 1_000_000;
    signal us_divider : integer range 0 to US_TICKS-1 := 0;
    signal us_counter : unsigned(31 downto 0) := (others => '0');
    signal period_reg : unsigned(31 downto 0) := (others => '0');
    signal seen_first : std_logic := '0';
begin
    assert CLK_FREQ_HZ >= 1_000_000
        report "CLK_FREQ_HZ must be at least 1 MHz for microsecond period measurement."
        severity failure;

    assert (CLK_FREQ_HZ mod 1_000_000) = 0
        report "CLK_FREQ_HZ is not an integer multiple of 1 MHz; microsecond resolution will be quantized."
        severity warning;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                us_divider <= 0;
                us_counter <= (others => '0');
                period_reg <= (others => '0');
                seen_first <= '0';

            else
                -- Free-running microsecond counter.
                if us_divider = US_TICKS - 1 then
                    us_divider <= 0;
                    if seen_first = '1' then
                        us_counter <= us_counter + 1;
                    end if;
                else
                    us_divider <= us_divider + 1;
                end if;

                if pulse_rise = '1' then
                    if seen_first = '1' then
                        period_reg <= us_counter;
                    end if;

                    us_counter <= (others => '0');
                    seen_first <= '1';
                end if;
            end if;
        end if;
    end process;

    period_us <= period_reg;
end architecture;
