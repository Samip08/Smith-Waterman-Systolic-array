## =========================
## CLOCK (100 MHz)
## =========================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 200.000 -name sys_clk -waveform {0 5} [get_ports clk]


## =========================
## RESET (Center Button)
## =========================
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PULLUP true [get_ports rst]


## =========================
## START (Switch 0)
## =========================
set_property PACKAGE_PIN V17 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]


## =========================
## DONE (LED 0)
## =========================
set_property PACKAGE_PIN U16 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports done]


## =========================
## DEBUG: max_score (lower 8 bits → LEDs)
## =========================
set_property PACKAGE_PIN E19 [get_ports {max_score[0]}]
set_property PACKAGE_PIN U19 [get_ports {max_score[1]}]
set_property PACKAGE_PIN V19 [get_ports {max_score[2]}]
set_property PACKAGE_PIN W18 [get_ports {max_score[3]}]
set_property PACKAGE_PIN U15 [get_ports {max_score[4]}]
set_property PACKAGE_PIN U14 [get_ports {max_score[5]}]
set_property PACKAGE_PIN V14 [get_ports {max_score[6]}]
set_property PACKAGE_PIN V13 [get_ports {max_score[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {max_score[*]}]