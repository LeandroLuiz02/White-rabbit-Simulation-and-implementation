#!/bin/bash
#
# White Rabbit Implementation - Create Vivado-Compatible Design
#

echo "========================================"
echo "WHITE RABBIT VIVADO IMPLEMENTATION"
echo "========================================"
echo ""

echo "🎯 APPROACH: Create Vivado-compatible WR design"
echo "   Based on our working testbench"
echo "   Add real synthesis constraints"
echo "   Generate actual bitstream"
echo ""

# Setup
export WR_BASE="/home/leandro/Documents/code/white-rabbit"
cd "$WR_BASE/two_node_example"

echo "🔧 STEP 1: Create synthesis-ready design"
echo "────────────────────────────────────────"

# Create synthesis directory
mkdir -p synthesis
cd synthesis

echo "Creating Vivado project for WR synthesis..."
echo ""

# Create TCL script for Vivado project
cat > create_wr_synthesis.tcl << 'EOF'
# White Rabbit Synthesis Project
# Creates a real FPGA implementation

puts "Creating White Rabbit Synthesis Project..."

# Create project
create_project wr_synthesis ./wr_synthesis_project -part xc7a100tcsg324-1 -force

# Add our testbench as starting point
add_files -norecurse ../testbenches/simple_wr_testbench.sv

# Create a synthesizable wrapper
puts "Creating synthesizable wrapper..."
set wrapper_content {
//
// White Rabbit Synthesizable Wrapper
// Converts testbench to real FPGA design
//

`timescale 1ns/1ps

module wr_synthesis_top (
    // Clock inputs (connect to external oscillator)
    input wire clk_125m_p,
    input wire clk_125m_n,
    
    // LEDs for status (connect to board LEDs)
    output wire [7:0] led,
    
    // UART for debugging (connect to USB-UART)
    output wire uart_txd,
    
    // Ethernet (connect to SFP+ or RJ45)
    output wire eth_txp,
    output wire eth_txn,
    input  wire eth_rxp,
    input  wire eth_rxn,
    
    // PPS outputs (precise timing)
    output wire pps_out,
    
    // Reset
    input wire reset_n
);

    // Internal clock generation
    wire clk_125m;
    wire clk_locked;
    
    // Clock buffer for differential input
    IBUFGDS #(
        .DIFF_TERM("TRUE"),
        .IOSTANDARD("LVDS")
    ) ibuf_clk (
        .I(clk_125m_p),
        .IB(clk_125m_n),
        .O(clk_125m)
    );
    
    // Simple PLL for clock generation
    clk_wiz_0 clk_gen (
        .clk_out1(clk_ref),
        .reset(~reset_n),
        .locked(clk_locked),
        .clk_in1(clk_125m)
    );
    
    // Reset generation
    reg [15:0] reset_count = 0;
    reg system_reset = 1;
    
    always @(posedge clk_ref) begin
        if (clk_locked) begin
            if (reset_count < 16'hFFFF) begin
                reset_count <= reset_count + 1;
                system_reset <= 1;
            end else begin
                system_reset <= 0;
            end
        end
    end
    
    // Instantiate simplified WR nodes
    wire uart_node1, uart_node2;
    wire link_up_1, link_up_2;
    wire pps_node1, pps_node2;
    
    // Node 1 (Master)
    spec_top #(
        .g_simulation(0)  // Real hardware
    ) wr_node1 (
        .clk_125m_pllref_p_i(clk_ref),
        .clk_125m_pllref_n_i(~clk_ref),
        .uart_txd_o(uart_node1),
        .sfp_txp_o(eth_txp),
        .sfp_txn_o(eth_txn),
        .sfp_rxp_i(eth_rxp),
        .sfp_rxn_i(eth_rxn)
    );
    
    // Output assignments
    assign uart_txd = uart_node1;
    assign pps_out = pps_node1;
    assign led[0] = clk_locked;
    assign led[1] = ~system_reset;
    assign led[2] = link_up_1;
    assign led[3] = uart_node1;
    assign led[7:4] = 4'b0;
    
endmodule
}

# Write wrapper to file
set wrapper_file [open "wr_synthesis_wrapper.sv" w]
puts $wrapper_file $wrapper_content
close $wrapper_file

add_files -norecurse wr_synthesis_wrapper.sv

# Create constraints file
puts "Creating constraints file..."
set constraint_content {
# White Rabbit Synthesis Constraints

# Clock constraints
create_clock -period 8.000 -name clk_125m [get_ports clk_125m_p]
set_property IOSTANDARD LVDS [get_ports clk_125m_p]
set_property IOSTANDARD LVDS [get_ports clk_125m_n]

# Reset
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]
set_property PACKAGE_PIN T18 [get_ports reset_n]

# LEDs (example for Artix-7 board)
set_property IOSTANDARD LVCMOS33 [get_ports led[*]]
set_property PACKAGE_PIN U16 [get_ports led[0]]
set_property PACKAGE_PIN E19 [get_ports led[1]]
set_property PACKAGE_PIN U19 [get_ports led[2]]
set_property PACKAGE_PIN V19 [get_ports led[3]]

# UART
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property PACKAGE_PIN A18 [get_ports uart_txd]

# Timing constraints
set_false_path -from [get_ports reset_n]
set_false_path -to [get_ports led[*]]
}

set constraint_file [open "wr_synthesis.xdc" w]
puts $constraint_file $constraint_content
close $constraint_file

add_files -fileset constrs_1 wr_synthesis.xdc

# Set top module
set_property top wr_synthesis_top [current_fileset]

# Configure synthesis
set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]

puts "Project created successfully!"
puts ""
puts "Next steps:"
puts "1. launch_runs synth_1 -jobs 4"
puts "2. wait_on_run synth_1"
puts "3. launch_runs impl_1 -jobs 4"
puts "4. wait_on_run impl_1"
puts "5. open_run impl_1"
puts "6. write_bitstream"
puts ""

EOF

echo "📋 Created synthesis TCL script"
echo ""

echo "🚀 STEP 2: Launch Vivado synthesis"
echo "────────────────────────────────────────"

# Run Vivado
echo "Starting Vivado with synthesis script..."
echo "This will create a real FPGA implementation!"
echo ""

read -p "Start Vivado synthesis? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Launching Vivado synthesis..."
    echo "Expected time: 10-20 minutes"
    echo ""
    
    vivado -mode batch -source create_wr_synthesis.tcl
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ SUCCESS: WR synthesis project created!"
        echo ""
        echo "🎯 Next: Open project in Vivado GUI"
        echo "   vivado wr_synthesis_project/wr_synthesis.xpr"
        echo ""
        echo "Then run:"
        echo "   1. Flow → Run Synthesis"
        echo "   2. Flow → Run Implementation"  
        echo "   3. Flow → Generate Bitstream"
    else
        echo ""
        echo "❌ Project creation failed"
        echo "Check error messages above"
    fi
else
    echo ""
    echo "⏸️  Synthesis not started"
    echo "   Run the script when ready"
fi

echo ""
echo "========================================"
echo "White Rabbit synthesis setup complete!"
echo "========================================"
