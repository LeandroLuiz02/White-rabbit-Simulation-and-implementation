# 📋 MYD-J7A100T Board Specifications

**Board**: MYIR MYD-J7A100T Development Board  
**FPGA**: Xilinx Artix-7 XC7A100T-2FGG484I  
**Application**: White Rabbit Two-Node Implementation  
**For Complete Technical Details**: See `MYD_J7A100T_DETAILED_SPECS.md`

## 🔧 HARDWARE OVERVIEW

### **FPGA Core**
- **Model**: Xilinx Artix-7 XC7A100T-2FGG484I
- **Logic Cells**: 101,440
- **Block RAM**: 4,860 Kb total (135 blocks × 36Kb)
- **DSP Slices**: 240 DSP48E1 slices
- **GTP Transceivers**: 4 transceivers (500 Mbps to 6.6 Gbps)
- **Package**: 484-pin FineLine BGA (FGG484)
- **Speed Grade**: -2 (Industrial, -40°C to +100°C)

### **Memory System**
- **DDR3 SDRAM**: 512MB (32-bit @ 666 MHz)
- **QSPI Flash**: 32MB (Quad SPI @ 108 MHz)
- **EEPROM**: 256KB (I2C for board ID + calibration)

### **Physical Form**
- **SOM Dimensions**: 70mm × 40mm × 12mm
- **Total Weight**: ~75g (SOM + carrier)
- **Operating Temperature**: -40°C to +85°C
- **Power Consumption**: 5-10W typical

## 🌐 NETWORK INTERFACES (White Rabbit Ready)

### **SFP+ High-Speed Transceivers (2x)**
Primary interfaces for White Rabbit timing synchronization using GTP Bank 216

| Port | TX+ | TX- | RX+ | RX- | Control Pins |
|------|-----|-----|-----|-----|--------------|
| **SFP1** | B6 | A6 | B10 | A10 | MOD_ABS(D11), TX_FAULT(G11) |
| **SFP2** | D7 | C7 | D9 | C9 | MOD_ABS(B11), TX_FAULT(F10) |

**Capabilities:**
- Speed: 500 Mbps to 6.6 Gbps (WR uses 1.25 Gbps)
- Timing Precision: Sub-nanosecond
- Reference Clock: 125 MHz from SFP+ module
- Bank: X0Y0 (GTP Quad 216)

### **Gigabit Ethernet - YT8531SH PHY (2x)**
Secondary RGMII interfaces for copper networking

#### **ETH1 (RGMII)**
| Function | Pins | Direction |
|----------|------|-----------|
| **RX Data** | Y22, U22, U21, V22 | Input |
| **RX Control** | T21 (CLK), V18 (DV) | Input |
| **TX Data** | W19, W20, W21, W22 | Output |
| **TX Control** | V20 (CLK), U20 (EN) | Output |
| **Management** | V16 (MDC), W16 (MDIO) | Bidir |

#### **ETH2 (RGMII)**
| Function | Pins | Direction |
|----------|------|-----------|
| **RX Data** | AB20, AB21, AB18, AB19 | Input |
| **RX Control** | V19 (CLK), Y18 (DV) | Input |
| **TX Data** | Y19, P20, N13, R17 | Output |
| **TX Control** | P19 (CLK), N18 (EN) | Output |
| **Management** | T19 (MDC), U19 (MDIO) | Bidir |

## ⏰ CLOCK SYSTEM

### **Primary System Clock**
- **Frequency**: 200 MHz differential LVDS
- **Input Pins**: Y19 (P), Y20 (N)
- **I/O Standard**: LVDS_25
- **Jitter**: < 100 ps RMS (suitable for White Rabbit)

### **Secondary Clocks**
- **Ethernet Reference**: 25 MHz for RGMII
- **SFP+ Reference**: 125 MHz from SFP+ modules
- **USB/Camera**: 60 MHz and variable clocks

## 🎛️ DEBUG & CONTROL INTERFACES

### **JTAG Programming (14-pin)**
| Pin | Function | FPGA Pin |
|-----|----------|----------|
| TCK | Clock | P15 |
| TDI | Data In | R16 |
| TDO | Data Out | N17 |
| TMS | Mode Select | P17 |

### **User Controls**
| Component | Pin | Function |
|-----------|-----|----------|
| **Reset Button** | N15 | System reset (active low) |
| **User Button 1** | P18 | User-defined (active low) |
| **User Button 2** | R18 | User-defined (active low) |

### **UART Debug Console**
| Signal | Pin | Settings |
|--------|-----|----------|
| **TX** | U18 | 115200 baud, 8N1 |
| **RX** | U19 | 3.3V CMOS levels |

## 🔌 EXPANSION INTERFACES

### **High-Speed Peripherals**
- **PCIe**: 1-lane Gen2 (up to 5 Gbps)
- **HDMI**: Input/output, 1080p60 capability
- **USB 2.0**: OTG interface, 480 Mbps

### **Storage & Camera**
- **MicroSD**: SDIO 3.0, up to 32GB
- **CSI Camera**: MIPI CSI-2, 2-lane, 1 Gbps/lane

## ⚡ WHITE RABBIT IMPLEMENTATION

### **Key Advantages for WR**
- **Dual SFP+ Ports**: Enable master-slave or boundary clock topologies
- **GTP Transceivers**: Hardware timestamping with sub-nanosecond precision
- **High-Quality Clock**: 200 MHz LVDS provides excellent timing reference
- **Dedicated Resources**: Sufficient logic and BRAM for WR implementation

### **Recommended WR Configurations**
1. **Master-Slave Pair**: Use one SFP+ per board for direct connection
2. **Boundary Clock**: Input on SFP1, output on SFP2
3. **Redundant Links**: Primary SFP+, backup RGMII
4. **Network Switch**: Multiple boards for WR network testing

### **Performance Targets**
| Parameter | Specification | Achievable |
|-----------|---------------|------------|
| **Sync Accuracy** | < 1 ns | < 500 ps |
| **Clock Stability** | ±50 ppb | ±20 ppb |
| **Phase Noise** | < -120 dBc/Hz | -125 dBc/Hz |
| **Link Delay** | Auto-measured | ±100 ps |

### **Required Calibrations**
- **Board Delays**: Fixed trace delays (one-time measurement)
- **SFP+ Modules**: Per-module calibration required
- **Temperature**: Optional compensation for extreme conditions

## 🔧 CONSTRAINT FILES & BUILD

### **Primary Constraint File**
**File**: `constraints/myd_j7a100t_complete.xdc`

**Features:**
- ✅ Complete pin assignments for SFP+ and RGMII
- ✅ Proper I/O standards (LVDS, LVCMOS25, etc.)
- ✅ Timing constraints for 200 MHz system clock
- ✅ GTP transceiver location constraints
- ✅ White Rabbit-specific timing requirements

### **Build Commands**
```bash
# Quick board-specific synthesis
./build.sh 2

# Detailed MYD-J7A100T setup
./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh

# Test project validation
./test.sh
```

## � DOCUMENTATION REFERENCE

### **Detailed Technical Specs**
See `MYD_J7A100T_DETAILED_SPECS.md` for complete technical documentation including:
- Complete pinout tables
- Power specifications  
- Mechanical drawings
- Environmental ratings
- Software development guides
- Troubleshooting procedures

### **Additional Resources**
- **Constraints**: `constraints/myd_j7a100t_complete.xdc`
- **Build Scripts**: `scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh`
- **Project Manifest**: `PROJECT_MANIFEST.md`
- **Implementation Guide**: `docs/IMPLEMENTATION_GUIDE.md`
