# White Rabbit Two-Node Implementation Guide

## What is White Rabbit?

White Rabbit is a precision time protocol that provides sub-nanosecond synchronization over Ethernet networks. Originally developed at CERN for particle accelerator timing, it's now used in scientific instrumentation, telecommunications, and industrial applications requiring ultra-precise timing.

### Key Specifications
- **Synchronization accuracy**: < 1 nanosecond
- **Jitter**: < 100 picoseconds RMS  
- **Stability**: Parts per billion over time
- **Protocol**: Enhanced IEEE 1588 (PTP) with hardware timestamping
- **Physical layer**: 1000Base-X Ethernet with SFP+ transceivers

## Project Architecture

### System Overview
```
┌─────────────┐    Ethernet    ┌─────────────┐
│   Node 1    │◄──────────────►│   Node 2    │
│ (Master/GM) │   1000Base-X   │  (Slave)    │  
└─────────────┘                └─────────────┘
      │                              │
   Clock Ref                    Sync to Node 1
  (125 MHz)                    (PTP Protocol)
```

### Implementation Levels

#### 1. **Basic Level: Simulation Framework**
- **File**: `simple_wr_testbench.sv`
- **Purpose**: Concept demonstration without external dependencies
- **Features**: 
  - Simulated SPEC nodes with basic interfaces
  - Clock generation and basic signal monitoring
  - Ethernet link simulation
  - UART activity indication
- **Best for**: Understanding structure, testing Vivado setup

#### 2. **Intermediate Level: Minimal Real Implementation**
- **File**: `minimal_two_node.sv`
- **Purpose**: Simplest possible real White Rabbit setup
- **Features**:
  - Real WR core instantiation (requires wr-cores)
  - Basic UART monitoring
  - Fundamental clock domains
  - Link establishment
- **Best for**: Learning real WR protocol basics

#### 3. **Advanced Level: Enhanced Monitoring**
- **File**: `simple_two_node.sv`
- **Purpose**: Production-like setup with comprehensive monitoring
- **Features**:
  - Enhanced UART decoding and analysis
  - Link status detailed monitoring
  - PTP message tracking
  - Structured debugging output
- **Best for**: Development and detailed analysis

#### 4. **Expert Level: Full Implementation**
- **File**: `two_node_testbench.sv` 
- **Purpose**: Complete White Rabbit network simulation
- **Features**:
  - Comprehensive PTP protocol monitoring
  - PPS synchronization verification
  - Multiple clock domain analysis
  - Production-ready testing framework
- **Best for**: Advanced development and validation

## White Rabbit Synchronization Process

### 1. Initialization Phase
- Both nodes boot embedded LM32 processors
- Hardware initialization and self-test
- Ethernet PHY configuration
- Clock subsystem setup

### 2. Link Establishment
- Physical layer link detection
- Gigabit Ethernet autonegotiation
- White Rabbit-specific link training
- Bidirectional communication established

### 3. Master Election
- Node 1 configured as Grandmaster Clock (GM)
- Node 2 operates as ordinary clock (slave)
- Best Master Clock Algorithm (BMCA) if needed
- Master announces its presence via PTP

### 4. Time Synchronization
The precision synchronization uses enhanced PTP protocol:

```
Master (Node 1)          Slave (Node 2)
      │                        │
      ├─── Sync Message ──────►│  (T1 timestamp)
      │                        │
      │◄─── Delay_Req ─────────┤  (T2 timestamp)
      │                        │  
      ├─── Delay_Resp ────────►│  (T3, T4 timestamps)
      │                        │
```

**Timestamps**:
- **T1**: Master transmission time of Sync message
- **T2**: Slave reception time of Sync message  
- **T3**: Slave transmission time of Delay_Req
- **T4**: Master reception time of Delay_Req

**Calculation**:
- **Offset** = ((T2 - T1) - (T4 - T3)) / 2
- **Delay** = ((T2 - T1) + (T4 - T3)) / 2

### 5. Clock Adjustment
- Slave adjusts local clock based on calculated offset
- Phase-Locked Loop (PLL) for smooth tracking
- VCXO (Voltage Controlled Crystal Oscillator) fine-tuning
- Continuous monitoring and adjustment

## Technical Implementation Details

### Clock Architecture
```
Reference Clock (125 MHz)
    │
    ├── System Clock (62.5 MHz)
    ├── Ethernet Clock (125 MHz)  
    └── VCXO Clock (Variable)
```

### Memory Requirements
- **LM32 Program Memory**: ~64KB for WRPC software
- **Packet Buffer Memory**: Additional RAM for network buffering
- **Configuration Registers**: Control and status interfaces

### Signal Interfaces

#### **Clock Inputs**
- `clk_125m_pllref_p/n_i`: Differential reference clock
- System generates internal clocks from this reference

#### **Ethernet (SFP)**  
- `sfp_txp/n_o`: Differential transmit data
- `sfp_rxp/n_i`: Differential receive data
- Additional SFP control signals for module management

#### **Timing Outputs**
- `pps_p/n_o`: Pulse-per-second outputs (differential)
- `dac_*`: VCXO control signals
- `onewire_b`: Temperature sensor interface

#### **Debug Interfaces**
- `uart_txd_o`: Serial debug output
- Various GPIO and LED indicators

## Simulation Environment Setup

### Vivado Configuration
The testbenches are designed for Xilinx Vivado XSim simulator:

- **Target FPGA**: Xilinx 7-series (xc7a100tcsg324-1)
- **Language**: SystemVerilog with mixed VHDL cores
- **Simulation time**: Configurable (default 10ms for basic tests)
- **Waveform capture**: Full signal recording for analysis

### ModelSim Alternative
Alternative scripts support Mentor ModelSim/QuestaSim:

- **Compilation order**: Managed via .do scripts
- **Library management**: Automatic VHDL library setup
- **Waveform**: Configured via wave.do script

## Expected Simulation Behavior

### Boot Sequence (First ~100µs)
1. **Reset release**: All modules come out of reset
2. **Clock stabilization**: PLLs lock to reference
3. **LM32 boot**: Processors start executing WRPC software
4. **Hardware init**: Ethernet PHY and timing subsystems initialize

### Link Establishment (~1ms)
1. **Physical detection**: Ethernet link training
2. **Protocol negotiation**: White Rabbit extensions enabled
3. **Link up indication**: Status registers updated
4. **UART messages**: "Link established" debug output

### Synchronization Process (~10ms)
1. **PTP messaging**: Master begins announce/sync messages
2. **Clock tracking**: Slave begins measuring offset
3. **Loop convergence**: PLL achieves lock
4. **Sync achievement**: Sub-nanosecond accuracy reached

### Steady State (Ongoing)
1. **Continuous PTP**: Regular sync message exchange
2. **Clock maintenance**: Ongoing fine adjustments
3. **Status monitoring**: UART reports system health
4. **PPS alignment**: Output pulses synchronized between nodes

## Customization and Extension

### Adding More Nodes
```systemverilog
// Example 3-node extension
spec_top wr_node3 (
    .clk_125m_pllref_p_i(clk_125m),
    .clk_125m_pllref_n_i(~clk_125m),
    .uart_txd_o(uart_txd_node3),
    // Connect to switch/hub for star topology
    .sfp_rxp_i(switch_to_node3_p),
    .sfp_rxn_i(switch_to_node3_n),
    .sfp_txp_o(node3_to_switch_p),
    .sfp_txn_o(node3_to_switch_n)
);
```

### Custom Applications
```systemverilog
// Example: Synchronized data acquisition
always @(posedge pps_node1) begin
    // Trigger precise measurements
    adc_trigger <= 1'b1;
    timestamp <= current_time;
end
```

### Different FPGA Platforms
The design can be adapted for:
- **Intel/Altera**: Modify clock management and I/O standards
- **Microsemi**: Adapt SERDES and clock resources  
- **Lattice**: Adjust for available primitives

## Performance Optimization

### Simulation Speed
- **Reduce time resolution**: Use ns instead of ps for faster simulation
- **Limit signals**: Record only essential waveforms
- **Checkpoint/restore**: Save simulation states for quick restart

### Real Hardware
- **Clock quality**: Use high-quality reference oscillators
- **PCB design**: Minimize jitter through careful layout
- **Environmental**: Temperature and vibration control

This implementation provides a comprehensive foundation for understanding and working with White Rabbit precision timing networks, suitable for both educational purposes and as a starting point for custom developments.
