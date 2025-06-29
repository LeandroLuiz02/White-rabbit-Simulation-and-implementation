#
# MYD-J7A100T White Rabbit Constraints Template
# BOARD: MYIR MYD-J7A100T (Artix-7 XC7A100T-2FGG484I)
# FPGA: Xilinx Artix-7 XC7A100T-2FGG484I
#       - 101,440 logic cells
#       - 4,860 Kb total block RAM
#       - 512MB DDR3 SDRAM (32-bit)
#       - 32MB QSPI Flash
#       - 256 Kb EEPROM
#

# ============================================================================
# FPGA PART SPECIFICATION
# ============================================================================
# set_part xc7a100tfgg484-2

# ============================================================================
# CLOCK CONSTRAINTS - WHITE RABBIT CRITICAL TIMING
# ============================================================================

# Main system clock - 200 MHz differential LVDS
# The SOM provides a 200 MHz differential LVDS clock
# set_property PACKAGE_PIN XX [get_ports clk_200mhz_p]
# set_property PACKAGE_PIN XX [get_ports clk_200mhz_n]
# set_property IOSTANDARD LVDS [get_ports clk_200mhz_p]
# set_property IOSTANDARD LVDS [get_ports clk_200mhz_n]

# Create primary clock constraint - 200MHz differential
# create_clock -period 5.000 -name clk_200mhz [get_ports clk_200mhz_p]  # 200MHz

# White Rabbit reference clock (125 MHz for Gigabit Ethernet)
# create_clock -period 8.000 -name clk_125mhz_ref [get_ports clk_125mhz_ref]

# ============================================================================
# SFP+ INTERFACES - HIGH SPEED TRANSCEIVERS (GTP)
# ============================================================================
# Critical for White Rabbit precision timing

# SFP+ Interface 1 (Bank 216, Quad 2)
set_property PACKAGE_PIN B6  [get_ports sfp1_tx_p]     ; # MGTP_B216_TX_P2
set_property PACKAGE_PIN A6  [get_ports sfp1_tx_n]     ; # MGTP_B216_TX_N2  
set_property PACKAGE_PIN B10 [get_ports sfp1_rx_p]     ; # MGTP_B216_RX_P2
set_property PACKAGE_PIN A10 [get_ports sfp1_rx_n]     ; # MGTP_B216_RX_N2

# SFP+ Interface 2 (Bank 216, Quad 3)  
set_property PACKAGE_PIN D7  [get_ports sfp2_tx_p]     ; # MGTP_B216_TX_P3
set_property PACKAGE_PIN C7  [get_ports sfp2_tx_n]     ; # MGTP_B216_TX_N3
set_property PACKAGE_PIN D9  [get_ports sfp2_rx_p]     ; # MGTP_B216_RX_P3
set_property PACKAGE_PIN C9  [get_ports sfp2_rx_n]     ; # MGTP_B216_RX_N3

# SFP+ Control Signals (if needed)
# set_property PACKAGE_PIN XX [get_ports sfp1_tx_disable]
# set_property PACKAGE_PIN XX [get_ports sfp1_mod_def0]
# set_property PACKAGE_PIN XX [get_ports sfp1_los]
# set_property PACKAGE_PIN XX [get_ports sfp2_tx_disable]
# set_property PACKAGE_PIN XX [get_ports sfp2_mod_def0]
# set_property PACKAGE_PIN XX [get_ports sfp2_los]

# ============================================================================
# GIGABIT ETHERNET INTERFACES (RGMII) - YT8531SH PHY
# ============================================================================

# ETH1 Interface (Gigabit Ethernet 1)
set_property PACKAGE_PIN Y22 [get_ports eth1_reset_n]          ; # ETH1_RESET_N

# ETH1 RGMII Data
set_property PACKAGE_PIN U22 [get_ports eth1_rgmii_rxd[0]]     ; # ETH1_RGMII_RXD0
set_property PACKAGE_PIN V22 [get_ports eth1_rgmii_rxd[1]]     ; # ETH1_RGMII_RXD1
set_property PACKAGE_PIN T21 [get_ports eth1_rgmii_rxd[2]]     ; # ETH1_RGMII_RXD2
set_property PACKAGE_PIN U21 [get_ports eth1_rgmii_rxd[3]]     ; # ETH1_RGMII_RXD3

# ETH1 RGMII Control
set_property PACKAGE_PIN V18 [get_ports eth1_rgmii_rx_dv]      ; # ETH1_RGMII_RX_DV
set_property PACKAGE_PIN W19 [get_ports eth1_rgmii_rx_clk]     ; # ETH1_RGMII_RX_CLK
set_property PACKAGE_PIN W20 [get_ports eth1_rgmii_tx_clk]     ; # ETH1_RGMII_TX_CLK
set_property PACKAGE_PIN U20 [get_ports eth1_rgmii_tx_en]      ; # ETH1_RGMII_TX_EN

# ETH1 RGMII Transmit Data
set_property PACKAGE_PIN W21  [get_ports eth1_rgmii_txd[0]]    ; # ETH1_RGMII_TXD0
set_property PACKAGE_PIN W22  [get_ports eth1_rgmii_txd[1]]    ; # ETH1_RGMII_TXD1
set_property PACKAGE_PIN AA20 [get_ports eth1_rgmii_txd[2]]    ; # ETH1_RGMII_TXD2
set_property PACKAGE_PIN AA21 [get_ports eth1_rgmii_txd[3]]    ; # ETH1_RGMII_TXD3

# ETH1 Management Interface
set_property PACKAGE_PIN V17 [get_ports eth1_mdio]             ; # ETH1_MDIO
set_property PACKAGE_PIN W17 [get_ports eth1_mdc]              ; # ETH1_MDC

# ETH2 Interface (Gigabit Ethernet 2)
set_property PACKAGE_PIN AB20 [get_ports eth2_reset_n]         ; # ETH2_RESET_N

# ETH2 RGMII Data
set_property PACKAGE_PIN AB21 [get_ports eth2_rgmii_rxd[0]]    ; # ETH2_RGMII_RXD0
set_property PACKAGE_PIN AB22 [get_ports eth2_rgmii_rxd[1]]    ; # ETH2_RGMII_RXD1
set_property PACKAGE_PIN AA18 [get_ports eth2_rgmii_rxd[2]]    ; # ETH2_RGMII_RXD2
set_property PACKAGE_PIN AB18 [get_ports eth2_rgmii_rxd[3]]    ; # ETH2_RGMII_RXD3

# ETH2 RGMII Control
set_property PACKAGE_PIN V19 [get_ports eth2_rgmii_rx_dv]      ; # ETH2_RGMII_RX_DV
set_property PACKAGE_PIN Y18 [get_ports eth2_rgmii_rx_clk]     ; # ETH2_RGMII_RX_CLK
set_property PACKAGE_PIN Y19 [get_ports eth2_rgmii_tx_clk]     ; # ETH2_RGMII_TX_CLK
set_property PACKAGE_PIN P20 [get_ports eth2_rgmii_tx_en]      ; # ETH2_RGMII_TX_EN

# ETH2 RGMII Transmit Data
set_property PACKAGE_PIN N13 [get_ports eth2_rgmii_txd[0]]     ; # ETH2_RGMII_TXD0
set_property PACKAGE_PIN N14 [get_ports eth2_rgmii_txd[1]]     ; # ETH2_RGMII_TXD1
set_property PACKAGE_PIN P16 [get_ports eth2_rgmii_txd[2]]     ; # ETH2_RGMII_TXD2
set_property PACKAGE_PIN R17 [get_ports eth2_rgmii_txd[3]]     ; # ETH2_RGMII_TXD3

# ETH2 Management Interface
set_property PACKAGE_PIN P14 [get_ports eth2_mdio]             ; # ETH2_MDIO
set_property PACKAGE_PIN R14 [get_ports eth2_mdc]              ; # ETH2_MDC

# ============================================================================
# I/O STANDARDS FOR ETHERNET
# ============================================================================

# ETH1 I/O Standards
set_property IOSTANDARD LVCMOS33 [get_ports eth1_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_rxd[*]]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_rx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_tx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_rgmii_txd[*]]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports eth1_mdc]

# ETH2 I/O Standards
set_property IOSTANDARD LVCMOS33 [get_ports eth2_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_rxd[*]]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_rx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_tx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_rgmii_txd[*]]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports eth2_mdc]

# ============================================================================
# TIMING CONSTRAINTS FOR WHITE RABBIT
# ============================================================================

# RGMII timing constraints (critical for WR precision)
# These constraints ensure proper setup/hold timing for RGMII interfaces

# ETH1 RGMII Clock Constraints
create_clock -period 8.000 -name eth1_rgmii_rx_clk [get_ports eth1_rgmii_rx_clk]
create_clock -period 8.000 -name eth1_rgmii_tx_clk [get_ports eth1_rgmii_tx_clk]

# ETH2 RGMII Clock Constraints  
create_clock -period 8.000 -name eth2_rgmii_rx_clk [get_ports eth2_rgmii_rx_clk]
create_clock -period 8.000 -name eth2_rgmii_tx_clk [get_ports eth2_rgmii_tx_clk]

# Input delay constraints for RGMII (adjust based on PCB trace delays)
set_input_delay -clock eth1_rgmii_rx_clk -max 2.0 [get_ports {eth1_rgmii_rxd[*] eth1_rgmii_rx_dv}]
set_input_delay -clock eth1_rgmii_rx_clk -min 0.5 [get_ports {eth1_rgmii_rxd[*] eth1_rgmii_rx_dv}]
set_input_delay -clock eth2_rgmii_rx_clk -max 2.0 [get_ports {eth2_rgmii_rxd[*] eth2_rgmii_rx_dv}]
set_input_delay -clock eth2_rgmii_rx_clk -min 0.5 [get_ports {eth2_rgmii_rxd[*] eth2_rgmii_rx_dv}]

# Output delay constraints for RGMII
set_output_delay -clock eth1_rgmii_tx_clk -max 2.0 [get_ports {eth1_rgmii_txd[*] eth1_rgmii_tx_en}]
set_output_delay -clock eth1_rgmii_tx_clk -min 0.5 [get_ports {eth1_rgmii_txd[*] eth1_rgmii_tx_en}]
set_output_delay -clock eth2_rgmii_tx_clk -max 2.0 [get_ports {eth2_rgmii_txd[*] eth2_rgmii_tx_en}]
set_output_delay -clock eth2_rgmii_tx_clk -min 0.5 [get_ports {eth2_rgmii_txd[*] eth2_rgmii_tx_en}]

# ============================================================================
# DEBUG AND CONTROL INTERFACES
# ============================================================================

# JTAG Interface (for debugging)
# set_property PACKAGE_PIN XX [get_ports tck]
# set_property PACKAGE_PIN XX [get_ports tdi]
# set_property PACKAGE_PIN XX [get_ports tdo]
# set_property PACKAGE_PIN XX [get_ports tms]

# User Buttons (1 reset + 2 user buttons)
# set_property PACKAGE_PIN XX [get_ports btn_reset]
# set_property PACKAGE_PIN XX [get_ports btn_user1]
# set_property PACKAGE_PIN XX [get_ports btn_user2]

# LEDs (if available)
# set_property PACKAGE_PIN XX [get_ports led[0]]
# set_property PACKAGE_PIN XX [get_ports led[1]]
# set_property PACKAGE_PIN XX [get_ports led[2]]
# set_property PACKAGE_PIN XX [get_ports led[3]]

# ============================================================================
# WHITE RABBIT SPECIFIC CONSTRAINTS
# ============================================================================

# PPS (Pulse Per Second) output - critical for WR synchronization
# set_property PACKAGE_PIN XX [get_ports wr_pps_out]
# set_property IOSTANDARD LVCMOS33 [get_ports wr_pps_out]

# External timing reference (if available)
# set_property PACKAGE_PIN XX [get_ports ext_ref_clk]
# set_property IOSTANDARD LVCMOS33 [get_ports ext_ref_clk]

# ============================================================================
# MEMORY INTERFACES
# ============================================================================

# DDR3 SDRAM (512MB, 32-bit) - uncomment if using DDR3
# NOTE: Use Vivado IP Core Generator for DDR3 controller
# The following are example constraints - actual DDR3 interface
# will be generated by the Memory Interface Generator (MIG)

# QSPI Flash (32MB) - for configuration and data storage
# set_property PACKAGE_PIN XX [get_ports qspi_clk]
# set_property PACKAGE_PIN XX [get_ports qspi_cs_n]
# set_property PACKAGE_PIN XX [get_ports qspi_dq[0]]
# set_property PACKAGE_PIN XX [get_ports qspi_dq[1]]
# set_property PACKAGE_PIN XX [get_ports qspi_dq[2]]
# set_property PACKAGE_PIN XX [get_ports qspi_dq[3]]

# ============================================================================
# ADDITIONAL BOARD FEATURES
# ============================================================================

# MicroSD Card Interface
# set_property PACKAGE_PIN XX [get_ports sd_clk]
# set_property PACKAGE_PIN XX [get_ports sd_cmd]
# set_property PACKAGE_PIN XX [get_ports sd_dat[0]]
# set_property PACKAGE_PIN XX [get_ports sd_dat[1]]
# set_property PACKAGE_PIN XX [get_ports sd_dat[2]]
# set_property PACKAGE_PIN XX [get_ports sd_dat[3]]

# HDMI Interfaces (if used for diagnostics)
# set_property PACKAGE_PIN XX [get_ports hdmi_in_clk]
# set_property PACKAGE_PIN XX [get_ports hdmi_out_clk]

# Camera Interface (CSI)
# set_property PACKAGE_PIN XX [get_ports csi_clk]
# set_property PACKAGE_PIN XX [get_ports csi_data[0]]
# set_property PACKAGE_PIN XX [get_ports csi_data[1]]

# PCIe Interface (if used)
# set_property PACKAGE_PIN XX [get_ports pcie_clk_p]
# set_property PACKAGE_PIN XX [get_ports pcie_clk_n]
# set_property PACKAGE_PIN XX [get_ports pcie_rst_n]

# ============================================================================
# BOARD-SPECIFIC NOTES
# ============================================================================
#
# MYD-J7A100T Board Specifications:
# - FPGA: Xilinx Artix-7 XC7A100T-2FGG484I
# - Package: 484-pin FineLine BGA
# - Speed Grade: -2 (industrial grade)
# - Logic Cells: 101,440
# - Block RAM: 4,860 Kb total
# - Memory: 512MB DDR3 + 32MB QSPI Flash + 256Kb EEPROM
# - Clock: 200 MHz differential LVDS
# - Dimensions: 70mm x 40mm SOM
#
# White Rabbit Implementation Notes:
# 1. Use SFP+ interfaces for WR fiber connections
# 2. RGMII interfaces can be used for copper WR (with appropriate PHY)
# 3. Ensure precise timing constraints for sub-nanosecond accuracy
# 4. Consider using external high-quality oscillators for best performance
# 5. Board supports dual WR ports for switch/node configurations
#
# ============================================================================
