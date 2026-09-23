library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_period_meter is
end entity;

architecture sim of tb_period_meter is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal pulse_rise : std_logic := '0';
    signal period_us : unsigned(31 downto 0);

    constant CLK_FREQ_HZ : positive := 1_000_000;
    constant CLK_PERIOD : time := 1 us;
begin
    clk <= not clk after CLK_PERIOD/2;

    dut : entity work.period_meter
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ
        )
        port map (
            clk => clk,
            reset => reset,
            pulse_rise => pulse_rise,
            period_us => period_us
        );

    process
    begin
        wait for 3 us;
        reset <= '0';

        wait until rising_edge(clk);
        pulse_rise <= '1';
        wait until rising_edge(clk);
        pulse_rise <= '0';

        -- Approximately 10 us between rising edges.
        for i in 1 to 9 loop
            wait until rising_edge(clk);
        end loop;

        pulse_rise <= '1';
        wait until rising_edge(clk);
        pulse_rise <= '0';

        wait for 2 us;

        report "Measured period (us) = " &
               integer'image(to_integer(period_us))
               severity note;

        assert period_us >= to_unsigned(8, 32) and
               period_us <= to_unsigned(12, 32)
            report "Period measurement outside expected range"
            severity error;

        report "tb_period_meter PASSED" severity note;
        wait;
    end process;
end architecture;
