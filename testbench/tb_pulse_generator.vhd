library ieee;
use ieee.std_logic_1164.all;

entity tb_pulse_generator is
end entity;

architecture sim of tb_pulse_generator is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal pulse : std_logic;

    constant CLK_FREQ_HZ : positive := 1000;
    constant TEST_FREQ_HZ : positive := 100;
begin
    clk <= not clk after 500 ns; -- 1 kHz clock

    dut : entity work.pulse_generator
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            OUT_FREQ_HZ => TEST_FREQ_HZ
        )
        port map (
            clk => clk,
            reset => reset,
            pulse_out => pulse
        );

    process
    begin
        wait for 2 us;
        reset <= '0';

        -- 10 output periods = 100 us.
        wait for 100 us;

        report "tb_pulse_generator completed" severity note;
        wait;
    end process;
end architecture;
