library ieee;
use ieee.std_logic_1164.all;

entity button_debounce is
    generic (
        CLK_FREQ_HZ : positive := 100_000_000;
        DEBOUNCE_MS : positive := 20
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        btn_in      : in  std_logic;
        press_pulse : out std_logic
    );
end entity;

architecture rtl of button_debounce is
    constant MAX_COUNT : positive := (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
    signal sync1, sync2 : std_logic := '0';
    signal stable : std_logic := '0';
    signal count : integer range 0 to MAX_COUNT := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sync1 <= '0';
                sync2 <= '0';
                stable <= '0';
                count <= 0;
                press_pulse <= '0';
            else
                sync1 <= btn_in;
                sync2 <= sync1;
                press_pulse <= '0';

                if sync2 = stable then
                    count <= 0;
                elsif count = MAX_COUNT then
                    stable <= sync2;
                    count <= 0;
                    if sync2 = '1' then
                        press_pulse <= '1';
                    end if;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
