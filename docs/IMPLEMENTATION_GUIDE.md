# White Rabbit Real Implementation Guide

## 🎯 PHASE 1: WR-CORES FOUNDATION SETUP

### Why This Phase is Critical:
The wr-cores repository contains all the **actual White Rabbit FPGA logic**:
- PTP protocol implementation
- Ethernet PHY interfaces  
- Timing and synchronization cores
- Platform-specific adaptations

Without properly configured wr-cores, you cannot build real WR hardware.

---

## 📋 STEP-BY-STEP IMPLEMENTATION

### Step 1: Verify WR-Cores Installation

**Check what you have:**
```bash
cd /home/leandro/Documents/code/white-rabbit/wr-cores
ls -la
git status
git log --oneline -5
```

**What to look for:**
- ✅ Complete directory structure (modules, top, platform, etc.)
- ✅ Git repository in good state
- ✅ No missing submodules

### Step 2: Build WRPC Software

**Why needed:** The WR nodes need embedded software (LM32 processor code)

```bash
cd /home/leandro/Documents/code/white-rabbit/wrpc-sw
make
```

**Expected output:** `wrc.bram` file containing embedded software

### Step 3: Choose Your Target Platform

**Options available:**
- **SPEC 1.1** - PCIe card with Xilinx Spartan-6
- **KC705** - Xilinx Kintex-7 evaluation board  
- **ZC706** - Xilinx Zynq evaluation board
- **Custom** - Your own board design

**For this guide, we'll use SPEC 1.1 (most common)**

### Step 4: Build Your First Real WR Design

```bash
cd /home/leandro/Documents/code/white-rabbit/wr-cores/syn/spec_1_1/wr_core_demo
hdlmake
make
```

---

## 🔧 WHAT EACH COMPONENT DOES

### **WR-Cores Structure:**
```
wr-cores/
├── modules/           # Core WR functionality
│   ├── wr_endpoint/   # Ethernet endpoint with WR extensions
│   ├── wr_softpll_ng/ # Software PLL for fine timing
│   └── timing/        # Time distribution and PPS generation
├── top/               # Complete designs for specific boards
│   ├── spec_1_1/      # SPEC card implementations
│   └── kc705/         # KC705 board implementations  
├── platform/          # FPGA-specific primitives
│   ├── xilinx/        # Xilinx FPGA support
│   └── altera/        # Intel/Altera FPGA support
└── syn/               # Synthesis scripts and projects
```

### **Key Technologies:**
- **VHDL + SystemVerilog** - Hardware description
- **LM32** - Embedded soft-core processor
- **Wishbone** - Internal bus protocol
- **SDB** - Self-Describing Bus for auto-discovery
- **WR Fabric** - Enhanced Ethernet with timing

---

## 🎯 PRACTICAL NEXT STEPS

### Immediate Actions (Next 30 minutes):

1. **Verify wr-cores build system:**
   ```bash
   cd /home/leandro/Documents/code/white-rabbit/wr-cores
   which hdlmake
   ```

2. **Check WRPC software build:**
   ```bash
   cd /home/leandro/Documents/code/white-rabbit/wrpc-sw
   ls -la wrc.bram
   ```

3. **Test synthesis of simple WR design:**
   ```bash
   cd /home/leandro/Documents/code/white-rabbit/wr-cores/syn/spec_1_1/wr_core_demo
   hdlmake
   ```

### Intermediate Goals (Next few hours):

4. **Complete SPEC design synthesis**
5. **Understand resource utilization**
6. **Generate bitstream for programming**

### Advanced Goals (Next few days):

7. **Program real FPGA hardware**
8. **Establish WR network between two nodes**
9. **Measure synchronization accuracy**

---

## 🔍 TROUBLESHOOTING COMMON ISSUES

### Missing Tools:
- **hdlmake**: `pip3 install hdlmake`
- **LM32 toolchain**: Already in your `lm32-toolchain/` directory
- **Vivado**: Already working from previous tests

### Build Errors:
- **Missing submodules**: `git submodule update --init --recursive`
- **Path issues**: Check `lm32-toolchain` in PATH
- **Library conflicts**: Use clean Vivado environment

### FPGA Programming:
- **Hardware not detected**: Check USB drivers
- **Bitstream errors**: Verify correct FPGA part number
- **No sync**: Check SFP+ connections and clocks

---

## 💡 WHY THIS APPROACH WORKS

1. **Incremental Complexity**: Start with known-good designs
2. **Proven Methodology**: Following White Rabbit community practices
3. **Hardware Validation**: Real timing measurements on real hardware
4. **Scalable**: Same approach works for networks of any size

**Ready to begin? Start with Step 1 verification!**
