library ieee;
use ieee.std_logic_1164.all;

entity gate_timer is
    generic (
        CLK_FREQ_HZ  : positive := 100_000_000;
        GATE_TIME_MS : positive := 1000
    );
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        gate_tick : out std_logic
    );
end entity;

architecture rtl of gate_timer is
    constant TICKS : positive := (CLK_FREQ_HZ / 1000) * GATE_TIME_MS;
    signal count : integer range 0 to TICKS-1 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= 0;
                gate_tick <= '0';
            elsif count = TICKS-1 then
                count <= 0;
                gate_tick <= '1';
            else
                count <= count + 1;
                gate_tick <= '0';
            end if;
        end if;
    end process;
end architecture;
