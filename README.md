# White Rabbit Two-Node Implementation

## Overview

This project provides a complete White Rabbit timing network implementation designed for FPGA development boards. White Rabbit is a high-precision timing protocol developed at CERN that enables sub-nanosecond synchronization across distributed systems.

The project includes educational testbenches, synthesis-ready HDL code, and comprehensive documentation to help you understand and implement White Rabbit technology.

## What is White Rabbit?

White Rabbit is an extension of IEEE 1588 Precision Time Protocol (PTP) that achieves sub-nanosecond timing accuracy over Ethernet networks. It's used in particle accelerators, financial trading systems, and other applications requiring precise time synchronization.

**Key Features:**
- Sub-nanosecond timing precision
- Ethernet-based network protocol
- Master-slave synchronization topology
- Hardware timestamping
- Fiber optic and copper support

## Quick Start

### Basic Simulation
```bash
# Run simple White Rabbit simulation
cd scripts
vivado -source run_vivado_simple.tcl
```

### Project Verification
```bash
./test.sh                    # Verify project integrity
./cleanup.sh                 # Clean temporary files
```

## Project Structure

```
white-rabbit-two-node/
├── docs/                    # Technical documentation
├── testbenches/            # SystemVerilog testbenches (10 files)
├── scripts/                # Simulation and build scripts
│   ├── *.tcl              # Vivado simulation scripts
│   ├── *.do               # ModelSim simulation scripts
│   └── build/             # Synthesis scripts
├── constraints/           # FPGA constraint files
├── hdlmake_example/       # Working HDLMake example
└── reports/              # Verification reports
```

## Simulation Options

### 1. Basic Simulation (No Dependencies)
```bash
vivado -mode batch -source run_vivado_simple.tcl
```
- **Testbench**: `wr_standalone_basic_tb.sv`
- **Purpose**: Learn basic White Rabbit concepts
- **Dependencies**: None (runs immediately)

### 2. Component-Specific Simulations
```bash
vivado -source scripts/run_vivado_sim.tcl
# or
vsim -do scripts/run_modelsim_sim.do
```
- **Testbenches**: 10 specialized testbenches
- **Purpose**: Understand individual WR components
- **Components**: PLL, timestamping, synchronization

### 3. Complete System Simulation
```bash
vivado -source scripts/run_vivado_full.tcl
```
- **Testbench**: `wr_master_slave_sync_tb.sv`
- **Purpose**: Full two-node White Rabbit system
- **Features**: Master-slave synchronization

## Hardware Implementation

### Target Platform
- **Primary**: MYD-J7A100T Development Board
- **FPGA**: Xilinx Artix-7 XC7A100T-2FGG484I
- **Interfaces**: Dual SFP+, Gigabit Ethernet (RGMII)

### Synthesis Setup
```bash
./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh
```

The project includes complete constraint files with accurate pin assignments for the MYD-J7A100T board.

## Testbenches Included

The project contains 10 educational testbenches covering different aspects of White Rabbit:

1. **wr_standalone_basic_tb.sv** - Basic standalone test
2. **wr_minimal_two_node_tb.sv** - Minimal two-node setup  
3. **wr_endpoint_tb.sv** - Physical interface testing
4. **wr_timing_tb.sv** - Timing and timestamping
5. **wr_softpll_ng_tb.sv** - Software PLL algorithms
6. **wr_pps_gen_tb.sv** - PPS pulse generation
7. **wr_nic_tb.sv** - Network interface card
8. **wr_streamers_tb.sv** - Deterministic data transfer
9. **wr_switch_tb.sv** - Multi-port switching
10. **wr_master_slave_sync_tb.sv** - Complete synchronization
├── 📋 constraints/            # MYD-J7A100T templates
## Documentation

### Technical Guides
- **TECHNICAL_GUIDE.md** - White Rabbit protocol details
- **IMPLEMENTATION_GUIDE.md** - Step-by-step implementation
- **MYD_J7A100T_DETAILED_SPECS.md** - Complete board specifications
- **VIVADO_SETUP.md** - Development environment setup

### Quick References
- **PROJECT_MANIFEST.md** - Technical specifications
- **PROJECT_EXECUTIVE_SUMMARY.md** - Complete project overview

## Requirements

### Software
- **Xilinx Vivado** 2019.2 or later
- **ModelSim** (optional, for advanced simulations)

### Hardware (for real implementation)
- **MYD-J7A100T** Development Board or compatible Artix-7 board
- **SFP+ modules** (White Rabbit compatible)
- **Fiber optic cables** for inter-node connections

## Learning Path

1. **Start with basic simulation** to understand White Rabbit concepts
2. **Explore component testbenches** to learn individual modules
3. **Run complete system simulation** to see master-slave operation
4. **Review technical documentation** for implementation details
5. **Synthesize for hardware** when ready for real deployment

## Features

- **Educational**: Progressive testbenches from basic to advanced
- **Complete**: All necessary files for FPGA implementation
- **Documented**: Comprehensive technical documentation
- **Tested**: Verified simulation and synthesis flows
- **Professional**: Industry-standard project organization

## Support

For technical questions about White Rabbit protocol, refer to:
- CERN White Rabbit Project documentation
- Open Hardware Repository (OHWR)
- White Rabbit specification documents

## License

This project is provided for educational and research purposes. Please refer to individual file headers for specific licensing information.  
