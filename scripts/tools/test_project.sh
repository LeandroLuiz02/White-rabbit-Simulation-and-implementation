#!/bin/bash
#
# White Rabbit Two-Node Project Verification Script
# 
# Verifies project structure and tests basic functionality
#

echo "========================================"
echo "White Rabbit Two-Node - Project Verification"
echo "========================================"

# Check current directory
if [ ! -f "README.md" ] || [ ! -d "testbenches" ]; then
    echo "❌ ERROR: Run this script from the project root directory"
    echo "   Expected structure: README.md, testbenches/, scripts/, docs/"
    exit 1
fi

echo "✅ Project directory structure detected"

# Verify project structure
echo ""
echo "📁 Verifying project structure..."

expected_dirs=("testbenches" "scripts" "docs")
for dir in "${expected_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ $dir/ - MISSING!"
    fi
done

# Check essential files
echo ""
echo "📋 Verificando arquivos essenciais..."

essential_files=(
    "testbenches/wr_standalone_basic_tb.sv"
    "scripts/run_vivado_simple.tcl"
    "scripts/run_vivado_sim.tcl"
    "constraints/myd_j7a100t_complete.xdc"
)

for file in "${essential_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - FALTANDO!"
    fi
done

# Check testbenches
echo ""
echo "🧪 Testbenches disponíveis:"
testbench_count=0
if [ -d "testbenches" ]; then
    for file in testbenches/*.sv; do
        if [ -f "$file" ]; then
            echo "✅ $(basename $file)"
            ((testbench_count++))
        fi
    done
    echo "   Total: $testbench_count testbenches"
else
    echo "❌ Diretório testbenches/ não encontrado!"
fi

# Check simulation scripts
echo ""
echo "🛠️ Scripts de simulação:"
sim_script_count=0

# Check Vivado scripts
echo "   Vivado (*.tcl):"
for file in scripts/*.tcl; do
    if [ -f "$file" ]; then
        echo "   ✅ $(basename $file)"
        ((sim_script_count++))
    fi
done

# Check ModelSim scripts
echo "   ModelSim (*.do):"
for file in scripts/*.do; do
    if [ -f "$file" ]; then
        echo "   ✅ $(basename $file)"
        ((sim_script_count++))
    fi
done

echo "   Total: $sim_script_count scripts de simulação"

# Verify SystemVerilog syntax
echo ""
echo "🔍 Checking SystemVerilog syntax..."

sv_files=(testbenches/*.sv)
for file in "${sv_files[@]}"; do
    if [ -f "$file" ]; then
        # Basic syntax check (look for essential keywords)
        if grep -q "module" "$file" && grep -q "endmodule" "$file"; then
            echo "✅ $(basename $file) - Basic syntax OK"
        else
            echo "⚠️ $(basename $file) - Check syntax"
        fi
    fi
done

# Check if Vivado is available
echo ""
echo "🔧 Checking tools..."

if command -v vivado &> /dev/null; then
    echo "✅ Vivado found: $(vivado -version | head -1)"
    
    # Quick Vivado test (dry-run)
    echo ""
    echo "🧪 Running basic Vivado test..."
    echo "   (This may take a few seconds...)"
    
    # Create minimal test script
    cat > test_vivado_temp.tcl << 'EOF'
puts "Quick Vivado test OK"
quit
EOF
    
    if vivado -mode batch -source test_vivado_temp.tcl > /dev/null 2>&1; then
        echo "✅ Vivado working correctly"
    else
        echo "⚠️ Vivado may have issues - check installation"
    fi
    
    rm -f test_vivado_temp.tcl
else
    echo "❌ Vivado not found in PATH"
    echo "   Install Vivado or add to PATH"
fi

# Check if ModelSim is available (optional)
if command -v vsim &> /dev/null; then
    echo "✅ ModelSim/QuestaSim found"
elif command -v modelsim &> /dev/null; then
    echo "✅ ModelSim found"
else
    echo "ℹ️ ModelSim not found (optional)"
fi

# Project summary
echo ""
echo "========================================"
echo "📊 PROJECT SUMMARY"
echo "========================================"
echo ""
echo "1. SIMULAÇÃO BÁSICA (Funciona imediatamente):"
echo "   vivado -source scripts/run_vivado_simple.tcl"
echo "   • Testbench: wr_standalone_basic_tb.sv"
echo "   • Sem dependências externas"
echo ""
echo "2. SIMULAÇÃO ESPECÍFICA (Por componente):"
echo "   vivado -source scripts/run_vivado_sim.tcl"
echo "   • Múltiplos testbenches disponíveis"
echo "   • Testa componentes individuais"
echo ""
echo "3. SIMULAÇÃO COMPLETA (Sistema completo):"
echo "   vivado -source scripts/run_vivado_full.tcl"
echo "   • Sistema de dois nós completo"
echo "   • Simulação mais avançada"
echo ""
echo "� SÍNTESE PARA HARDWARE:"
echo "   ./scripts/build/CREATE_MYD_J7A100T_SYNTHESIS.sh"
echo "   • Cria projeto para placa MYD-J7A100T"
echo "   • Arquivo de constraints completo"
echo ""
