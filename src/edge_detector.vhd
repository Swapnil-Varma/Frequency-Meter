library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
    port (
        clk          : in  std_logic;
        signal_in    : in  std_logic;
        rising_pulse : out std_logic
    );
end entity;

architecture rtl of edge_detector is
    signal prev : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            rising_pulse <= signal_in and not prev;
            prev <= signal_in;
        end if;
    end process;
end architecture;
