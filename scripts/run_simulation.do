# ModelSim/QuestaSim simulation script for White Rabbit two-node example

# Create work library
vlib work

# Set the simulation time resolution
.main clear

# Add source files - adjust paths according to your wr-cores installation
vlog -sv +incdir+../../../wr-cores/sim \
     +incdir+../../../wr-cores/modules/wr_endpoint \
     +incdir+../../../wr-cores/modules/fabric \
     +incdir+../../../wr-cores/modules/wrc_core/lib \
     two_node_testbench.sv \
     ../../../wr-cores/top/spec_ref_design/spec_wr_ref_top.vhd \
     ../../../wr-cores/modules/wrc_core/wr_core.vhd

# Start simulation
vsim -t 1ps work.two_node_testbench

# Add signals to wave window
add wave -group "Clocks & Reset" \
    /two_node_testbench/clk_125m \
    /two_node_testbench/clk_20m \
    /two_node_testbench/rst_n

add wave -group "Node 1 (Master)" \
    /two_node_testbench/uart_txd_node1 \
    /two_node_testbench/link_up_node1 \
    /two_node_testbench/pps_node1 \
    /two_node_testbench/uart_data_node1 \
    /two_node_testbench/uart_valid_node1

add wave -group "Node 2 (Slave)" \
    /two_node_testbench/uart_txd_node2 \
    /two_node_testbench/link_up_node2 \
    /two_node_testbench/pps_node2 \
    /two_node_testbench/uart_data_node2 \
    /two_node_testbench/uart_valid_node2

add wave -group "Interconnection" \
    /two_node_testbench/sfp_txp_1to2 \
    /two_node_testbench/sfp_txn_1to2 \
    /two_node_testbench/sfp_txp_2to1 \
    /two_node_testbench/sfp_txn_2to1

# Configure wave window
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Run simulation
echo "Starting White Rabbit two-node simulation..."
run 50ms

echo "Simulation completed. Use 'wave zoom full' to see all waveforms."
