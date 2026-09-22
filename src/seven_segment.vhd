library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment is
    port (
        clk : in std_logic;
        reset : in std_logic;
        d3, d2, d1, d0 : in std_logic_vector(3 downto 0);
        dp3, dp2, dp1, dp0 : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        dp : out std_logic
    );
end entity;

architecture rtl of seven_segment is
    signal refresh : unsigned(16 downto 0) := (others => '0');
    signal sel : unsigned(1 downto 0);
    signal digit : std_logic_vector(3 downto 0);
    signal dp_i : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                refresh <= (others => '0');
            else
                refresh <= refresh + 1;
            end if;
        end if;
    end process;

    sel <= refresh(16 downto 15);

    process(sel, d3, d2, d1, d0, dp3, dp2, dp1, dp0)
    begin
        an <= "1111";
        case sel is
            when "00" =>
                an <= "1110"; digit <= d0; dp_i <= dp0;
            when "01" =>
                an <= "1101"; digit <= d1; dp_i <= dp1;
            when "10" =>
                an <= "1011"; digit <= d2; dp_i <= dp2;
            when others =>
                an <= "0111"; digit <= d3; dp_i <= dp3;
        end case;
    end process;

    process(digit)
    begin
        case digit is
            when "0000" => seg <= "1000000";
            when "0001" => seg <= "1111001";
            when "0010" => seg <= "0100100";
            when "0011" => seg <= "0110000";
            when "0100" => seg <= "0011001";
            when "0101" => seg <= "0010010";
            when "0110" => seg <= "0000010";
            when "0111" => seg <= "1111000";
            when "1000" => seg <= "0000000";
            when "1001" => seg <= "0010000";
            when "1010" => seg <= "0001000";
            when "1011" => seg <= "0000011";
            when "1100" => seg <= "1000110";
            when "1101" => seg <= "0100001";
            when "1110" => seg <= "0000110";
            when others => seg <= "0001110";
        end case;
    end process;

    dp <= dp_i;
end architecture;
