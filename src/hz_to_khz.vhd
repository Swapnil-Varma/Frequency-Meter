library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hz_to_khz is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        start     : in  std_logic;
        hz_in     : in  unsigned(31 downto 0);
        khz_out   : out unsigned(31 downto 0);
        busy      : out std_logic
    );
end entity;

architecture rtl of hz_to_khz is
    signal work_hz : unsigned(31 downto 0) := (others => '0');
    signal khz_reg : unsigned(31 downto 0) := (others => '0');
    signal busy_reg : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                work_hz <= (others => '0');
                khz_reg <= (others => '0');
                busy_reg <= '0';

            elsif start = '1' then
                work_hz <= hz_in;
                khz_reg <= (others => '0');
                busy_reg <= '1';

            elsif busy_reg = '1' then
                if work_hz >= 1000 then
                    work_hz <= work_hz - 1000;
                    khz_reg <= khz_reg + 1;
                else
                    busy_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    khz_out <= khz_reg;
    busy <= busy_reg;
end architecture;
