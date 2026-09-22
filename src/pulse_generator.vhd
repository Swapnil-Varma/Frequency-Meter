library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_generator is
    generic (
        CLK_FREQ_HZ : positive := 100_000_000;
        OUT_FREQ_HZ : positive := 10_000
    );
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        pulse_out : out std_logic
    );
end entity;

architecture rtl of pulse_generator is
    -- Divide-by-2 toggle counter for a 50% duty-cycle square wave.
    constant HALF_PERIOD_TICKS : positive := CLK_FREQ_HZ / (2 * OUT_FREQ_HZ);
    signal count : integer range 0 to HALF_PERIOD_TICKS-1 := 0;
    signal q : std_logic := '0';
begin
    assert CLK_FREQ_HZ >= (2 * OUT_FREQ_HZ)
        report "OUT_FREQ_HZ is too high for the selected CLK_FREQ_HZ"
        severity failure;

    assert (CLK_FREQ_HZ mod (2 * OUT_FREQ_HZ)) = 0
        report "CLK_FREQ_HZ is not an integer multiple of 2*OUT_FREQ_HZ; generated frequency will be quantized."
        severity warning;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= 0;
                q <= '0';
            elsif count = HALF_PERIOD_TICKS - 1 then
                count <= 0;
                q <= not q;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    pulse_out <= q;
end architecture;
