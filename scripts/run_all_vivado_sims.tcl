# run_all_vivado_sims.tcl
# Run all Vivado simulations

set testbenches [list "wr_master_slave_sync_tb" "wr_minimal_two_node_tb" "wr_standalone_basic_tb"]

foreach tb $testbenches {
    puts "Running simulation for: $tb"
    
    # Create project for this testbench
    create_project -force ${tb}_project ./vivado_${tb}_project -part xc7a100tfgg484-1
    
    # Add source files
    add_files [glob testbenches/*.sv]
    
    # Set top module
    set_property top $tb [current_fileset -simset]
    
    # Run simulation
    launch_simulation
    run all
    
    # Close project
    close_project
    
    puts "Completed simulation for: $tb"
}
