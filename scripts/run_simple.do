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
     ../testbenches/wr_standalone_basic_tb.sv

# You'll need to add the spec_top module compilation here
# This depends on your specific WR cores installation structure

# Start simulation
vsim -t 1ps work.wr_standalone_basic_tb

# Add basic signals to wave
add wave /wr_standalone_basic_tb/clk
add wave /wr_standalone_basic_tb/rst_n  
add wave /wr_standalone_basic_tb/uart_txd
add wave /wr_standalone_basic_tb/uart_rxd

# Run simulation
echo "Starting simple two-node simulation..."
run 100ms
