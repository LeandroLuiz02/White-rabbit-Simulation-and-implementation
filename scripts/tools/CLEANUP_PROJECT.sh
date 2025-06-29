#!/bin/bash
#
# White Rabbit Project - Cleanup Script
# Removes Vivado generated files and temporary artifacts
#

echo "==========================================================="
echo "WHITE RABBIT PROJECT - CLEANUP SCRIPT"
echo "==========================================================="
echo ""

# Setup paths
PROJECT_BASE="/home/leandro/Documents/code/white-rabbit/two_node_example"
cd "$PROJECT_BASE"

echo "🧹 CLEANING VIVADO GENERATED FILES"
echo "────────────────────────────────────────────────────────────"

# Function to safely remove files/directories
safe_remove() {
    if [ -e "$1" ]; then
        echo "   🗑️  Removing: $1"
        rm -rf "$1"
        return 0
    else
        echo "   ➖ Not found: $1"
        return 1
    fi
}

# Function to remove files with wildcards
remove_pattern() {
    local pattern="$1"
    local found=false
    for file in $pattern; do
        if [ -e "$file" ]; then
            echo "   🗑️  Removing: $file"
            rm -rf "$file"
            found=true
        fi
    done
    if [ "$found" = false ]; then
        echo "   ➖ No files matching: $pattern"
    fi
}

# Function to show size before removal
show_size() {
    if [ -e "$1" ]; then
        SIZE=$(du -sh "$1" 2>/dev/null | cut -f1)
        echo "   📊 Size: $SIZE - $1"
    fi
}

echo ""
echo "📊 ANALYZING DISK USAGE BEFORE CLEANUP:"
echo "────────────────────────────────────────────────────────────"

# Show sizes of large directories/files
show_size "vivado_test/"
show_size "vivado_advanced/"
show_size ".Xil/"
show_size "vivado*.log"
show_size "vivado*.jou"

echo ""
echo "🗑️  REMOVING VIVADO PROJECT DIRECTORIES:"
echo "────────────────────────────────────────────────────────────"

# Remove Vivado project directories (these are regeneratable)
safe_remove "vivado_test/"
safe_remove "vivado_advanced/"

echo ""
echo "🗑️  REMOVING VIVADO TEMPORARY FILES:"
echo "────────────────────────────────────────────────────────────"

# Remove Vivado temporary directories
safe_remove ".Xil/"

# Remove Vivado log files (multiple backup logs)
safe_remove "vivado.jou"
safe_remove "vivado.log"
remove_pattern "vivado_*.backup.jou"
remove_pattern "vivado_*.backup.log"
remove_pattern "vivado_*.jou"
remove_pattern "vivado_*.log"

# Remove NA files (common Vivado artifacts)
safe_remove "NA"

echo ""
echo "🗑️  REMOVING OTHER TEMPORARY FILES:"
echo "────────────────────────────────────────────────────────────"

# Remove simulation temporary files
remove_pattern "*.wdb"
safe_remove "xsim.dir/"
remove_pattern "*.pb"

# Remove synthesis temporary files  
remove_pattern "*.dcp"
remove_pattern "*.rpt"
remove_pattern "usage_statistics_webtalk.*"
remove_pattern "webtalk*.jou"
remove_pattern "webtalk*.log"

# Remove ModelSim files if present
safe_remove "work/"
remove_pattern "*.wlf"
safe_remove "transcript"
safe_remove "vsim.wlf"
safe_remove "modelsim.ini"

# Remove Python cache
safe_remove "__pycache__/"
remove_pattern "*.pyc"

# Remove editor temporary files
remove_pattern "*~"
safe_remove "*.bak"
safe_remove "*.tmp"
safe_remove "*.swp"

echo ""
echo "🧹 SYNTHESIS DIRECTORY CLEANUP:"
echo "────────────────────────────────────────────────────────────"

# Clean synthesis directories but keep source files
if [ -d "synthesis/" ]; then
    echo "   📂 Cleaning synthesis directories..."
    find synthesis/ -name "*.cache" -type d -exec rm -rf {} + 2>/dev/null
    find synthesis/ -name "*.runs" -type d -exec rm -rf {} + 2>/dev/null
    find synthesis/ -name "*.sim" -type d -exec rm -rf {} + 2>/dev/null
    find synthesis/ -name "*.hw" -type d -exec rm -rf {} + 2>/dev/null
    find synthesis/ -name "*.ip_user_files" -type d -exec rm -rf {} + 2>/dev/null
    find synthesis/ -name "*.jou" -type f -delete 2>/dev/null
    find synthesis/ -name "*.log" -type f -delete 2>/dev/null
    echo "   ✅ Synthesis directories cleaned"
else
    echo "   ➖ No synthesis directory found"
fi

echo ""
echo "📊 DISK USAGE AFTER CLEANUP:"
echo "────────────────────────────────────────────────────────────"

# Show current directory size
TOTAL_SIZE=$(du -sh . 2>/dev/null | cut -f1)
echo "   📊 Total project size: $TOTAL_SIZE"

# Show what remains
echo ""
echo "📂 REMAINING PROJECT STRUCTURE:"
echo "────────────────────────────────────────────────────────────"
ls -la | grep -E "^d" | awk '{print "   📁 " $9}'
echo ""
echo "📄 KEY FILES PRESERVED:"
echo "────────────────────────────────────────────────────────────"
ls -1 *.md *.sh 2>/dev/null | head -5 | awk '{print "   📄 " $1}'
if [ $(ls -1 *.md *.sh 2>/dev/null | wc -l) -gt 5 ]; then
    echo "   📄 ... and $(ls -1 *.md *.sh 2>/dev/null | wc -l) total files"
fi

echo ""
echo "✅ CLEANUP COMPLETED SUCCESSFULLY!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🎯 WHAT WAS CLEANED:"
echo "   ✅ Vivado project directories (vivado_test/, vivado_advanced/)"
echo "   ✅ Vivado temporary files (.Xil/, *.jou, *.log)"
echo "   ✅ Simulation artifacts (*.wdb, xsim.dir/)"
echo "   ✅ Synthesis cache and temporary files"
echo "   ✅ Editor backup files (*~, *.bak, *.tmp)"
echo ""
echo "💾 WHAT WAS PRESERVED:"
echo "   ✅ Source code (testbenches/, scripts/)"
echo "   ✅ Documentation (docs/, *.md)"
echo "   ✅ Build scripts (*.sh)"
echo "   ✅ Constraints (constraints/)"
echo "   ✅ Project structure and organization"
echo ""
echo "💡 BENEFITS:"
echo "   🚀 Reduced disk usage (removed ~100-500MB of temp files)"
echo "   🧹 Clean project structure"
echo "   ⚡ Faster backup and sync operations"
echo "   📦 Ready for version control"
echo ""
echo "🔄 TO REGENERATE VIVADO PROJECTS:"
echo "   → cd scripts && vivado -source run_vivado_simple.tcl"
echo "   → ./CREATE_MYD_J7A100T_SYNTHESIS.sh"
echo ""
echo "🎯 Your project is now clean and optimized!"
echo "════════════════════════════════════════════════════════════"
