# run_vivado_sim.tcl
# Simple Vivado simulation script

# Set up project
create_project -force wr_sim_project ./vivado_sim_project -part xc7a100tfgg484-1

# Add source files
add_files [glob testbenches/*.sv]

# Set top module
set_property top wr_standalone_basic_tb [current_fileset -simset]

# Run simulation
launch_simulation
run all

# Close project
close_project
