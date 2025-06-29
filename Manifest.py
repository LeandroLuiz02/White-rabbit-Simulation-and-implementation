#!/usr/bin/env python3

# HDLMake manifest for White Rabbit two-node example

target = "xilinx"
action = "simulation"

# Include paths for White Rabbit cores
include_dirs = [
    "../../../wr-cores/sim",
    "../../../wr-cores/modules/wr_endpoint", 
    "../../../wr-cores/modules/fabric",
    "../../../wr-cores/modules/wrc_core/lib",
    "../../../wr-cores/modules/wr_streamers",
    "../../../wr-cores/modules/wrc_core",
]

# Source files for simulation
files = [
    "two_node_testbench.sv",
]

# White Rabbit core dependencies
modules = {
    "local" : [
        "../../../wr-cores/top/spec_ref_design",
        "../../../wr-cores/modules/wrc_core", 
        "../../../wr-cores/modules/wr_endpoint",
        "../../../wr-cores/modules/fabric",
        "../../../wr-cores/modules/wr_streamers",
        "../../../wr-cores/modules/timing",
        "../../../wr-cores/modules/wr_softpll_ng",
        "../../../wr-cores/board/common",
    ]
}

# Simulator settings
sim_tool = "modelsim"
sim_top = "two_node_testbench"

# Additional simulation options
vlog_opt = "+incdir+../../../wr-cores/sim"
vcom_opt = ""
vsim_opt = "-t 1ps"
