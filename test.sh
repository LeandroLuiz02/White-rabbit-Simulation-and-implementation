#!/bin/bash
# Quick access to test and analysis scripts

echo "🧪 Opções de verificação do projeto:"
echo "1. Teste rápido do projeto"
echo "2. Verificação completa e sistemática"
echo ""

if [ "$1" == "full" ]; then
    echo "🔍 Executando verificação completa..."
    ./scripts/tools/FINAL_PROJECT_VERIFICATION.sh
elif [ "$1" == "summary" ]; then
    echo "📊 Executando resumo de verificação..."
    ./scripts/tools/VERIFICACAO_FINAL_COMPLETA.sh
else
    echo "🧪 Executando verificação rápida do projeto..."
    ./scripts/tools/test_project.sh "$@"
fi
