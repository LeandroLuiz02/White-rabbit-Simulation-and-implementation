# Minimal two-node simulation script
# This should work with the existing WR Course examples structure

# Create the work library
vlib work

# Set the WR Course path - adjust if needed
set WR_COURSE_SIM "../../course\ code\ examples/WR-Course/sim"

# Add the WR Course simulation includes
vlog -sv +incdir+$WR_COURSE_SIM \
         minimal_two_node.sv

# Note: You will need to compile the spec_top module as well
# This would typically be done by including the appropriate WR core files
# For now, this script shows the structure

echo "To complete this simulation, you need to:"
echo "1. Compile the spec_top module from WR cores"
echo "2. Include all necessary WR core dependencies"
echo "3. Ensure the WRC software binary is available"
echo ""
echo "Example compilation (adjust paths):"
echo "vlog +incdir+../../wr-cores/sim ../../wr-cores/top/spec_ref_design/spec_wr_ref_top.vhd"

# Start simulation (uncomment when spec_top is available)
# vsim -t 1ps work.minimal_two_node_wr

# Add waves
# add wave -group "Clocks" /minimal_two_node_wr/ref_clk
# add wave -group "UART" /minimal_two_node_wr/uart_node1 /minimal_two_node_wr/uart_node2  
# add wave -group "Ethernet" /minimal_two_node_wr/gb_txp /minimal_two_node_wr/gb_txn

# Run simulation
# run 200ms
