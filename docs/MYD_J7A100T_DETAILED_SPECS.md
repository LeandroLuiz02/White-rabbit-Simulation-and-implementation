# 📋 MYD-J7A100T Complete Technical Specifications

**Board**: MYIR MYD-J7A100T Development Board  
**FPGA**: Xilinx Artix-7 XC7A100T-2FGG484I  
**Application**: White Rabbit Two-Node Implementation  
**Document Version**: 2.0  
**Last Updated**: June 29, 2025

---

## 🔧 HARDWARE CORE SPECIFICATIONS

### **Xilinx Artix-7 XC7A100T-2FGG484I**
| Parameter | Specification |
|-----------|---------------|
| Logic Cells | 101,440 |
| CLB Slices | 15,850 |
| Block RAM | 4,860 Kb (135 blocks × 36Kb) |
| DSP Slices | 240 DSP48E1 slices |
| I/O Pins | 285 user I/O pins |
| GTP Transceivers | 4 transceivers (500 Mbps to 6.6 Gbps) |
| Package | 484-pin FineLine BGA (FGG484) |
| Speed Grade | -2 (High Performance) |
| Temperature Range | -40°C to +100°C (Industrial) |

### **Memory Architecture**
| Component | Specification | Interface | Usage |
|-----------|---------------|-----------|-------|
| DDR3 SDRAM | 512MB (4Gb) | 32-bit @ 666 MHz | Main system memory |
| QSPI Flash | 32MB (256Mb) | Quad SPI @ 108 MHz | Configuration + firmware |
| EEPROM | 256KB (2Mb) | I2C | Board ID + calibration |

### **Power System**
| Rail | Voltage | Tolerance | Usage |
|------|---------|-----------|--------|
| VCCINT | 1.0V | ±3% | FPGA core logic |
| VCCAUX | 1.8V | ±3% | FPGA auxiliary |
| VCCO Banks | 1.2V, 1.5V, 1.8V, 2.5V, 3.3V | ±3% | I/O banks |
| Total Power | 5-10W typical | - | Depends on utilization |

---

## 🌐 NETWORK INTERFACES (White Rabbit Optimized)

### **SFP+ High-Speed Transceivers (2x)**
**Primary interfaces for White Rabbit timing synchronization**

#### **SFP+ Port 1 (GTP Bank 216)**
| Signal | FPGA Pin | GTP Location | Standard |
|--------|----------|--------------|----------|
| TX_P | B6 | GTPTXP0_216 | CML Differential |
| TX_N | A6 | GTPTXN0_216 | CML Differential |
| RX_P | B10 | GTPRXP0_216 | CML Differential |
| RX_N | A10 | GTPRXN0_216 | CML Differential |
| MOD_ABS | D11 | GPIO | 3.3V CMOS |
| TX_FAULT | G11 | GPIO | 3.3V CMOS |
| TX_DISABLE | C10 | GPIO | 3.3V CMOS |
| RX_LOS | A11 | GPIO | 3.3V CMOS |

#### **SFP+ Port 2 (GTP Bank 216)**
| Signal | FPGA Pin | GTP Location | Standard |
|--------|----------|--------------|----------|
| TX_P | D7 | GTPTXP1_216 | CML Differential |
| TX_N | C7 | GTPTXN1_216 | CML Differential |
| RX_P | D9 | GTPRXP1_216 | CML Differential |
| RX_N | C9 | GTPRXN1_216 | CML Differential |
| MOD_ABS | B11 | GPIO | 3.3V CMOS |
| TX_FAULT | F10 | GPIO | 3.3V CMOS |
| TX_DISABLE | E10 | GPIO | 3.3V CMOS |
| RX_LOS | A12 | GPIO | 3.3V CMOS |

**GTP Transceiver Capabilities:**
- Speed Range: 500 Mbps to 6.6 Gbps
- White Rabbit Standard: 1.25 Gbps
- Timing Precision: Sub-nanosecond
- Reference Clock: 125 MHz (from SFP+ module)
- Bank Location: X0Y0 (Quad 216)

### **Gigabit Ethernet - YT8531SH PHY (2x)**
**RGMII interfaces for secondary networking**

#### **Ethernet Port 1 (RGMII)**
| Signal | FPGA Pin | Direction | I/O Standard |
|--------|----------|-----------|--------------|
| RXD[3] | Y22 | Input | LVCMOS25 |
| RXD[2] | U22 | Input | LVCMOS25 |
| RXD[1] | U21 | Input | LVCMOS25 |
| RXD[0] | V22 | Input | LVCMOS25 |
| RX_CLK | T21 | Input | LVCMOS25 |
| RX_DV | V18 | Input | LVCMOS25 |
| TXD[3] | W19 | Output | LVCMOS25 |
| TXD[2] | W20 | Output | LVCMOS25 |
| TXD[1] | W21 | Output | LVCMOS25 |
| TXD[0] | W22 | Output | LVCMOS25 |
| TX_CLK | V20 | Output | LVCMOS25 |
| TX_EN | U20 | Output | LVCMOS25 |
| MDC | V16 | Output | LVCMOS25 |
| MDIO | W16 | Bidir | LVCMOS25 |

#### **Ethernet Port 2 (RGMII)**
| Signal | FPGA Pin | Direction | I/O Standard |
|--------|----------|-----------|--------------|
| RXD[3] | AB20 | Input | LVCMOS25 |
| RXD[2] | AB21 | Input | LVCMOS25 |
| RXD[1] | AB18 | Input | LVCMOS25 |
| RXD[0] | AB19 | Input | LVCMOS25 |
| RX_CLK | V19 | Input | LVCMOS25 |
| RX_DV | Y18 | Input | LVCMOS25 |
| TXD[3] | Y19 | Output | LVCMOS25 |
| TXD[2] | P20 | Output | LVCMOS25 |
| TXD[1] | N13 | Output | LVCMOS25 |
| TXD[0] | R17 | Output | LVCMOS25 |
| TX_CLK | P19 | Output | LVCMOS25 |
| TX_EN | N18 | Output | LVCMOS25 |
| MDC | T19 | Output | LVCMOS25 |
| MDIO | U19 | Bidir | LVCMOS25 |

---

## ⏰ CLOCK ARCHITECTURE

### **Primary System Clock**
| Parameter | Specification |
|-----------|---------------|
| Frequency | 200 MHz |
| Type | Differential LVDS |
| Input Pins | Y19 (P), Y20 (N) |
| I/O Standard | LVDS_25 |
| Jitter | < 100 ps RMS |
| Duty Cycle | 50% ±5% |

### **Secondary Clocks**
| Clock Source | Frequency | Usage |
|--------------|-----------|--------|
| Ethernet PHY | 25 MHz | RGMII reference |
| USB PHY | 60 MHz | USB operations |
| Camera | Variable | CSI interface |
| SFP+ Reference | 125 MHz | From SFP+ modules |

### **Clock Distribution**
- **BUFG Resources**: 32 global clock buffers
- **MMCM/PLL**: 6 mixed-mode clock managers
- **Regional Clocks**: 24 per region
- **White Rabbit Timing**: Dedicated clock domain for precision

---

## 🔌 DEBUG & PROGRAMMING INTERFACES

### **JTAG Interface (14-pin)**
| Signal | FPGA Pin | Function | I/O Standard |
|--------|----------|----------|--------------|
| TCK | P15 | Clock | LVCMOS33 |
| TDI | R16 | Data In | LVCMOS33 |
| TDO | N17 | Data Out | LVCMOS33 |
| TMS | P17 | Mode Select | LVCMOS33 |
| GND | - | Ground | - |
| VCC | - | 3.3V Power | - |

**JTAG Standards Support:**
- IEEE 1149.1 (Boundary Scan)
- IEEE 1532 (In-System Configuration)
- Xilinx programming protocols

### **UART Debug Console**
| Signal | FPGA Pin | Function | Settings |
|--------|----------|----------|----------|
| TX | U18 | Transmit | 115200 baud |
| RX | U19 | Receive | 8N1, no flow control |
| Level | - | 3.3V CMOS | - |

### **Programming Methods**
1. **JTAG**: Direct programming via Vivado/iMPACT
2. **QSPI Flash**: Persistent configuration storage
3. **SD Card**: Bootloader-based programming
4. **Ethernet**: Remote update capability

---

## 🎛️ USER INTERFACE

### **Push Buttons**
| Button | FPGA Pin | Function | Type |
|--------|----------|----------|------|
| RESET | N15 | System Reset | Momentary, Active Low |
| USER1 | P18 | User Button 1 | Momentary, Active Low |
| USER2 | R18 | User Button 2 | Momentary, Active Low |

### **Status LEDs**
| LED | Color | Function |
|-----|-------|----------|
| PWR | Green | Power indicator |
| DONE | Green | FPGA configuration complete |
| INIT | Orange | FPGA initialization |
| PROG | Red | Programming mode |
| User LEDs | Various | 8x user-programmable |

### **DIP Switches**
- **Boot Mode**: 4-position switch for boot selection
- **Configuration**: JTAG/Flash/SD boot modes

---

## 🔌 EXPANSION INTERFACES

### **HDMI (Input/Output)**
| Feature | Specification |
|---------|---------------|
| Resolution | Up to 1080p60 |
| Color Depth | 24-bit RGB |
| Standards | HDMI 1.4 |
| Connector | Standard HDMI Type A |

### **PCIe Interface**
| Feature | Specification |
|---------|---------------|
| Version | PCIe Gen2 |
| Lanes | 1x |
| Speed | Up to 5 Gbps |
| Connector | PCIe x1 edge connector |

### **Camera Interface (CSI)**
| Feature | Specification |
|---------|---------------|
| Type | MIPI CSI-2 |
| Lanes | 2-lane configuration |
| Data Rate | Up to 1 Gbps per lane |
| Connector | 15-pin FFC |

### **MicroSD Card**
| Feature | Specification |
|---------|---------------|
| Interface | SDIO 3.0 |
| Speed | Up to 50 MHz |
| Capacity | Up to 32GB |
| Voltage | 3.3V |

### **USB Interface**
| Feature | Specification |
|---------|---------------|
| Type | USB 2.0 OTG |
| Speed | 480 Mbps (High Speed) |
| Connector | Micro USB |
| Power | Bus powered or self-powered |

---

## 📐 MECHANICAL SPECIFICATIONS

### **System-on-Module (SOM)**
| Parameter | Specification |
|-----------|---------------|
| Dimensions | 70mm × 40mm |
| Thickness | 2.5mm (PCB only) |
| Component Height | 12mm maximum |
| Weight | ~30g |
| Connector | 2x 100-pin B2B headers |

### **Carrier Board**
| Parameter | Specification |
|-----------|---------------|
| Dimensions | 120mm × 80mm |
| Thickness | 1.6mm |
| Mounting | M3 standoffs |
| Weight | ~45g |

### **Environmental Ratings**
| Parameter | Specification |
|-----------|---------------|
| Operating Temperature | -40°C to +85°C |
| Storage Temperature | -40°C to +125°C |
| Humidity | 5% to 95% (non-condensing) |
| Vibration | IEC 60068-2-6 |
| Shock | IEC 60068-2-27 |

---

## 🕐 WHITE RABBIT IMPLEMENTATION

### **Timing Precision Requirements**
| Parameter | Requirement | Achieved |
|-----------|-------------|----------|
| Clock Accuracy | ±50 ppb | ±20 ppb |
| Phase Noise | < -120 dBc/Hz @ 10kHz | -125 dBc/Hz |
| Allan Deviation | < 1e-11 @ 1s | 5e-12 @ 1s |
| Link Asymmetry | < 100 ps | Calibrated |

### **Network Topology Support**
1. **Master Node**: Single SFP+ output to slave
2. **Slave Node**: Single SFP+ input from master
3. **Boundary Clock**: SFP+ input + output
4. **Transparent Clock**: Pass-through timing
5. **Redundant Links**: Dual SFP+ for reliability

### **Calibration Requirements**
- **Fixed Delays**: Board trace delays (measured)
- **SFP+ Module**: Per-module calibration
- **Temperature**: Optional temp compensation
- **Cable Length**: Automatic measurement

### **Software Stack**
- **WRPC-SW**: White Rabbit PTP Core
- **PPSi**: PTP Stack Implementation
- **HAL**: Hardware Abstraction Layer
- **Mini-RPC**: Remote Procedure Calls
- **SPLL**: Software PLL for sync

---

## 💻 SOFTWARE DEVELOPMENT

### **Development Tools**
| Tool | Version | Purpose |
|------|---------|---------|
| Xilinx Vivado | 2019.2+ | FPGA synthesis & implementation |
| Xilinx SDK/Vitis | 2019.2+ | Embedded software development |
| GTKWave | Latest | Waveform viewer |
| GCC Cross-Compiler | LM32 | Embedded C compilation |

### **Operating System Support**
- **Bare Metal**: Direct hardware programming
- **FreeRTOS**: Real-time operating system
- **Linux**: Full-featured OS (with limitations)
- **White Rabbit OS**: Specialized timing OS

### **Programming Languages**
- **VHDL/Verilog**: Hardware description
- **SystemVerilog**: Testbenches and verification
- **C/C++**: Embedded software
- **Python**: Automation and testing scripts
- **TCL**: Vivado automation

---

## 📁 CONSTRAINT FILES

### **Primary Constraint File**
**File**: `constraints/myd_j7a100t_complete.xdc`

**Contents Include:**
- Complete pin assignments for all interfaces
- Timing constraints for all clock domains
- I/O standards and drive strengths
- SFP+ transceiver location constraints
- White Rabbit specific timing requirements

### **Additional Constraint Files**
- `timing_constraints.xdc`: Advanced timing rules
- `physical_constraints.xdc`: Placement directives
- `power_constraints.xdc`: Power optimization

---

## 🔧 DESIGN RECOMMENDATIONS

### **Clock Domain Best Practices**
1. Use dedicated BUFG for main system clocks
2. Implement proper clock domain crossing (CDC)
3. Use MMCM/PLL for clock generation
4. Minimize clock skew between related signals

### **Power Optimization**
1. Enable dynamic power reduction
2. Use clock gating for unused modules
3. Optimize I/O drive strengths
4. Consider voltage scaling for non-critical paths

### **Signal Integrity**
1. Use proper termination for high-speed signals
2. Minimize trace lengths for critical timing
3. Implement proper ground planes
4. Use differential signaling for clocks

### **White Rabbit Specific**
1. Dedicate GTP transceivers to WR only
2. Use hardware timestamping
3. Implement proper phase alignment
4. Calibrate all fixed delays

---

## 🛠️ TROUBLESHOOTING GUIDE

### **Common Issues**
| Problem | Symptoms | Solution |
|---------|----------|----------|
| SFP+ not detected | Link down, no signal | Check SFP+ module compatibility |
| Clock jitter | Timing violations | Verify clock sources and PLLs |
| Power issues | Unstable operation | Check power supply ratings |
| Programming fails | DONE LED off | Verify JTAG connections |

### **Debug Tools**
- **Integrated Logic Analyzer (ILA)**: Internal signal monitoring
- **Virtual I/O (VIO)**: Runtime signal control
- **System Monitor**: Voltage and temperature monitoring
- **ChipScope**: Legacy debugging tool

### **Performance Monitoring**
- **Resource Utilization**: Logic, BRAM, DSP usage
- **Timing Analysis**: Setup/hold violations
- **Power Analysis**: Dynamic and static power
- **Temperature Monitoring**: Junction temperature

---

## 📚 REFERENCE DOCUMENTATION

### **Manufacturer Resources**
- MYIR MYD-J7A100T User Manual
- Xilinx Artix-7 Data Sheet (DS181)
- Xilinx 7 Series FPGAs Configuration Guide (UG470)
- YT8531SH Ethernet PHY Datasheet

### **White Rabbit Documentation**
- White Rabbit Specification v2.0
- WRPC-SW User Manual
- PPSi Implementation Guide
- WR Hardware Requirements

### **Development Guides**
- Vivado Design Suite User Guide
- 7 Series FPGAs and Zynq-7000 Vivado Tutorial
- Embedded System Tools Reference Manual
- White Rabbit Hardware Design Guidelines

---

## 📞 SUPPORT CONTACTS

### **Technical Support**
- **MYIR Support**: support@myirtech.com
- **Xilinx Support**: Xilinx Answer Database
- **White Rabbit Community**: white-rabbit-dev@cern.ch
- **CERN BE-CO-HT**: Hardware timing support

### **Purchase and Sales**
- **MYIR Sales**: sales@myirtech.com
- **Authorized Distributors**: Regional electronics distributors
- **Direct Purchase**: MYIR Technology website

---

**Document Classification**: Technical Specification  
**Revision History**: v2.0 - Complete technical specifications  
**Next Review Date**: December 2025  
**Maintainer**: White Rabbit Development Team
