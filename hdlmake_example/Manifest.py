# HDLMake Example for Two-Node White Rabbit Project
# This is a minimal, working configuration that demonstrates HDLMake usage

target = "xilinx"  
action = "synthesis"

# Device configuration for Artix-7 (modern FPGA)
syn_device = "xc7a100t"
syn_grade = "-1"
syn_package = "csg324"
syn_top = "two_node_wr_top"
syn_project = "two_node_wr_example"
syn_tool = "vivado"

# Local files only - no external dependencies
files = [
    "two_node_wr_top.vhd",
    "../testbenches/wr_standalone_basic_tb.sv"
]
