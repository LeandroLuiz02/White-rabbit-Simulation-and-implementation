#!/bin/bash
# Quick access to build scripts
echo "🔧 Acessando scripts de build..."
echo ""
echo "Scripts disponíveis:"
echo "  1. scripts/build/BUILD_REAL_WR.sh"
echo "  2. scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh"
echo "  3. scripts/build/BUILD_HARDWARE_FIRST.sh"
echo ""
echo "Use: ./build.sh [1|2|3] ou execute diretamente:"
echo "     ./scripts/build/BUILD_REAL_WR.sh"

if [ "$1" = "1" ]; then
    ./scripts/build/BUILD_REAL_WR.sh
elif [ "$1" = "2" ]; then
    ./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh
elif [ "$1" = "3" ]; then
    ./scripts/build/BUILD_HARDWARE_FIRST.sh
fi
