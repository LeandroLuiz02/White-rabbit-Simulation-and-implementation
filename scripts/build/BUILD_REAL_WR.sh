#!/bin/bash
#
# White Rabbit Implementation - Setup Environment and Build
#

echo "========================================"
echo "WHITE RABBIT REAL IMPLEMENTATION - START"
echo "========================================"
echo ""

# Setup environment
export WR_BASE="/home/leandro/Documents/code/white-rabbit"
export LM32_TOOLCHAIN="$WR_BASE/lm32-toolchain/install/lm32-gcc-250522-10b7eb-0868"
export PATH="$LM32_TOOLCHAIN/bin:$PATH"

echo "🔧 ENVIRONMENT SETUP:"
echo "   WR_BASE: $WR_BASE"
echo "   LM32_TOOLCHAIN: $LM32_TOOLCHAIN"
echo "   PATH updated with LM32 tools"
echo ""

# Verify tools
echo "🔍 TOOL VERIFICATION:"
echo -n "   hdlmake: "
which hdlmake 2>/dev/null && echo "✅" || echo "❌"

echo -n "   lm32-elf-gcc: " 
which lm32-elf-gcc 2>/dev/null && echo "✅" || echo "❌"

echo -n "   vivado: "
which vivado 2>/dev/null && echo "✅" || echo "❌"
echo ""

echo "🎯 STEP 1: BUILD WRPC SOFTWARE"
echo "────────────────────────────────────────"
cd $WR_BASE/wrpc-sw

echo "Building WRPC software for SPEC board..."
echo "This creates the embedded software for the WR node's LM32 processor"
echo ""

# Build for SPEC board
if make; then
    echo "✅ WRPC software build successful!"
    echo ""
    echo "📋 Generated files:"
    ls -la wrc.bram wrc.elf 2>/dev/null || echo "Some files missing"
else
    echo "❌ WRPC software build failed"
    echo "Check LM32 toolchain setup"
    exit 1
fi

echo ""
echo "🎯 STEP 2: SETUP WR-CORES BUILD"
echo "────────────────────────────────────────"
cd $WR_BASE/wr-cores

echo "Available synthesis targets:"
ls syn/*/

echo ""
echo "🔧 NEXT ACTIONS:"
echo "1. Choose target board (e.g., spec_1_1)"
echo "2. Build specific WR design"
echo "3. Generate bitstream"
echo ""

echo "Example for SPEC board:"
echo "   cd syn/spec_1_1/wr_core_demo"
echo "   hdlmake"
echo "   make"
echo ""

echo "========================================"
echo "Phase 1 setup complete! Ready for synthesis."
echo "========================================"
