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
├── 📂 analysis/               # Debugging and error analysis
├── 🔧 *.tcl                   # Vivado simulation scripts
├── 🔧 *.do                    # ModelSim simulation scripts
└── 🛠️ quick_cleanup.sh        # Quick temporary file cleanup
```

---

## 📂 BUILD SCRIPTS (`build/`)

### Purpose: **Compilation, Synthesis, and Hardware Generation**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **BUILD_REAL_WR.sh** | Builds WRPC software for LM32 processor | `./scripts/buil./scripts/build/BUILD_REAL_WR.sh` | Before hardware implementation |
| **CREATE_MYD_J7A100T_SYNTHESIS.sh** | Creates Vivado synthesis project for MYD-J7A100T | `./scripts/buil./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh` | When ready for hardware synthesis |
| **CREATE_VIVADO_SYNTHESIS.sh** | Generic Vivado synthesis project creation | `./scripts/build/CREATE_VIVADO_SYNTHESIS.sh` | For general FPGA targets |
| **BUILD_HARDWARE_FIRST.sh** | Alternative build approach (hardware without LM32 first) | `./scripts/build/BUILD_HARDWARE_FIRST.sh` | Alternative implementation strategy |

**Target Users:** Hardware engineers, FPGA developers
**Dependencies:** Vivado, LM32 toolchain, wr-cores, wrpc-sw

---

## ⚙️ SETUP SCRIPTS (`setup/`)

### Purpose: **Environment Configuration and Project Preparation**

| Script | Function | Usage | When to Use |
|--------|----------|-------|-------------|
| **MYD_J7A100T_SETUP.sh** | Board-specific setup guide for MYD-J7A100T | `./scripts/setu./scripts/setup/MYD_J7A100T_SETUP.sh` | Before hardware implementation |
| **IMPLEMENTATION_ROADMAP.sh** | Shows implementation roadmap and progress | `./scripts/setup/IMPLEMENTATION_ROADMAP.sh` | Planning and progress tracking |

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
| **FINAL_PROJECT_VERIFICATION.sh** | Comprehensive systematic verification | `./scripts/tools/FINAL_PROJECT_VERIFICATION.sh` | Complete project validation |
| **FIX_REFERENCES.sh** | Fix broken references in documentation | `./scripts/tools/FIX_REFERENCES.sh` | After file reorganization |
| **VERIFICACAO_FINAL_COMPLETA.sh** | Final verification summary report | `./scripts/tools/VERIFICACAO_FINAL_COMPLETA.sh` | Project completion review |

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
| **run_vivado_test.tcl** | Test environment setup | `cd scripts && vivado -source run_vivado_test.tcl` | Testing configurations |
| **run_vivado_full.tcl** | Advanced simulation with all features | `cd scripts && vivado -source run_vivado_full.tcl` | Complete system simulation |
| **run_simulation.do** | ModelSim automation | `cd scripts && vsim -do run_simulation.do` | ModelSim users |
| **wave.do** | Waveform configuration | Used by other scripts | Signal viewing setup |
| **cleanup_vivado.tcl** | Vivado-specific cleanup | `cd scripts && vivado -source cleanup_vivado.tcl` | Clean Vivado projects |
| **quick_cleanup.sh** | Quick temporary file removal | `./scripts/quick_cleanup.sh` | Daily development cleanup |

**Target Users:** Simulation engineers, FPGA developers
**Dependencies:** Vivado, ModelSim, testbench files

---

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
Vivado/ModelSim scripts remain in `/scripts/` root because:
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
- Simulation scripts → Require Vivado or ModelSim
- `scripts/buil./scripts/build/BUILD_REAL_WR.sh` → Requires wr-cores, wrpc-sw

### **Project-Dependent Scripts**
- All scripts assume proper project structure
- Board-specific scripts need hardware documentation
- Synthesis scripts need constraint files
