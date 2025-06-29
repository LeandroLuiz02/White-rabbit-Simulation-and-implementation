# Simple two-node ModelSim script
# Based on the WR Course lesson structure

# Create work library
vlib work

# Set paths to WR cores - adjust these to match your installation
set WR_CORES_PATH "../../../wr-cores"
set WR_COURSE_PATH "../../course\ code\ examples/WR-Course"

# Compile the simple two-node testbench
vlog -sv +incdir+$WR_COURSE_PATH/sim \
     +incdir+$WR_CORES_PATH/sim \
     simple_two_node.sv

# You'll need to add the spec_top module compilation here
# This depends on your specific WR cores installation structure

# Start simulation
vsim -t 1ps work.simple_two_node_wr

# Add basic signals to wave
add wave /simple_two_node_wr/clk
add wave /simple_two_node_wr/uart_txd_node1
add wave /simple_two_node_wr/uart_txd_node2
add wave /simple_two_node_wr/uart_data_node1
add wave /simple_two_node_wr/uart_data_node2
add wave /simple_two_node_wr/uart_valid_node1  
add wave /simple_two_node_wr/uart_valid_node2
add wave /simple_two_node_wr/link_node1_to_node2_p
add wave /simple_two_node_wr/link_node1_to_node2_n

# Run simulation
echo "Starting simple two-node simulation..."
run 100ms
