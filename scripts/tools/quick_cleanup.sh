#!/bin/bash
#
# Quick Vivado Cleanup - Minimal cleanup for regular use
# This script removes only Vivado temporary files, keeping projects
#

echo "🧹 Quick Vivado Cleanup..."

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

# Remove temporary files only
echo "   Cleaning Vivado temporary files..."
rm -rf .Xil/ 2>/dev/null && echo "   🗑️  Removed: .Xil/" || echo "   ➖ Not found: .Xil/"

# Remove Vivado logs in scripts/ directory
if [ -f "scripts/vivado.jou" ]; then
    rm -f scripts/vivado.jou
    echo "   🗑️  Removed: scripts/vivado.jou"
fi
if [ -f "scripts/vivado.log" ]; then
    rm -f scripts/vivado.log
    echo "   🗑️  Removed: scripts/vivado.log"
fi

# Remove .Xil directories in scripts/
if [ -d "scripts/.Xil" ]; then
    rm -rf scripts/.Xil/
    echo "   🗑️  Removed: scripts/.Xil/"
fi

remove_pattern "vivado*.jou"
remove_pattern "vivado*.log"
remove_pattern "vivado_*.backup.jou"
remove_pattern "vivado_*.backup.log"
remove_pattern "*.pb"
remove_pattern "usage_statistics_webtalk.*"
remove_pattern "webtalk*.jou"
remove_pattern "webtalk*.log"

# Additional Vivado log cleanup
remove_pattern "*/*.jou"
remove_pattern "*/*.log"
remove_pattern "*/vivado.jou"
remove_pattern "*/vivado.log"

echo "✅ Quick cleanup completed!"
