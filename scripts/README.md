# Scripts Directory - White Rabbit Project

## 📋 OVERVIEW

This directory contains all automation scripts for the White Rabbit project, organized by function and purpose. The scripts are categorized to provide clear separation of concerns and easy maintenance.

---

## 🏗️ DIRECTORY STRUCTURE

```
scripts/
├── 📂 build/                  # Build and synthesis scripts
├── 📂 setup/                  # Configuration and preparation
├── 📂 tools/                  # Utilities and maintenance
├──  *.tcl                   # Vivado simulation scripts
└── 🧹 cleanup_vivado.tcl      # Vivado cleanup utility
```

---

## 🎯 SIMULATION SCRIPTS

### **VIVADO SCRIPTS (**.tcl)**

| Script | Testbench | Purpose | Complexity |
|--------|-----------|---------|------------|
| **run_vivado_simple.tcl** | `wr_standalone_basic_tb` | Basic White Rabbit simulation | ⭐⭐  |
| **run_vivado_full.tcl** | `wr_master_slave_sync_tb` | Complete master-slave system | ⭐⭐⭐⭐⭐  |
| **run_vivado_main.tcl** | Multiple testbenches | Comprehensive testing suite | ⭐⭐⭐⭐  |
| **run_all_vivado_sims.tcl** | All 10 testbenches | Run all simulations | ⭐⭐⭐  |
| **cleanup_vivado.tcl** | N/A | Clean Vivado temporary files | ⭐  |

### **USAGE EXAMPLES:**
```bash
# Vivado simulation (GUI mode)
vivado -source scripts/run_vivado_simple.tcl

# Vivado simulation (batch mode) 
vivado -mode batch -source scripts/run_vivado_simple.tcl

# Run all testbenches
vivado -source scripts/run_all_vivado_sims.tcl
```

## 📂 BUILD SCRIPTS (`build/`)

### Purpose: **Compilation, Synthesis, and Hardware Generation**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **BUILD_REAL_WR.sh** | Builds WRPC software for LM32 processor | `./scripts/build/BUILD_REAL_WR.sh` | Before hardware implementation |
| **CREATE_MYD_J7A100T_SYNTHESIS.sh** | Creates Vivado synthesis project for MYD-J7A100T | `./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh` | When ready for hardware synthesis |

**Target Users:** Hardware engineers, FPGA developers
**Dependencies:** Vivado, LM32 toolchain, wr-cores, wrpc-sw

---

## ⚙️ SETUP SCRIPTS (`setup/`)

### Purpose: **Environment Configuration and Project Preparation**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **MYD_J7A100T_SETUP.sh** | Board-specific setup guide for MYD-J7A100T | `./scripts/setup/MYD_J7A100T_SETUP.sh` | Before hardware implementation |

**Target Users:** Project managers, hardware engineers starting implementation
**Dependencies:** Board documentation, development tools

---

## 🛠️ TOOLS SCRIPTS (`tools/`)

### Purpose: **Maintenance, Testing, and Project Management**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **CLEANUP_PROJECT.sh** | Complete project cleanup (removes all temp files) | `./scripts/tools/CLEANUP_PROJECT.sh` | Weekly cleanup, before backups |
| **test_project.sh** | Project validation and verification | `./scripts/tools/test_project.sh` | After changes, before deployment |
| **quick_cleanup.sh** | Quick cleanup of simulation files | `./scripts/tools/quick_cleanup.sh` | After simulation runs |
| **fix_hdlmake.sh** | Fix and generate HDLMake projects | `./scripts/tools/fix_hdlmake.sh` | HDLMake troubleshooting |

**Target Users:** All project users
**Dependencies:** None (standalone utilities)

---

## 📊 ANALYSIS SCRIPTS (`analysis/`)

### Purpose: **Debugging, Error Analysis, and Troubleshooting**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **ERROR_ANALYSIS.sh** | Common error analysis and solutions | `./scripts/analysi./scripts/analysis/ERROR_ANALYSIS.sh` | When encountering problems |

**Target Users:** Developers facing issues, support team
**Dependencies:** Project log files, error traces

---

## 🔧 SIMULATION SCRIPTS (Root Level)

### Purpose: **FPGA Simulation and Testing**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **run_vivado_simple.tcl** | ✅ **Main simulation script** | `cd scripts && vivado -source run_vivado_simple.tcl` | Primary simulation workflow |
| **run_vivado.tcl** | Complete Vivado simulation | `cd scripts && vivado -source run_vivado.tcl` | Full feature simulation |
## 🎯 ROOT LEVEL QUICK ACCESS

### Purpose: **User-Friendly Interface for Common Operations**

| Script | Function | Target | Usage |
|--------|----------|--------|-------|
| **FINALIZE_IMPLEMENTATION.sh** | 📊 **Project status and completion overview** | All users | `../FINALIZE_IMPLEMENTATION.sh` (in project root) |
| **build.sh** | 🔧 **Quick access to build scripts** | Hardware engineers | `./build.sh [1\|2\|3]` |
| **setup.sh** | ⚙️ **Quick access to setup scripts** | New users | `./setup.sh [1\|2]` |
| **test.sh** | 🧪 **Quick project validation** | All users | `./test.sh` |
| **cleanup.sh** | 🧹 **Quick cleanup** | All users | `./cleanup.sh` |

---

## 🎓 SCRIPT ORGANIZATION LOGIC

### **ROOT LEVEL = USER INTERFACE**
Scripts in the root are:
- ✅ **Frequently used** by end users
- ✅ **Simple commands** with short names
- ✅ **Entry points** to organized functionality
- ✅ **Status and overview** functions

### **SUBDIRECTORIES = ORGANIZED FUNCTIONALITY**
Scripts in subdirectories are:
- 🔧 **Specialized functions** organized by category
- 🔧 **Complete implementations** of specific tasks
- 🔧 **Professional organization** for maintainability
- 🔧 **Direct execution** when you know exactly what you want

### **SIMULATION SCRIPTS = TECHNICAL TOOLS**
Vivado scripts remain in `/scripts/` root because:
- 🎯 **Technical nature** - used by simulation engineers
- 🎯 **Established workflow** - `cd scripts && vivado -source ...`
- 🎯 **Tool-specific** - Vivado expects certain directory structure
- 🎯 **Not general user commands** - specialized simulation workflow

---

## 📖 USAGE PATTERNS

### **For New Users (Learning Mode)**
```bash
cd ..                          # Go to project root
./FINALIZE_IMPLEMENTATION.sh   # Understand project status
./setup.sh                     # See available setup options
./test.sh                      # Validate everything works
```

### **For Simulation Work (Technical Mode)**
```bash
cd scripts
vivado -source run_vivado_simple.tcl   # Main simulation
```

### **For Hardware Implementation (Engineering Mode)**
```bash
./build.sh                     # See build options
./build.sh 2                   # Execute MYD-J7A100T synthesis
```

### **For Maintenance (Admin Mode)**
```bash
./cleanup.sh                  # Quick cleanup
./scripts/tool./scripts/tools/CLEANUP_PROJECT.sh    # Complete cleanup
```

### **For Troubleshooting (Support Mode)**
```bash
./scripts/analysi./scripts/analysis/ERROR_ANALYSIS.sh  # Error solutions
./scripts/tool./scripts/tools/test_project.sh       # Detailed validation
```

---

## 🔄 SCRIPT DEPENDENCIES

### **Independent Scripts (No Dependencies)**
- All quick access scripts (`build.sh`, `setup.sh`, etc.)
- `scripts/tool./scripts/tools/CLEANUP_PROJECT.sh`
- `scripts/analysi./scripts/analysis/ERROR_ANALYSIS.sh`

### **Tool-Dependent Scripts**
- `scripts/build/*` → Require Vivado, LM32 toolchain
- Simulation scripts → Require Vivado
- `scripts/buil./scripts/build/BUILD_REAL_WR.sh` → Requires wr-cores, wrpc-sw

### **Project-Dependent Scripts**
- All scripts assume proper project structure
- Board-specific scripts need hardware documentation
- Synthesis scripts need constraint files
