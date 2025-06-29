#!/bin/bash
# Quick access to cleanup scripts

if [ "$1" == "quick" ]; then
    echo "🧹 Executando limpeza rápida..."
    ./scripts/tools/quick_cleanup.sh
elif [ "$1" == "full" ]; then
    echo "🧹 Executando limpeza completa..."
    ./scripts/tools/CLEANUP_PROJECT.sh
else
    echo "🧹 Opções de limpeza disponíveis:"
    echo "  ./cleanup.sh quick  - Limpeza rápida (apenas temporários)"
    echo "  ./cleanup.sh full   - Limpeza completa (projetos + temporários)"
    echo ""
    echo "🧹 Executando limpeza rápida por padrão..."
    ./scripts/tools/quick_cleanup.sh
fi
