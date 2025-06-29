# Wave viewing script for White Rabbit two-node simulation

# Zoom to show full simulation
wave zoom full

# Set up wave groups with better organization
wave group new "System"
wave group insert end "System" /two_node_testbench/clk_125m
wave group insert end "System" /two_node_testbench/clk_20m  
wave group insert end "System" /two_node_testbench/rst_n

wave group new "Node 1 Status"
wave group insert end "Node 1 Status" /two_node_testbench/link_up_node1
wave group insert end "Node 1 Status" /two_node_testbench/pps_node1
wave group insert end "Node 1 Status" /two_node_testbench/uart_txd_node1

wave group new "Node 2 Status" 
wave group insert end "Node 2 Status" /two_node_testbench/link_up_node2
wave group insert end "Node 2 Status" /two_node_testbench/pps_node2
wave group insert end "Node 2 Status" /two_node_testbench/uart_txd_node2

wave group new "UART Data"
wave group insert end "UART Data" /two_node_testbench/uart_data_node1
wave group insert end "UART Data" /two_node_testbench/uart_valid_node1
wave group insert end "UART Data" /two_node_testbench/uart_data_node2
wave group insert end "UART Data" /two_node_testbench/uart_valid_node2

wave group new "Physical Link"
wave group insert end "Physical Link" /two_node_testbench/sfp_txp_1to2
wave group insert end "Physical Link" /two_node_testbench/sfp_txn_1to2
wave group insert end "Physical Link" /two_node_testbench/sfp_txp_2to1
wave group insert end "Physical Link" /two_node_testbench/sfp_txn_2to1

# Expand all groups by default
wave group expand "System"
wave group expand "Node 1 Status"
wave group expand "Node 2 Status"
wave group expand "UART Data"

# Set display format for some signals
wave radix -hex /two_node_testbench/uart_data_node1
wave radix -hex /two_node_testbench/uart_data_node2

# Set colors for better visualization
wave color Yellow /two_node_testbench/pps_node1
wave color Orange /two_node_testbench/pps_node2
wave color Green /two_node_testbench/link_up_node1
wave color Green /two_node_testbench/link_up_node2

echo "Wave view configured. Look for:"
echo "1. Clock and reset behavior"
echo "2. Link establishment (link_up signals)"
echo "3. PPS synchronization between nodes"
echo "4. UART debug messages"
