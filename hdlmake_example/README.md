# HDLMake Example for White Rabbit Two-Node Project

This directory contains a minimal, working HDLMake configuration that demonstrates how to use HDLMake with the White Rabbit project.

## What is HDLMake?

HDLMake is a tool that automates FPGA project creation from source file descriptions. It reads `Manifest.py` files to generate Makefiles and project files for various synthesis tools.

## Files

- **`Manifest.py`** - HDLMake manifest with project configuration
- **`two_node_wr_top.vhd`** - Top-level entity for synthesis
- **Generated files** - Created by HDLMake (Makefile, Vivado project, etc.)

## Usage

1. **Install HDLMake:**
   ```bash
   pip3 install hdlmake
   ```

2. **Generate project:**
   ```bash
   cd hdlmake_example/
   hdlmake
   ```

3. **Run synthesis:**
   ```bash
   make
   ```

## Configuration

The `Manifest.py` is configured for:
- **Target:** Xilinx Vivado synthesis
- **Device:** Artix-7 XC7A100T (MYD-J7A100T board)
- **Package:** CSG324
- **Files:** Minimal set for demonstration

## Notes

- This is a minimal example for educational purposes
- For production use, you would typically include more source files
- The configuration targets the MYD-J7A100T development board
- Generated files are included in `.gitignore`

## Related

- See `../scripts/build/BUILD_REAL_WR.sh` for complete White Rabbit build flow
- See `../docs/IMPLEMENTATION_GUIDE.md` for detailed implementation instructions
