## Switches (A: SW1-SW0, B: SW3-SW2)
set_property PACKAGE_PIN V17 [get_ports {A[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[0]}]
set_property PACKAGE_PIN V16 [get_ports {A[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[1]}]
set_property PACKAGE_PIN W16 [get_ports {B[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property PACKAGE_PIN W17 [get_ports {B[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]

## LEDs (LED0: A < B, LED1: A == B, LED2: A > B)
set_property PACKAGE_PIN U16 [get_ports {A_less_B}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {A_less_B}]
set_property PACKAGE_PIN E19 [get_ports {A_equal_B}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {A_equal_B}]
set_property PACKAGE_PIN U19 [get_ports {A_greater_B}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {A_greater_B}]