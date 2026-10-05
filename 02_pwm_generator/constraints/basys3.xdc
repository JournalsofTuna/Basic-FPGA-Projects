## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Buttons
# btnC -> Reset
set_property PACKAGE_PIN U18 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]
# btnU -> Parlaklık Artır
set_property PACKAGE_PIN T18 [get_ports btn_up]						
	set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
# btnD -> Parlaklık Azalt
set_property PACKAGE_PIN U17 [get_ports btn_down]						
	set_property IOSTANDARD LVCMOS33 [get_ports btn_down]

## LEDs
# LD0 -> PWM Çıkışı (Parlaklığı izlenen LED)
set_property PACKAGE_PIN U16 [get_ports pwm_out]					
	set_property IOSTANDARD LVCMOS33 [get_ports pwm_out]

# LD1..LD8 -> Mevcut 8-bit Duty Değeri
set_property PACKAGE_PIN E19 [get_ports {duty_leds[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[0]}]
set_property PACKAGE_PIN U19 [get_ports {duty_leds[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[1]}]
set_property PACKAGE_PIN V19 [get_ports {duty_leds[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[2]}]
set_property PACKAGE_PIN W18 [get_ports {duty_leds[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[3]}]
set_property PACKAGE_PIN U15 [get_ports {duty_leds[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[4]}]
set_property PACKAGE_PIN U14 [get_ports {duty_leds[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[5]}]
set_property PACKAGE_PIN V14 [get_ports {duty_leds[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[6]}]
set_property PACKAGE_PIN V13 [get_ports {duty_leds[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {duty_leds[7]}]