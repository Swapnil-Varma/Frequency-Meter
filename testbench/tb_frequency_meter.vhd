library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_frequency_meter is
end entity;

architecture sim of tb_frequency_meter is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal pulse_rise : std_logic := '0';
    signal gate_tick : std_logic := '0';
    signal frequency_hz : unsigned(31 downto 0);
    signal result_valid : std_logic;

    constant CLK_PERIOD : time := 1 ns;
    constant GATE_MS : positive := 1000;
begin
    clk <= not clk after CLK_PERIOD/2;

    dut : entity work.frequency_meter
        generic map (GATE_TIME_MS => GATE_MS)
        port map (
            clk => clk,
            reset => reset,
            pulse_rise => pulse_rise,
            gate_tick => gate_tick,
            frequency_hz => frequency_hz,
            result_valid => result_valid
        );

    process
        procedure make_pulse is
        begin
            wait until rising_edge(clk);
            pulse_rise <= '1';
            wait until rising_edge(clk);
            pulse_rise <= '0';
        end procedure;
    begin
        wait for 5 ns;
        reset <= '0';

        for i in 1 to 10 loop
            make_pulse;
        end loop;

        wait until rising_edge(clk);
        gate_tick <= '1';
        wait until rising_edge(clk);
        gate_tick <= '0';

        wait until result_valid = '1';
        wait for 1 ns;

        assert frequency_hz = to_unsigned(10, 32)
            report "Frequency counter result is incorrect"
            severity error;

        report "tb_frequency_meter PASSED" severity note;
        wait;
    end process;
end architecture;
