library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_to_bcd is
    port (
        bin : in unsigned(31 downto 0);
        bcd : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of bin_to_bcd is
begin
    process(bin)
        variable work : unsigned(63 downto 0);
    begin
        work := (others => '0');
        work(31 downto 0) := bin;

        for i in 0 to 31 loop
            if work(35 downto 32) > "0100" then work(35 downto 32) := work(35 downto 32) + "0011"; end if;
            if work(39 downto 36) > "0100" then work(39 downto 36) := work(39 downto 36) + "0011"; end if;
            if work(43 downto 40) > "0100" then work(43 downto 40) := work(43 downto 40) + "0011"; end if;
            if work(47 downto 44) > "0100" then work(47 downto 44) := work(47 downto 44) + "0011"; end if;
            if work(51 downto 48) > "0100" then work(51 downto 48) := work(51 downto 48) + "0011"; end if;
            if work(55 downto 52) > "0100" then work(55 downto 52) := work(55 downto 52) + "0011"; end if;
            if work(59 downto 56) > "0100" then work(59 downto 56) := work(59 downto 56) + "0011"; end if;
            if work(63 downto 60) > "0100" then work(63 downto 60) := work(63 downto 60) + "0011"; end if;
            work := shift_left(work, 1);
        end loop;

        bcd <= std_logic_vector(work(63 downto 32));
    end process;
end architecture;
