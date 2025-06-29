#!/bin/bash
# Quick access to setup scripts
echo "⚙️ Acessando scripts de setup..."
echo ""
echo "Scripts disponíveis:"
echo "  1. scripts/setup/MYD_J7A100T_SETUP.sh"
echo "  2. scripts/setup/IMPLEMENTATION_ROADMAP.sh"
echo ""
echo "Use: ./setup.sh [1|2] ou execute diretamente"

if [ "$1" = "1" ]; then
    ./scripts/setup/MYD_J7A100T_SETUP.sh
elif [ "$1" = "2" ]; then
    ./scripts/setup/IMPLEMENTATION_ROADMAP.sh
fi
