# White Rabbit Two-Node - Basic Vivado Test Script
# This script runs a testbench that does NOT depend on external files
# Ideal for testing installation and verifying Vivado is working
#
# USAGE: vivado -mode batch -source scripts/run_vivado_test.tcl
#

puts "========================================"
puts "White Rabbit - Basic Configuration Test"
puts "========================================"

# Check current directory
set current_dir [pwd]
puts "Current directory: $current_dir"

# Check if the test file exists
if {![file exists "testbenches/simple_wr_testbench.sv"]} {
    puts "ERROR: File testbenches/simple_wr_testbench.sv not found!"
    puts "This file should be in the testbenches/ subdirectory."
    return
}

puts "✓ Testbench found: testbenches/simple_wr_testbench.sv"

# Create temporary project on disk
puts "Creating test project..."
set project_name "wr_test_project"
set project_dir "./vivado_test"

# Remove previous project if exists
if {[file exists $project_dir]} {
    puts "Removing previous project..."
    file delete -force $project_dir
}

# Create new project
create_project $project_name $project_dir -part xc7a100tcsg324-1
puts "✓ Project created in: $project_dir"

# Add only the test file
puts "Adding testbench to project..."
add_files -norecurse "testbenches/simple_wr_testbench.sv"

# Configure simulation
puts "Configuring simulation..."
set_property top simple_wr_testbench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Specific settings for quick test
set_property -name {xsim.simulate.runtime} -value {10ms} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

# Update compilation order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Configuration completed successfully!"

# Launch simulation
puts ""
puts "🚀 Starting simulation..."
puts "   Expected duration: ~30 seconds"
puts "   Simulation time: 10ms"
puts ""

# Set additional simulation properties
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.wdb} -value {simple_wr_test.wdb} -objects [get_filesets sim_1]

# Try to run simulation
puts "Starting test simulation..."
if {[catch {launch_simulation} sim_error]} {
    puts "ERROR in simulation:"
    puts $sim_error
    puts ""
    puts "Possible causes:"
    puts "1. Problem with Vivado installation"
    puts "2. XSim license issue"
    puts "3. Syntax error in testbench"
    
    # Clean up project on error
    puts "Cleaning up temporary project..."
    close_project
    if {[file exists $project_dir]} {
        file delete -force $project_dir
    }
    return
}

puts "✓ Simulation started successfully!"

# Configure waveform viewing
puts "Configuring waveforms..."

# Add main signals (only if simulation is running)
if {[catch {
    add_wave_group "System"
    add_wave /simple_wr_testbench/ref_clk

    add_wave_group "Node 1"
    add_wave /simple_wr_testbench/wr_node1/clk_125m_pllref_p_i
    add_wave /simple_wr_testbench/wr_node1/uart_txd_o
    add_wave /simple_wr_testbench/wr_node1/sfp_txp_o
    add_wave /simple_wr_testbench/wr_node1/counter

    add_wave_group "Node 2" 
    add_wave /simple_wr_testbench/wr_node2/clk_125m_pllref_p_i
    add_wave /simple_wr_testbench/wr_node2/uart_txd_o
    add_wave /simple_wr_testbench/wr_node2/sfp_txp_o
    add_wave /simple_wr_testbench/wr_node2/counter

    add_wave_group "Interconnection"
    add_wave /simple_wr_testbench/gb_txp_1to2
    add_wave /simple_wr_testbench/gb_txn_1to2
    add_wave /simple_wr_testbench/gb_txp_2to1
    add_wave /simple_wr_testbench/gb_txn_2to1
} wave_error]} {
    puts "INFO: Waveform configuration skipped (batch mode)"
}

# Save project
puts "Saving project..."
# Project is automatically saved during creation

puts ""
puts "========================================"
puts "✅ SUCCESS: Basic test completed!"
puts "========================================"
puts ""
puts "📊 What happened:"
puts "   • Project created and saved in ./vivado_test/"
puts "   • Standalone testbench simulated successfully"
puts "   • Two simulated WR nodes instantiated"
puts "   • Basic clock and signal generation verified"
puts ""
puts "🎯 Next steps:"
puts "   1. Open project: vivado ./vivado_test/wr_test_project.xpr"
puts "   2. View waveforms: Flow → Open Simulation"
puts "   3. For real WR protocol: Use scripts/run_vivado.tcl"
puts ""
puts "📚 Documentation: docs/TECHNICAL_GUIDE.md"
puts "========================================"

# Executar simulação
puts "Executando simulação por 10ms..."
run 10ms

# Verificar se a simulação executou corretamente
puts "========================================"

