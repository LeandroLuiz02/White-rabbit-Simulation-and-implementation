# run_full_simulations.tcl
# Execute complete simulations for selected White Rabbit testbenches
# This script actually runs the simulations (takes longer)

puts "========================================"
puts "White Rabbit Full Simulations"
puts "========================================"

# Get script directory for relative paths
set script_dir [file dirname [info script]]
set project_root [file normalize "$script_dir/.."]

# Select testbenches for full simulation (only the most important ones)
set testbenches [list "wr_standalone_basic_tb" "wr_minimal_two_node_tb" "wr_master_slave_sync_tb"]

foreach tb $testbenches {
    puts "\n🎯 Running FULL simulation for: $tb"
    
    # Create project for this testbench
    set project_name "${tb}_sim"
    set project_dir "vivado_${tb}_temp"
    
    if {[file exists $project_dir]} {
        file delete -force $project_dir
    }
    
    create_project $project_name $project_dir -part xc7a100tcsg324-1
    
    # Add source files
    puts "   Adding testbench files..."
    add_files -norecurse "$project_root/testbenches/${tb}.sv"
    
    # Set top module
    set_property top $tb [current_fileset -simset]
    set_property top_lib xil_defaultlib [current_fileset -simset]
    
    # Configure simulation (shorter time for batch processing)
    set_property -name {xsim.simulate.runtime} -value {10ms} -objects [get_filesets sim_1]
    set_property -name {xsim.simulate.log_all_signals} -value {false} -objects [get_filesets sim_1]
    
    # Run simulation
    puts "   Launching simulation..."
    if {[catch {launch_simulation} sim_error]} {
        puts "❌ ERROR: Simulation failed for $tb"
        puts "   Error: $sim_error"
        close_project
        continue
    }
    
    puts "   Running simulation for 10ms..."
    run 10ms
    
    puts "✅ Completed full simulation for: $tb"
    
    # Close project and cleanup
    close_project
    file delete -force $project_dir
}

puts "\n========================================"
puts "🎉 All full simulations completed!"
puts "========================================"
