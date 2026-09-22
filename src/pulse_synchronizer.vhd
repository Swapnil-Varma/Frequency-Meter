library ieee;
use ieee.std_logic_1164.all;

entity pulse_synchronizer is
    port (
        clk       : in  std_logic;
        async_in  : in  std_logic;
        sync_out  : out std_logic
    );
end entity;

architecture rtl of pulse_synchronizer is
    signal ff1, ff2 : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            ff1 <= async_in;
            ff2 <= ff1;
        end if;
    end process;

    sync_out <= ff2;
end architecture;
