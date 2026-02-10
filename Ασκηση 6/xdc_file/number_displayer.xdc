## SWITCHES SW0 - SW3
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports a]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports b]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports c]
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports d]

## 7 SEGMENT DISPLAY 
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {s[0]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {s[1]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {s[2]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {s[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {s[4]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {s[5]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {s[6]}]

set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports dp]

set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {an[3]}]