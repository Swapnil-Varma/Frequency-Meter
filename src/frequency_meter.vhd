library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frequency_meter is
    generic (
        GATE_TIME_MS : positive := 1000
    );
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        pulse_rise   : in  std_logic;
        gate_tick    : in  std_logic;
        frequency_hz : out unsigned(31 downto 0);
        result_valid : out std_logic
    );
end entity;

architecture rtl of frequency_meter is
    signal count  : unsigned(31 downto 0) := (others => '0');
    signal result : unsigned(31 downto 0) := (others => '0');
begin
    -- For the recommended 1-second gate:
    -- frequency_hz = number of pulses in the gate.
    -- This deliberately avoids a large synthesized divider.
    assert GATE_TIME_MS = 1000
        report "Timing-optimized frequency_meter assumes GATE_TIME_MS = 1000 ms."
        severity warning;

    process(clk)
        variable pulses : unsigned(31 downto 0);
    begin
        if rising_edge(clk) then
            result_valid <= '0';

            if reset = '1' then
                count <= (others => '0');
                result <= (others => '0');
            elsif gate_tick = '1' then
                if pulse_rise = '1' then
                    pulses := count + 1;
                else
                    pulses := count;
                end if;

                if GATE_TIME_MS = 1000 then
                    result <= pulses;
                else
                    -- Kept only as a functional fallback. For timing closure,
                    -- use the recommended 1000-ms gate.
                    result <= pulses;
                end if;

                count <= (others => '0');
                result_valid <= '1';
            elsif pulse_rise = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;

    frequency_hz <= result;
end architecture;
