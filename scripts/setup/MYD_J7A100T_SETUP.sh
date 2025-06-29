#!/bin/bash
#
# MYD-J7A100T White Rabbit Implementation Setup
# Board-specific configuration for MYIR MYD-J7A100T
#

echo "========================================"
echo "MYD-J7A100T WHITE RABBIT SETUP"
echo "========================================"
echo ""

echo "🎯 TARGET HARDWARE:"
echo "   Board: MYD-J7A100T (MYIR Technology)"
echo "   FPGA: Xilinx Artix-7 family"
echo "   Purpose: Real 2-node White Rabbit network"
echo ""

echo "🔍 STEP 1: BOARD RESEARCH"
echo "────────────────────────────────────────"
echo ""

echo "📋 What we need to find out about your MYD-J7A100T:"
echo ""
echo "1. EXACT FPGA PART NUMBER:"
echo "   • Likely: xc7a100t-2fgg484c or xc7a100t-1fgg484c"
echo "   • Speed grade: -1 or -2"
echo "   • Package: fgg484, csg324, or similar"
echo ""

echo "2. CLOCK SOURCES:"
echo "   • Main oscillator frequency (usually 50MHz, 100MHz, or 200MHz)"
echo "   • Available clock inputs"
echo "   • Clock generation capabilities"
echo ""

echo "3. ETHERNET INTERFACE:"
echo "   • Type: RGMII, RMII, or dedicated Gigabit PHY"
echo "   • PHY chip model (for WR compatibility)"
echo "   • Connector type (RJ45, SFP, SFP+)"
echo ""

echo "4. I/O ASSIGNMENTS:"
echo "   • LED connections (for status indication)"
echo "   • Button/switch connections (for reset)"
echo "   • UART connections (for debugging)"
echo "   • GPIO availability"
echo ""

echo "🔍 STEP 2: INFORMATION GATHERING"
echo "────────────────────────────────────────"
echo ""

# Check if user has board documentation
read -p "Do you have the MYD-J7A100T user manual or schematic? (y/n): " -n 1 -r
echo
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "✅ Great! Please look for these specifications:"
    echo ""
    echo "🔍 IN THE DOCUMENTATION, FIND:"
    echo ""
    echo "1. FPGA Part Number:"
    echo "   Look for: 'FPGA: XC7A100T-[speed]-[package]'"
    echo "   Example: XC7A100T-2FGG484C"
    echo ""
    echo "2. Clock Section:"
    echo "   Look for: 'System Clock', 'Reference Clock', or 'Crystal Oscillator'"
    echo "   Note the frequency (MHz)"
    echo ""
    echo "3. Ethernet Section:"
    echo "   Look for: 'Gigabit Ethernet', 'PHY', or 'RJ45'"
    echo "   Note the PHY chip part number"
    echo ""
    echo "4. Connector/Pin Assignments:"
    echo "   Look for: pin assignment tables or I/O mapping"
    echo ""
    
    read -p "Press Enter when you have this information ready..."
    echo ""
    
    echo "📝 Please provide the following information:"
    echo ""
    
    read -p "FPGA Part Number (e.g., xc7a100t-2fgg484c): " fpga_part
    read -p "Main Clock Frequency (e.g., 50, 100, 200): " clock_freq
    read -p "Ethernet PHY Type (e.g., RGMII, RMII, Direct): " eth_type
    read -p "Board has LEDs? (y/n): " -n 1 has_leds
    echo ""
    read -p "Board has UART? (y/n): " -n 1 has_uart
    echo ""
    echo ""
    
    echo "📋 COLLECTED INFORMATION:"
    echo "   FPGA: $fpga_part"
    echo "   Clock: ${clock_freq}MHz"
    echo "   Ethernet: $eth_type"
    echo "   LEDs: $has_leds"
    echo "   UART: $has_uart"
    echo ""
    
    # Create board-specific configuration
    echo "🔧 CREATING BOARD CONFIGURATION..."
    
    cat > myd_j7a100t_config.tcl << EOF
# MYD-J7A100T Board Configuration
# Generated configuration for White Rabbit implementation

# FPGA Part
set_property PART $fpga_part [current_project]

# Clock constraints
create_clock -period [expr 1000.0/$clock_freq] -name sys_clk [get_ports sys_clk]

# Ethernet configuration (example - needs board-specific pins)
# TODO: Add actual pin assignments from board documentation

# LED assignments (example - update with actual pins)
if {"$has_leds" == "y"} {
    set_property PACKAGE_PIN [PIN_TBD] [get_ports led[0]]
    set_property IOSTANDARD LVCMOS33 [get_ports led[0]]
}

# UART assignments (example - update with actual pins)  
if {"$has_uart" == "y"} {
    set_property PACKAGE_PIN [PIN_TBD] [get_ports uart_txd]
    set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
}

puts "MYD-J7A100T configuration loaded"
puts "FPGA: $fpga_part"
puts "Clock: ${clock_freq}MHz"
EOF

    echo "✅ Basic configuration created: myd_j7a100t_config.tcl"
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "1. Update pin assignments in the config file"
    echo "2. Create synthesis project with correct part number"
    echo "3. Generate board-specific bitstream"
    
else
    echo "📚 RECOMMENDATION: Get MYD-J7A100T documentation"
    echo ""
    echo "🔍 WHERE TO FIND IT:"
    echo "1. MYIR Technology website: www.myirtech.com"
    echo "2. Product page for MYD-J7A100T"
    echo "3. Downloads section for:"
    echo "   • User Manual"
    echo "   • Schematic (if available)"
    echo "   • Pin assignment files"
    echo "   • Example projects"
    echo ""
    echo "🎯 ALTERNATIVE: Create generic Artix-7 design first"
    echo "   We can start with generic constraints and refine later"
    
    read -p "Create generic Artix-7 design now? (y/n): " -n 1 -r
    echo
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔧 Creating generic Artix-7 configuration..."
        
        cat > artix7_generic_config.tcl << 'EOF'
# Generic Artix-7 Configuration for White Rabbit
# Will work on most Artix-7 boards, can be customized later

# Common Artix-7 part (update when you know exact part)
set_property PART xc7a100t-1csg324c [current_project]

# Generic clock constraint (100MHz - common for dev boards)
create_clock -period 10.000 -name sys_clk [get_ports sys_clk]

# Generic I/O standards
set_property IOSTANDARD LVCMOS33 [get_ports led[*]]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]

# Generic pin assignments (WILL NEED BOARD-SPECIFIC UPDATE)
# These are placeholders - DO NOT USE on real hardware without verification
# set_property PACKAGE_PIN E3 [get_ports sys_clk]    # Update for your board
# set_property PACKAGE_PIN H17 [get_ports led[0]]    # Update for your board  
# set_property PACKAGE_PIN K15 [get_ports uart_txd]  # Update for your board

puts "Generic Artix-7 configuration loaded"
puts "WARNING: Pin assignments are placeholders - update for MYD-J7A100T"
EOF

        echo "✅ Generic configuration created: artix7_generic_config.tcl"
        echo ""
        echo "⚠️  IMPORTANT: This uses generic settings"
        echo "   Update with MYD-J7A100T specifics before using on real hardware"
    fi
fi

echo ""
echo "🎯 IMMEDIATE NEXT ACTIONS:"
echo ""
echo "1. 📚 Obtain MYD-J7A100T documentation"
echo "2. 🔧 Update configuration with exact specifications"
echo "3. 🏗️  Create synthesis project with board-specific settings"
echo "4. ✅ Validate design on actual hardware"
echo ""

echo "========================================"
echo "Board research phase initiated!"
echo "Next: Get exact MYD-J7A100T specifications"
echo "========================================"
