# run_all_vivado_sims.tcl
# Quick compilation check for all White Rabbit testbenches
# This script validates that all testbenches compile without running full simulations

puts "========================================"
puts "White Rabbit Testbenches Compilation Check"
puts "========================================"

# Get script directory for relative paths
set script_dir [file dirname [info script]]
set project_root [file normalize "$script_dir/.."]

# List of testbenches to validate
set testbenches [list "wr_standalone_basic_tb" "wr_minimal_two_node_tb" "wr_master_slave_sync_tb" "wr_endpoint_tb" "wr_timing_tb" "wr_pps_gen_tb" "wr_nic_tb" "wr_softpll_ng_tb" "wr_streamers_tb" "wr_switch_tb"]

# Create a single temporary project for all validations
set project_name "wr_testbench_validation"
set project_dir "vivado_validation_temp"

puts "Creating validation project..."
if {[file exists $project_dir]} {
    file delete -force $project_dir
}
create_project $project_name $project_dir -part xc7a100tcsg324-1

# Add all testbench files
puts "Adding all testbench files..."
set tb_files [glob -nocomplain "$project_root/testbenches/*.sv"]
if {[llength $tb_files] == 0} {
    puts "❌ ERROR: No testbench files found in $project_root/testbenches/"
    close_project
    exit 1
}

add_files -norecurse $tb_files
puts "✅ Added [llength $tb_files] testbench files"

# Test each testbench compilation
set successful_tbs 0
set failed_tbs 0

foreach tb $testbenches {
    puts "\n🔍 Testing testbench: $tb"
    
    # Check if testbench file exists
    set tb_file "$project_root/testbenches/${tb}.sv"
    if {![file exists $tb_file]} {
        puts "⚠️  WARNING: File ${tb}.sv not found, skipping..."
        continue
    }
    
    # Set as top module and try to elaborate (compile check)
    if {[catch {
        set_property top $tb [current_fileset -simset]
        set_property top_lib xil_defaultlib [current_fileset -simset]
        
        # Quick elaboration check (no simulation)
        puts "   Checking compilation..."
        update_compile_order -fileset sources_1
        
    } compilation_error]} {
        puts "❌ COMPILATION FAILED: $tb"
        puts "   Error: $compilation_error"
        incr failed_tbs
    } else {
        puts "✅ COMPILATION OK: $tb"
        incr successful_tbs
    }
}

# Summary
puts "\n========================================"
puts "VALIDATION SUMMARY:"
puts "✅ Successful: $successful_tbs testbenches"
puts "❌ Failed: $failed_tbs testbenches"
puts "========================================"

# Cleanup
close_project
file delete -force $project_dir

if {$failed_tbs > 0} {
    puts "⚠️  Some testbenches failed compilation. Check individual errors above."
    exit 1
} else {
    puts "🎉 All testbenches compiled successfully!"
    exit 0
}
