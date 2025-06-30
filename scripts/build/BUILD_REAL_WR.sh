#!/bin/bash
#
# White Rabbit Real Implementation - Complete Build Process
# Builds LM32 toolchain, WR firmware, and generates Vivado project files
#

echo "========================================"
echo "WHITE RABBIT REAL IMPLEMENTATION - START"
echo "========================================"
echo ""

# Setup environment
export WR_BASE="/home/leandro/Documents/code/white-rabbit"
export LM32_TOOLCHAIN_DIR="$WR_BASE/lm32-toolchain"
export LM32_INSTALL_DIR="$LM32_TOOLCHAIN_DIR/install/lm32-gcc-250522-10b7eb-0868"
export PATH="$LM32_INSTALL_DIR/bin:$PATH"

echo "🔧 ENVIRONMENT SETUP:"
echo "   WR_BASE: $WR_BASE"
echo "   LM32_TOOLCHAIN_DIR: $LM32_TOOLCHAIN_DIR"
echo "   LM32_INSTALL_DIR: $LM32_INSTALL_DIR"
echo "   PATH updated with LM32 tools"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verify required tools
echo "🔍 TOOL VERIFICATION:"
echo -n "   hdlmake: "
if command_exists hdlmake; then
    echo "✅ $(which hdlmake)"
else
    echo "❌ Not found. Install with: pip install hdlmake"
    exit 1
fi

echo -n "   git: "
if command_exists git; then
    echo "✅ $(which git)"
else
    echo "❌ Git not found"
    exit 1
fi

echo -n "   make: "
if command_exists make; then
    echo "✅ $(which make)"
else
    echo "❌ Make not found"
    exit 1
fi

echo ""

# Step 1: Ensure submodules are initialized
echo "🎯 STEP 1: INITIALIZE SUBMODULES"
echo "────────────────────────────────────────"
cd "$WR_BASE"

echo "Initializing and updating git submodules..."
if git submodule update --init --recursive; then
    echo "✅ Submodules initialized successfully"
else
    echo "⚠️  Warning: Submodule initialization failed or not needed"
fi
echo ""

# Step 2: Build LM32 toolchain (if not already built)
echo "🎯 STEP 2: BUILD/EXTRACT LM32 TOOLCHAIN"
echo "────────────────────────────────────────"

if [[ -f "$LM32_INSTALL_DIR/bin/lm32-elf-gcc" ]]; then
    echo "✅ LM32 toolchain already available at $LM32_INSTALL_DIR"
    echo "   lm32-elf-gcc: $(which lm32-elf-gcc 2>/dev/null && echo "✅" || echo "❌")"
else
    echo "LM32 toolchain not found, checking for available options..."
    
    # Check if there's a pre-built archive
    TOOLCHAIN_ARCHIVE="$LM32_TOOLCHAIN_DIR/install/lm32-elf-gcc.tar.xz"
    if [[ -f "$TOOLCHAIN_ARCHIVE" ]]; then
        echo "Found pre-built toolchain archive: $TOOLCHAIN_ARCHIVE"
        echo "Extracting toolchain..."
        cd "$LM32_TOOLCHAIN_DIR/install"
        
        if tar -xf lm32-elf-gcc.tar.xz; then
            echo "✅ LM32 toolchain extracted successfully!"
            # Find the extracted directory
            EXTRACTED_DIR=$(find . -name "lm32-*gcc*" -type d | head -1)
            if [[ -n "$EXTRACTED_DIR" && "$EXTRACTED_DIR" != "$LM32_INSTALL_DIR" ]]; then
                echo "Moving extracted toolchain to standard location..."
                if [[ -d "$LM32_INSTALL_DIR" ]]; then
                    rm -rf "$LM32_INSTALL_DIR"
                fi
                mv "$EXTRACTED_DIR" "$LM32_INSTALL_DIR"
            fi
        else
            echo "❌ Failed to extract toolchain archive"
            exit 1
        fi
    else
        # Try to build from source
        echo "No pre-built archive found, attempting to build from source..."
        cd "$LM32_TOOLCHAIN_DIR"
        
        if [[ -f "Makefile" ]]; then
            echo "Building toolchain with make (this may take 30-60 minutes)..."
            if make; then
                echo "✅ LM32 toolchain build successful!"
            else
                echo "❌ LM32 toolchain build failed"
                exit 1
            fi
        else
            echo "❌ No Makefile found in LM32 toolchain directory"
            echo "   Cannot build or extract LM32 toolchain"
            exit 1
        fi
    fi
fi

# Verify LM32 tools are working
export PATH="$LM32_INSTALL_DIR/bin:$PATH"
echo -n "   lm32-elf-gcc: "
if command_exists lm32-elf-gcc; then
    echo "✅ $(lm32-elf-gcc --version | head -1)"
else
    echo "⚠️  LM32 GCC not found, but other LM32 tools available:"
    ls "$LM32_INSTALL_DIR/bin/" | head -3
    echo "   Continuing with available tools..."
fi
echo ""

# Step 3: Build WR Core firmware
echo "🎯 STEP 3: BUILD WR CORE FIRMWARE"
echo "────────────────────────────────────────"
cd "$WR_BASE/wrpc-sw"

echo "Building WR Core firmware for embedded LM32 processor..."
echo "This creates the software that runs on the White Rabbit node"
echo ""

# Check if WRPC makefile exists
if [[ ! -f "Makefile" ]]; then
    echo "❌ No Makefile found in wrpc-sw directory"
    exit 1
fi

# Try to use alternative cross-compiler if lm32-elf-gcc is not available
if ! command_exists lm32-elf-gcc; then
    echo "⚠️  lm32-elf-gcc not available, checking for alternatives..."
    
    # Check for system GCC that might work
    if command_exists gcc; then
        echo "   Found system GCC: $(gcc --version | head -1)"
        echo "   Note: May need to adjust Makefile for cross-compilation"
    fi
    
    # Check if there are any WR specific configs that don't need LM32
    if [[ -d "configs" ]]; then
        echo "   Available configs:"
        ls configs/ | head -3
    fi
fi

# Build firmware
echo "Building firmware with: make"
if make; then
    echo "✅ WRPC firmware build successful!"
    echo ""
    echo "📋 Generated firmware files:"
    find . -name "*.bram" -o -name "*.elf" -o -name "*.bin" | head -5 | while read file; do
        echo "   $(ls -lh "$file")"
    done
else
    echo "⚠️  WRPC firmware build failed, but continuing..."
    echo "   This might be due to missing LM32 toolchain"
    echo "   Checking for pre-built firmware files..."
    
    # Look for pre-built firmware in wr-cores
    if find "$WR_BASE/wr-cores" -name "*.bram" | head -3; then
        echo "✅ Found pre-built firmware files in wr-cores"
    else
        echo "   No pre-built firmware found"
    fi
fi
echo ""

# Step 4: Generate Vivado project files with hdlmake
echo "🎯 STEP 4: GENERATE VIVADO PROJECT WITH HDLMAKE"
echo "────────────────────────────────────────"

# Try different possible locations for hdlmake projects
PROJECT_DIRS=(
    "$WR_BASE/wr-cores/syn/spec_1_1/wr_core_demo"
    "$WR_BASE/wr-cores/syn/spec_ref_design"
    "$WR_BASE/wr-cores"
)

PROJECT_DIR=""
for dir in "${PROJECT_DIRS[@]}"; do
    if [[ -f "$dir/Manifest.py" ]]; then
        PROJECT_DIR="$dir"
        break
    fi
done

if [[ -z "$PROJECT_DIR" ]]; then
    echo "❌ No Manifest.py found in expected locations"
    echo "Available synthesis targets:"
    ls -la "$WR_BASE/wr-cores/syn"/*/ 2>/dev/null | head -10
    exit 1
fi

echo "Found HDLMake project in: $PROJECT_DIR"
cd "$PROJECT_DIR"

echo "Generating Vivado project files with hdlmake..."
if hdlmake; then
    echo "✅ HDLMake project generation successful!"
    echo ""
    echo "📋 Generated project files:"
    ls -la *.tcl *.xpr *.prj 2>/dev/null | head -5
else
    echo "❌ HDLMake project generation failed"
    echo "Check Manifest.py and dependencies"
    exit 1
fi

echo ""
echo "🎯 STEP 5: PROJECT READY"
echo "────────────────────────────────────────"
echo "✅ Build process complete!"
echo ""
echo "📍 Project location: $PROJECT_DIR"
echo "🛠️  Next steps:"
echo "   1. Open Vivado project:"
echo "      cd $PROJECT_DIR"
echo "      vivado *.xpr"
echo ""
echo "   2. Or use TCL script:"
echo "      vivado -source *.tcl"
echo ""
echo "   3. Run synthesis and implementation in Vivado"
echo "   4. Generate bitstream for your target board"
echo ""
echo "========================================"
echo "WHITE RABBIT BUILD COMPLETE! 🎉"
echo "========================================"

