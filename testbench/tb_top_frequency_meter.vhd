library ieee;
use ieee.std_logic_1164.all;

entity tb_top_frequency_meter is
end entity;

architecture sim of tb_top_frequency_meter is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal btnc : std_logic := '0';
    signal an : std_logic_vector(3 downto 0);
    signal seg : std_logic_vector(6 downto 0);
    signal dp : std_logic;
begin
    -- Fast simulation configuration:
    -- 1 MHz reference, 1 kHz generated pulse, 10 ms gate.
    clk <= not clk after 500 ns;

    dut : entity work.top_frequency_meter
        generic map (
            CLK_FREQ_HZ => 1_000_000,
            TEST_FREQ_HZ => 1_000,
            GATE_TIME_MS => 10
        )
        port map (
            CLK100MHZ => clk,
            RESET => reset,
            BTNC => btnc,
            AN => an,
            SEG => seg,
            DP => dp
        );

    process
    begin
        wait for 5 us;
        reset <= '0';

        -- Allow several measurement windows.
        wait for 25 ms;

        -- Toggle from frequency to period display.
        btnc <= '1';
        wait for 30 us;
        btnc <= '0';

        wait for 5 ms;

        report "tb_top_frequency_meter completed" severity note;
        wait;
    end process;
end architecture;
