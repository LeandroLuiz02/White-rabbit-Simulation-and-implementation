# run_vivado_sim.tcl
# Simple Vivado simulation script

# Set up project
create_project -force wr_sim_project ./vivado_sim_project -part xc7a100tfgg484-1

# Add only the basic testbench first
add_files testbenches/wr_standalone_basic_tb.sv

# Set top module
set_property top wr_standalone_basic_tb [current_fileset -simset]

# Update compile order
update_compile_order -fileset sources_1

# Run simulation
launch_simulation
run all

# Close project
close_project
