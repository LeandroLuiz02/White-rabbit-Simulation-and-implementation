# White Rabbit Two-Node - Advanced Vivado Simulation Script
# This script runs minimal_two_node.sv with real WR cores
# Requires: wr-cores repository and WRPC software
#
# USAGE: vivado -mode batch -source scripts/run_vivado.tcl
#

puts "========================================"
puts "White Rabbit Two-Node - Advanced Simulation"
puts "========================================"

# Check current directory
set current_dir [pwd]
puts "Current directory: $current_dir"

# Define expected files
set testbench_file "testbenches/minimal_two_node.sv"
set wr_cores_path "../wr-cores"

# Check if advanced testbench exists
if {![file exists $testbench_file]} {
    puts "ERROR: Advanced testbench not found: $testbench_file"
    puts ""
    puts "This script requires the advanced testbench with real WR cores."
    puts "For basic testing without dependencies, use:"
    puts "   vivado -mode batch -source scripts/run_vivado_test.tcl"
    puts ""
    return
}

puts "✓ Advanced testbench found: $testbench_file"

# Check for wr-cores (optional but recommended)
if {![file exists $wr_cores_path]} {
    puts "WARNING: wr-cores not found at: $wr_cores_path"
    puts "The simulation may not work without real WR cores."
    puts "You can:"
    puts "1. Clone wr-cores: git clone https://github.com/white-rabbit/wr-cores"
    puts "2. Use basic version: scripts/run_vivado_test.tcl"
    puts ""
    puts "Continuing anyway..."
} else {
    puts "✓ wr-cores found at: $wr_cores_path"
}

# Create project
puts ""
puts "Creating advanced WR project..."
set project_name "wr_advanced_project"
set project_dir "./vivado_advanced"

# Remove previous project if exists
if {[file exists $project_dir]} {
    puts "Removing previous project..."
    file delete -force $project_dir
}

# Create new project
create_project $project_name $project_dir -part xc7a100tcsg324-1
puts "✓ Project created in: $project_dir"

# Add testbench file
puts "Adding testbench to project..."
add_files -norecurse $testbench_file

# Try to add wr-cores files if available
if {[file exists $wr_cores_path]} {
    puts "Searching for WR core files..."
    
    # Common WR core files (adjust paths as needed)
    set wr_file_patterns {
        "modules/wr_endpoint/*.vhd"
        "modules/wr_softpll_ng/*.vhd" 
        "modules/timing/*.vhd"
        "platform/xilinx/*.vhd"
        "top/spec_1_1/*.vhd"
    }
    
    set found_files 0
    foreach pattern $wr_file_patterns {
        set files [glob -nocomplain $wr_cores_path/$pattern]
        if {[llength $files] > 0} {
            puts "Found [llength $files] files matching: $pattern"
            add_files -norecurse $files
            incr found_files [llength $files]
        }
    }
    
    if {$found_files > 0} {
        puts "✓ Added $found_files WR core files"
    } else {
        puts "⚠ No WR core files found - simulation may be limited"
    }
} else {
    puts "⚠ Skipping WR cores (not found)"
}

# Configure simulation
puts "Configuring simulation..."
set_property top minimal_two_node [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Set simulation runtime
set_property -name {xsim.simulate.runtime} -value {100ms} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

# Update compilation order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Configuration completed!"

# Launch simulation
puts ""
puts "🚀 Starting advanced simulation..."
puts "   Expected duration: ~2-3 minutes"
puts "   Simulation time: 100ms"
puts "   Note: This may take longer due to WR core complexity"
puts ""

# Try to launch simulation with error handling
if {[catch {launch_simulation} sim_error]} {
    puts ""
    puts "❌ SIMULATION FAILED"
    puts "Error: $sim_error"
    puts ""
    puts "Common issues:"
    puts "1. Missing WR cores - use scripts/run_vivado_test.tcl instead"
    puts "2. Missing VHDL libraries - check WR cores installation"
    puts "3. File path issues - verify wr-cores location"
    puts ""
    puts "For basic testing without dependencies:"
    puts "   vivado -mode batch -source scripts/run_vivado_test.tcl"
    return
}

puts ""
puts "========================================"
puts "✅ SUCCESS: Advanced simulation launched!"
puts "========================================"
puts ""
puts "📊 What's running:"
puts "   • Advanced WR testbench with real cores"
puts "   • Full White Rabbit protocol simulation"
puts "   • Extended simulation time (100ms)"
puts ""
puts "🎯 Next steps:"
puts "   1. Open project: vivado ./vivado_advanced/wr_advanced_project.xpr"
puts "   2. View waveforms: Flow → Open Simulation"
puts "   3. Monitor UART output for WR protocol messages"
puts ""
puts "📚 Documentation: docs/TECHNICAL_GUIDE.md"
puts "========================================"
