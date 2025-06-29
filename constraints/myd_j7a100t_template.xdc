#
# MYD-J7A100T White Rabbit Constraints Template
# BOARD: MYIR MYD-J7A100T (Artix-7)
#
# NOTE: This is a TEMPLATE file. You MUST adapt it to your actual board!
#       Use your board documentation to fill in the correct pin assignments.
#

# ============================================================================
# FPGA Configuration
# ============================================================================
# TODO: Replace with your exact FPGA part number from:
# vivado -mode tcl -> connect_hw_server; open_hw_target; current_hw_device
#
# Expected options for MYD-J7A100T:
# - xc7a100t-2fgg484c  (speed grade -2, package fgg484)
# - xc7a100t-1fgg484c  (speed grade -1, package fgg484)
# - xc7a100t-2csg324c  (speed grade -2, package csg324)

# ============================================================================
# CLOCK CONSTRAINTS - WHITE RABBIT CRITICAL TIMING
# ============================================================================

# Main system clock - TODO: Replace XX with actual pin
# Common frequencies: 50MHz, 100MHz, 200MHz
# set_property PACKAGE_PIN XX [get_ports clk_sys_i]
# set_property IOSTANDARD LVCMOS33 [get_ports clk_sys_i]

# Create primary clock constraint - adjust frequency to match your board
# create_clock -period 10.000 -name clk_sys [get_ports clk_sys_i]  # 100MHz example
# create_clock -period 20.000 -name clk_sys [get_ports clk_sys_i]  # 50MHz example

# White Rabbit requires precise 125MHz reference
# This will be generated internally from your main clock via MMCM/PLL

# Reference clock for Ethernet PHY (if externally provided)
# set_property PACKAGE_PIN XX [get_ports clk_125m_pllref_p]
# set_property PACKAGE_PIN XX [get_ports clk_125m_pllref_n]
# set_property IOSTANDARD LVDS [get_ports clk_125m_pllref_p]
# set_property IOSTANDARD LVDS [get_ports clk_125m_pllref_n]

# ============================================================================
# RESET AND CONTROL SIGNALS
# ============================================================================

# Global reset - typically from a button or external signal
# set_property PACKAGE_PIN XX [get_ports rst_n_i]
# set_property IOSTANDARD LVCMOS33 [get_ports rst_n_i]

# ============================================================================
# ETHERNET INTERFACE - CRITICAL FOR WHITE RABBIT
# ============================================================================

# The Ethernet interface type depends on your board design:
# Option 1: RGMII interface to external PHY
# Option 2: SGMII interface with integrated PHY
# Option 3: Direct fiber interface (SFP/SFP+)

# EXAMPLE: RGMII Interface (most common on development boards)
# TODO: Replace XX with actual pins from your board documentation

# RGMII TX signals
# set_property PACKAGE_PIN XX [get_ports {rgmii_txd[0]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_txd[1]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_txd[2]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_txd[3]}]
# set_property PACKAGE_PIN XX [get_ports rgmii_tx_ctl]
# set_property PACKAGE_PIN XX [get_ports rgmii_txc]

# RGMII RX signals  
# set_property PACKAGE_PIN XX [get_ports {rgmii_rxd[0]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_rxd[1]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_rxd[2]}]
# set_property PACKAGE_PIN XX [get_ports {rgmii_rxd[3]}]
# set_property PACKAGE_PIN XX [get_ports rgmii_rx_ctl]
# set_property PACKAGE_PIN XX [get_ports rgmii_rxc]

# RGMII I/O standards (adjust to match your board)
# set_property IOSTANDARD LVCMOS25 [get_ports rgmii_*]

# RGMII timing constraints (critical for Gigabit Ethernet)
# create_clock -period 8.000 -name rgmii_rxc [get_ports rgmii_rxc]
# create_clock -period 8.000 -name rgmii_txc [get_ports rgmii_txc]

# ============================================================================
# DEBUG AND STATUS INTERFACES
# ============================================================================

# LEDs for status indication - TODO: Replace XX with actual pins
# set_property PACKAGE_PIN XX [get_ports {led_o[0]}]
# set_property PACKAGE_PIN XX [get_ports {led_o[1]}]
# set_property PACKAGE_PIN XX [get_ports {led_o[2]}]
# set_property PACKAGE_PIN XX [get_ports {led_o[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports led_o*]

# UART for debugging - TODO: Replace XX with actual pins
# set_property PACKAGE_PIN XX [get_ports uart_rxd_i]
# set_property PACKAGE_PIN XX [get_ports uart_txd_o]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_*]

# ============================================================================
# WHITE RABBIT SPECIFIC TIMING CONSTRAINTS
# ============================================================================

# White Rabbit requires sub-nanosecond timing precision
# These constraints ensure proper timing closure for WR functionality

# Clock domain crossing constraints
# set_clock_groups -asynchronous -group [get_clocks clk_sys] -group [get_clocks rgmii_rxc]

# Input delay constraints for RGMII (adjust based on board trace lengths)
# set_input_delay -clock rgmii_rxc -max 2.0 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
# set_input_delay -clock rgmii_rxc -min 0.5 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]

# Output delay constraints for RGMII
# set_output_delay -clock rgmii_txc -max 1.0 [get_ports {rgmii_txd[*] rgmii_tx_ctl}]
# set_output_delay -clock rgmii_txc -min -0.5 [get_ports {rgmii_txd[*] rgmii_tx_ctl}]

# ============================================================================
# BOARD-SPECIFIC OPTIMIZATIONS
# ============================================================================

# Configuration settings for Artix-7
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Bitstream generation settings
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

# ============================================================================
# INSTRUCTIONS FOR COMPLETING THIS FILE
# ============================================================================

# STEP 1: Find your board documentation
#   - Download MYD-J7A100T user manual from MYIR website
#   - Locate schematic or pin assignment tables
#   - Identify FPGA part number, clock sources, and I/O connections

# STEP 2: Identify your FPGA using Vivado
#   vivado -mode tcl
#   connect_hw_server
#   open_hw_target
#   current_hw_device
#   # This shows exact part number: xc7aXXXt-XxxxXXXc

# STEP 3: Update this constraints file
#   - Replace all "XX" with actual pin numbers
#   - Adjust clock frequencies to match your board
#   - Set correct I/O standards (LVCMOS33, LVCMOS25, etc.)
#   - Configure Ethernet interface type (RGMII/SGMII/SFP)

# STEP 4: Validate constraints
#   - Use Vivado pin planner to verify pin assignments
#   - Check for I/O standard conflicts
#   - Ensure timing constraints are reasonable

# STEP 5: Test with simple design
#   - Start with LED blinker to verify basic constraints
#   - Add UART echo test for communication verification
#   - Finally integrate full White Rabbit design

# ============================================================================
# RESOURCES FOR YOUR BOARD RESEARCH
# ============================================================================

# MYIR Technology websites:
#   http://www.myirtech.com/
#   Search for "MYD-J7A100T" documentation

# Xilinx Artix-7 resources:
#   7 Series FPGAs Configurable Logic Block User Guide (UG474)
#   7 Series FPGAs SelectIO Resources User Guide (UG471)
#   7 Series FPGAs Clocking Resources User Guide (UG472)

# White Rabbit timing requirements:
#   CERN White Rabbit specification
#   Sub-nanosecond synchronization requirements
#   IEEE 1588 PTP protocol considerations
