#!/bin/bash
#
# White Rabbit Implementation - Alternative Approach
# Build without LM32 software first, then add it later
#

echo "========================================"
echo "WHITE RABBIT IMPLEMENTATION - ALT APPROACH"
echo "========================================"
echo ""

echo "🔍 SITUATION ANALYSIS:"
echo "   ✅ wr-cores repository ready"
echo "   ✅ hdlmake available"  
echo "   ✅ Vivado working"
echo "   ❌ LM32 GCC not compiled yet"
echo ""

echo "💡 SOLUTION: Hardware-First Approach"
echo "   We'll build WR hardware without embedded software first"
echo "   This lets you see FPGA synthesis and implementation"
echo "   Software can be added later when LM32 toolchain is ready"
echo ""

echo "🎯 STEP 1: BUILD WR HARDWARE (No Software)"
echo "────────────────────────────────────────"

export WR_BASE="/home/leandro/Documents/code/white-rabbit"
cd $WR_BASE/wr-cores

echo "Available synthesis targets:"
echo ""
ls syn/

echo ""
echo "Let's build for SPEC board (most common):"
cd syn/spec_1_1

echo ""
echo "Available designs:"
ls -1

echo ""
echo "🚀 BUILDING WR_CORE_DEMO (Basic WR Node)"
echo "────────────────────────────────────────"

cd wr_core_demo
echo "Current directory: $(pwd)"
echo ""

echo "📋 Design files present:"
ls -la *.vhd *.ucf Manifest.py 2>/dev/null

echo ""
echo "Generating build files with hdlmake..."
if hdlmake; then
    echo "✅ hdlmake successful - build files generated"
    echo ""
    echo "📋 Generated files:"
    ls -la Makefile *.xst *.prj 2>/dev/null
    
    echo ""
    echo "🎯 NEXT: Run Vivado synthesis"
    echo "Command: make"
    echo ""
    echo "This will:"
    echo "  1. Synthesize WR core logic"
    echo "  2. Place and route on FPGA"
    echo "  3. Generate timing reports"
    echo "  4. Create bitstream file"
    echo ""
    echo "⚠️  Note: Will run without embedded software"
    echo "   Hardware will work, but no LM32 processor code"
    echo ""
    
    # Optionally start synthesis
    read -p "Start synthesis now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "🚀 Starting synthesis..."
        echo "This may take 15-30 minutes..."
        make
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ SUCCESS: WR hardware synthesis complete!"
            echo ""
            echo "📋 Generated outputs:"
            ls -la *.bit *.rpt *.log 2>/dev/null
            echo ""
            echo "🎯 Next steps:"
            echo "1. Analyze timing reports"
            echo "2. Program FPGA (if hardware available)"  
            echo "3. Build LM32 toolchain for software"
        else
            echo ""
            echo "❌ Synthesis failed - check error messages above"
        fi
    else
        echo ""
        echo "⏸️  Synthesis not started"
        echo "   Run 'make' when ready"
    fi
    
else
    echo "❌ hdlmake failed"
    echo "Check Manifest.py and tool availability"
fi

echo ""
echo "========================================"
echo "Hardware-first approach initiated!"
echo "========================================"
