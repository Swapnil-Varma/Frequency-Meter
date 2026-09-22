library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_frequency_meter is
    generic (
        CLK_FREQ_HZ  : positive := 100_000_000;
        TEST_FREQ_HZ : positive := 10_000;
        GATE_TIME_MS : positive := 1000
    );
    port (
        CLK100MHZ : in  std_logic;
        RESET     : in  std_logic;
        BTNC      : in  std_logic;
        AN        : out std_logic_vector(3 downto 0);
        SEG       : out std_logic_vector(6 downto 0);
        DP        : out std_logic
    );
end entity;

architecture rtl of top_frequency_meter is
    signal internal_pulse : std_logic;
    signal sync_pulse : std_logic;
    signal pulse_rise : std_logic;
    signal gate_tick : std_logic;
    signal freq : unsigned(31 downto 0);
    signal freq_khz : unsigned(31 downto 0);
    signal period_us : unsigned(31 downto 0);
    signal freq_valid : std_logic;
    signal khz_busy : std_logic;
    signal btn_press : std_logic;
    signal mode : std_logic := '0';

    signal d3, d2, d1, d0 : std_logic_vector(3 downto 0);
    signal dp3, dp2, dp1, dp0 : std_logic;
begin
    u_generator : entity work.pulse_generator
        generic map (CLK_FREQ_HZ => CLK_FREQ_HZ, OUT_FREQ_HZ => TEST_FREQ_HZ)
        port map (clk => CLK100MHZ, reset => RESET, pulse_out => internal_pulse);

    u_sync : entity work.pulse_synchronizer
        port map (clk => CLK100MHZ, async_in => internal_pulse, sync_out => sync_pulse);

    u_edge : entity work.edge_detector
        port map (clk => CLK100MHZ, signal_in => sync_pulse, rising_pulse => pulse_rise);

    u_gate : entity work.gate_timer
        generic map (CLK_FREQ_HZ => CLK_FREQ_HZ, GATE_TIME_MS => GATE_TIME_MS)
        port map (clk => CLK100MHZ, reset => RESET, gate_tick => gate_tick);

    u_freq : entity work.frequency_meter
        generic map (GATE_TIME_MS => GATE_TIME_MS)
        port map (
            clk => CLK100MHZ,
            reset => RESET,
            pulse_rise => pulse_rise,
            gate_tick => gate_tick,
            frequency_hz => freq,
            result_valid => freq_valid
        );

    u_period : entity work.period_meter
        generic map (CLK_FREQ_HZ => CLK_FREQ_HZ)
        port map (
            clk => CLK100MHZ,
            reset => RESET,
            pulse_rise => pulse_rise,
            period_us => period_us
        );

    u_khz : entity work.hz_to_khz
        port map (
            clk => CLK100MHZ,
            reset => RESET,
            start => freq_valid,
            hz_in => freq,
            khz_out => freq_khz,
            busy => khz_busy
        );

    u_button : entity work.button_debounce
        generic map (CLK_FREQ_HZ => CLK_FREQ_HZ, DEBOUNCE_MS => 20)
        port map (
            clk => CLK100MHZ,
            reset => RESET,
            btn_in => BTNC,
            press_pulse => btn_press
        );

    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if RESET = '1' then
                mode <= '0';
            elsif btn_press = '1' then
                mode <= not mode;
            end if;
        end if;
    end process;

    u_format : entity work.display_formatter
        port map (
            mode => mode,
            frequency_khz => freq_khz,
            period_us => period_us,
            d3 => d3, d2 => d2, d1 => d1, d0 => d0,
            dp3 => dp3, dp2 => dp2, dp1 => dp1, dp0 => dp0
        );

    u_display : entity work.seven_segment
        port map (
            clk => CLK100MHZ,
            reset => RESET,
            d3 => d3, d2 => d2, d1 => d1, d0 => d0,
            dp3 => dp3, dp2 => dp2, dp1 => dp1, dp0 => dp0,
            an => AN, seg => SEG, dp => DP
        );
end architecture;
