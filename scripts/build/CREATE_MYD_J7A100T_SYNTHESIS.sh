#!/bin/bash
#
# MYD-J7A100T White Rabbit Synthesis Script
# Creates a complete Vivado synthesis project for your board
#

echo "==========================================================="
echo "MYD-J7A100T WHITE RABBIT SYNTHESIS SETUP"
echo "==========================================================="
echo ""

# Setup environment
export WR_BASE="/home/leandro/Documents/code/white-rabbit"
export PROJECT_BASE="$WR_BASE/two_node_example"
export WR_CORES="$WR_BASE/wr-cores"
export CONSTRAINTS_DIR="$PROJECT_BASE/constraints"

echo "🎯 TARGET: Real White Rabbit implementation on MYD-J7A100T"
echo "   FPGA: Xilinx Artix-7 family"
echo "   Board: MYIR MYD-J7A100T"
echo "   Goal: Sub-nanosecond synchronization network"
echo ""

# Verify prerequisites
echo "🔍 CHECKING PREREQUISITES:"
echo "────────────────────────────────────────────────────────────"

# Check if Vivado is available
if ! command -v vivado &> /dev/null; then
    echo "❌ Vivado not found in PATH"
    echo "   Please source Vivado settings: source /opt/Xilinx/Vivado/2023.2/settings64.sh"
    exit 1
else
    echo "✅ Vivado found: $(which vivado)"
fi

# Check if WR-cores exists
if [ ! -d "$WR_CORES" ]; then
    echo "❌ WR-cores not found at: $WR_CORES"
    echo "   Please ensure wr-cores repository is present"
    exit 1
else
    echo "✅ WR-cores found: $WR_CORES"
fi

# Check if constraints template exists
if [ ! -f "$CONSTRAINTS_DIR/myd_j7a100t_template.xdc" ]; then
    echo "❌ Constraints template not found"
    echo "   Expected: $CONSTRAINTS_DIR/myd_j7a100t_template.xdc"
    exit 1
else
    echo "✅ Constraints template found"
fi

echo ""

# Create synthesis directory
SYNTH_DIR="$PROJECT_BASE/synthesis/myd_j7a100t"
mkdir -p "$SYNTH_DIR"

echo "🏗️  CREATING SYNTHESIS PROJECT:"
echo "────────────────────────────────────────────────────────────"
echo "   Directory: $SYNTH_DIR"
echo ""

# Create Vivado TCL script for synthesis
cat > "$SYNTH_DIR/create_project.tcl" << 'EOF'
#
# Vivado TCL script for MYD-J7A100T White Rabbit synthesis
#

# IMPORTANT: You MUST update this with your exact FPGA part number!
# Find it using: vivado -> connect_hw_server -> open_hw_target -> current_hw_device
#
# Common options for MYD-J7A100T:
# - xc7a100t-2fgg484c (speed grade -2, package fgg484)
# - xc7a100t-1fgg484c (speed grade -1, package fgg484)
# - xc7a100t-2csg324c (speed grade -2, package csg324)

set FPGA_PART "xc7a100t-2fgg484c"  ;# TODO: Update with your exact part!

# Project settings
set PROJECT_NAME "wr_myd_j7a100t"
set PROJECT_DIR [pwd]

# Create project
create_project $PROJECT_NAME $PROJECT_DIR/$PROJECT_NAME -part $FPGA_PART -force

# Set project properties
set_property target_language VHDL [current_project]
set_property simulator_language Mixed [current_project]

puts "✅ Created project for FPGA: $FPGA_PART"

# Add White Rabbit source files
# NOTE: This is a simplified example. Real WR implementation requires:
# - Complete wr-cores HDL hierarchy
# - Platform-specific adaptations  
# - Proper IP core integration

puts "📋 Adding White Rabbit source files..."

# Add constraint files
puts "📋 Adding constraint files..."
add_files -fileset constrs_1 "../constraints/myd_j7a100t_template.xdc"

# Import files into project
import_files -force -norecurse

puts ""
puts "🎯 PROJECT CREATED SUCCESSFULLY!"
puts "────────────────────────────────────────────────────────────"
puts ""
puts "⚠️  CRITICAL NEXT STEPS REQUIRED:"
puts ""
puts "1. UPDATE FPGA PART NUMBER:"
puts "   → Edit this script and set correct FPGA_PART"
puts "   → Use Vivado hardware manager to detect exact part"
puts ""
puts "2. COMPLETE CONSTRAINT FILE:"
puts "   → Edit: ../constraints/myd_j7a100t_template.xdc"
puts "   → Replace XX with actual pin numbers from board manual"
puts "   → Set correct clock frequencies and I/O standards"
puts ""
puts "3. ADD WHITE RABBIT HDL SOURCES:"
puts "   → Currently only constraints are added"
puts "   → Need to integrate wr-cores HDL hierarchy"
puts "   → Requires platform-specific adaptations"
puts ""
puts "4. CONFIGURE FOR YOUR BOARD:"
puts "   → Identify Ethernet interface type (RGMII/SGMII/SFP)"
puts "   → Configure clock generation for 125MHz WR reference"
puts "   → Set up debug interfaces (UART, LEDs)"
puts ""
puts "💡 RECOMMENDED WORKFLOW:"
puts "────────────────────────────────────────────────────────────"
puts "1. Start with simple LED blinker design"
puts "2. Add UART communication for debugging"
puts "3. Integrate Ethernet interface"
puts "4. Add White Rabbit timing components"
puts "5. Complete WR node implementation"
puts ""
puts "🎯 This ensures each step works before adding complexity!"
puts ""

# Save project
save_project

puts "✨ Project saved as: [current_project]"
puts "   Location: $PROJECT_DIR/$PROJECT_NAME"
EOF

echo "📝 CREATED: Vivado synthesis project script"
echo "   File: $SYNTH_DIR/create_project.tcl"
echo ""

# Create a simple test design for initial validation
cat > "$SYNTH_DIR/led_blinker_test.vhd" << 'EOF'
--
-- Simple LED blinker for MYD-J7A100T board validation
-- This design tests basic FPGA functionality before adding White Rabbit complexity
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_blinker_test is
    Port (
        -- Clock and reset
        clk_sys_i    : in  STD_LOGIC;  -- Main board clock (50MHz, 100MHz, etc.)
        rst_n_i      : in  STD_LOGIC;  -- Reset button (active low)
        
        -- LEDs for status indication
        led_o        : out STD_LOGIC_VECTOR(3 downto 0);
        
        -- UART for debugging (optional)
        uart_txd_o   : out STD_LOGIC;
        uart_rxd_i   : in  STD_LOGIC
    );
end led_blinker_test;

architecture Behavioral of led_blinker_test is
    
    -- Clock divider for LED blinking (adjust for your clock frequency)
    signal counter    : unsigned(25 downto 0) := (others => '0');
    signal led_reg    : std_logic_vector(3 downto 0) := "0001";
    
    -- Reset synchronizer
    signal rst_sync   : std_logic_vector(2 downto 0) := "000";
    signal rst_n      : std_logic;
    
begin

    -- Reset synchronizer (good practice for FPGA designs)
    process(clk_sys_i)
    begin
        if rising_edge(clk_sys_i) then
            rst_sync <= rst_sync(1 downto 0) & rst_n_i;
        end if;
    end process;
    
    rst_n <= rst_sync(2);
    
    -- LED blinker and rotator
    process(clk_sys_i)
    begin
        if rising_edge(clk_sys_i) then
            if rst_n = '0' then
                counter <= (others => '0');
                led_reg <= "0001";
            else
                counter <= counter + 1;
                
                -- Rotate LEDs every ~1 second (adjust counter MSB for your clock)
                if counter(25) = '1' then  -- For 100MHz clock: 2^26/100MHz ≈ 0.67s
                    counter <= (others => '0');
                    led_reg <= led_reg(2 downto 0) & led_reg(3);
                end if;
            end if;
        end if;
    end process;
    
    -- Output assignments
    led_o <= led_reg;
    
    -- Simple UART loopback for testing
    uart_txd_o <= uart_rxd_i;
    
end Behavioral;
EOF

echo "📝 CREATED: Test design for board validation"
echo "   File: $SYNTH_DIR/led_blinker_test.vhd"
echo ""

# Create build script
cat > "$SYNTH_DIR/build_project.sh" << 'EOF'
#!/bin/bash
#
# Build script for MYD-J7A100T White Rabbit project
#

echo "🚀 BUILDING MYD-J7A100T WHITE RABBIT PROJECT"
echo "=============================================="

# Step 1: Create Vivado project
echo ""
echo "📋 Step 1: Creating Vivado project..."
vivado -mode batch -source create_project.tcl

if [ $? -eq 0 ]; then
    echo "✅ Project created successfully"
else
    echo "❌ Project creation failed"
    exit 1
fi

echo ""
echo "🎯 NEXT STEPS:"
echo "──────────────────────────────────────────────"
echo "1. Open project in Vivado GUI:"
echo "   vivado wr_myd_j7a100t/wr_myd_j7a100t.xpr"
echo ""
echo "2. Complete constraints file:"
echo "   → Update pin assignments in constraints file"
echo "   → Verify FPGA part number is correct"
echo ""
echo "3. Add your design sources:"
echo "   → Start with led_blinker_test.vhd for validation"
echo "   → Then integrate White Rabbit components"
echo ""
echo "4. Run synthesis and implementation:"
echo "   → Check for timing violations"
echo "   → Generate bitstream for programming"
echo ""

EOF

chmod +x "$SYNTH_DIR/build_project.sh"

echo "📝 CREATED: Build script"
echo "   File: $SYNTH_DIR/build_project.sh"
echo ""

# Create usage instructions
cat > "$SYNTH_DIR/README.md" << 'EOF'
# MYD-J7A100T White Rabbit Synthesis

## Quick Start

### 1. Update Hardware Configuration
Before synthesis, you MUST identify your exact hardware:

```bash
# Find your FPGA part number
vivado -mode tcl
# In Vivado TCL console:
connect_hw_server
open_hw_target  
current_hw_device
# Note the exact part number (e.g., xc7a100t-2fgg484c)
```

### 2. Complete Constraints File
Edit `../constraints/myd_j7a100t_template.xdc`:
- Replace "XX" with actual pin numbers from your board manual
- Set correct clock frequencies (50MHz, 100MHz, etc.)
- Configure I/O standards (LVCMOS33, LVCMOS25, etc.)

### 3. Build Project
```bash
./build_project.sh
```

### 4. Open in Vivado
```bash
vivado wr_myd_j7a100t/wr_myd_j7a100t.xpr
```

## Files Overview

- `create_project.tcl` - Vivado project creation script
- `led_blinker_test.vhd` - Simple test design for board validation
- `build_project.sh` - Automated build script
- `../constraints/myd_j7a100t_template.xdc` - Board constraints template

## Implementation Strategy

### Phase 1: Basic Validation
1. Use `led_blinker_test.vhd` to verify:
   - FPGA programming works
   - Clock and reset functionality
   - LED outputs working
   - Basic I/O pin assignments

### Phase 2: Communication
2. Add UART communication:
   - Echo test for UART pins
   - Simple command interface
   - Debug message output

### Phase 3: Ethernet Interface
3. Integrate Ethernet functionality:
   - RGMII/SGMII interface configuration
   - PHY initialization and control
   - Basic packet transmission/reception

### Phase 4: White Rabbit Integration
4. Add White Rabbit components:
   - wr-cores HDL integration
   - PTP protocol implementation
   - Sub-nanosecond timing precision
   - Master/Slave node configuration

## Critical Requirements

### Timing Constraints
White Rabbit requires sub-nanosecond precision:
- Proper clock domain crossing constraints
- Accurate input/output delay specifications
- Meeting setup/hold times for high-speed interfaces

### Resource Utilization
Monitor FPGA resource usage:
- Block RAM for packet buffers
- DSP slices for timing calculations
- Logic utilization for protocol processing
- I/O pins for Ethernet interface

### Board Compatibility
Ensure compatibility with MYD-J7A100T:
- Verify Ethernet PHY type and configuration
- Confirm clock source availability (125MHz reference)
- Check I/O voltage levels and standards
- Validate pin assignments against board schematic

## Troubleshooting

### Common Issues
1. **Timing violations**: Adjust clock constraints and optimize logic
2. **I/O standard conflicts**: Verify board voltage levels
3. **Resource overutilization**: Optimize design or use larger FPGA
4. **Pin assignment errors**: Double-check against board documentation

### Debug Strategies
1. Start with simple LED blinker
2. Add UART for debug messages
3. Test each interface incrementally
4. Use Vivado ILA for internal signal monitoring

EOF

echo "📝 CREATED: Documentation and instructions"
echo "   File: $SYNTH_DIR/README.md"
echo ""

echo "✅ SYNTHESIS ENVIRONMENT SETUP COMPLETE!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📁 Created synthesis environment at:"
echo "   $SYNTH_DIR"
echo ""
echo "📋 Files created:"
echo "   ├── create_project.tcl      # Vivado project setup"
echo "   ├── led_blinker_test.vhd    # Simple test design"
echo "   ├── build_project.sh        # Automated build"
echo "   ├── README.md               # Documentation"
echo "   └── ../constraints/myd_j7a100t_template.xdc  # Board constraints"
echo ""

echo "🎯 IMMEDIATE NEXT STEPS:"
echo "────────────────────────────────────────────────────────────"
echo ""
echo "1. IDENTIFY YOUR HARDWARE:"
echo "   cd $SYNTH_DIR"
echo "   vivado -mode tcl"
echo "   # In Vivado: connect_hw_server; open_hw_target; current_hw_device"
echo ""
echo "2. UPDATE CONSTRAINTS:"
echo "   # Edit: $CONSTRAINTS_DIR/myd_j7a100t_template.xdc"
echo "   # Replace XX with actual pins from board manual"
echo ""
echo "3. CREATE PROJECT:"
echo "   cd $SYNTH_DIR"
echo "   ./build_project.sh"
echo ""
echo "4. VALIDATE WITH SIMPLE DESIGN:"
echo "   # Start with led_blinker_test.vhd"
echo "   # Verify basic FPGA functionality"
echo ""

echo "💡 BOARD RESEARCH REMINDER:"
echo "────────────────────────────────────────────────────────────"
echo "• Download MYD-J7A100T manual from MYIR website"
echo "• Identify exact FPGA part number and speed grade"
echo "• Locate pin assignments for clocks, LEDs, UART, Ethernet"
echo "• Determine Ethernet interface type (RGMII/SGMII/SFP)"
echo "• Find reference clock sources and frequencies"
echo ""

echo "🚀 YOU'RE READY TO BUILD REAL WHITE RABBIT HARDWARE!"
echo "════════════════════════════════════════════════════════════"
