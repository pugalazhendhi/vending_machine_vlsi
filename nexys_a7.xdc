## Nexys A7-100T - Vending Machine

## 100 MHz Clock
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}]

## Product Selection
## SW0 = Product A
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {product_A}]

## SW1 = Product B
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports {product_B}]

## Coin Inputs
## SW2 = ₹5
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports {coin_5}]

## SW3 = ₹10
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports {coin_10}]

## Reset
## Center Push Button = Reset
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {reset}]

## Outputs
## LED0 = Product A
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports {dispense_A}]

## LED1 = Product B
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports {dispense_B}]

## LED2 = ₹5 Change
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports {change_5}]

## LED3 = ₹10 Change
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports {change_10}]