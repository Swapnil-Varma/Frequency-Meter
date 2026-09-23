## Digilent Basys3 - Artix-7 XC7A35T-1CPG236C

## 100 MHz system clock
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk [get_ports CLK100MHZ]

## Reset - BTND
set_property PACKAGE_PIN U17 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

## Center push button - toggle Frequency / Period
set_property PACKAGE_PIN U18 [get_ports BTNC]
set_property IOSTANDARD LVCMOS33 [get_ports BTNC]

## 4-digit seven-segment display
set_property PACKAGE_PIN W7 [get_ports {SEG[0]}]
set_property PACKAGE_PIN W6 [get_ports {SEG[1]}]
set_property PACKAGE_PIN U8 [get_ports {SEG[2]}]
set_property PACKAGE_PIN V8 [get_ports {SEG[3]}]
set_property PACKAGE_PIN U5 [get_ports {SEG[4]}]
set_property PACKAGE_PIN V5 [get_ports {SEG[5]}]
set_property PACKAGE_PIN U7 [get_ports {SEG[6]}]
set_property PACKAGE_PIN V7 [get_ports DP]

set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SEG[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports DP]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[*]}]
