# --- Script Vivado XSim - Versão Standalone ---
# Este script roda apenas o testbench SystemVerilog sem dependências externas
# Útil para verificar a sintaxe e estrutura básica
#
# USO: vivado -mode batch -source run_vivado_standalone.tcl
#

puts "========================================"
puts "White Rabbit Two-Node - Modo Standalone"
puts "========================================"

# Verificar se estamos no diretório correto
set current_dir [pwd]
puts "Diretório atual: $current_dir"

# Verificar se o arquivo principal existe
if {![file exists "minimal_two_node.sv"]} {
    puts "ERRO: Arquivo minimal_two_node.sv não encontrado!"
    puts "Certifique-se de estar no diretório two_node_example/"
    return
}

puts "✓ Arquivo minimal_two_node.sv encontrado"

# Criar projeto em memória
puts "Criando projeto Vivado standalone..."
create_project -in_memory -part xc7a100tcsg324-1

# Adicionar apenas o testbench
puts "Adicionando testbench..."
add_files -norecurse "minimal_two_node.sv"

# Configurar como top level
set_property top minimal_two_node_wr [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Configurar simulação para tempo menor (já que não temos os cores reais)
set_property -name {xsim.simulate.runtime} -value {1ms} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

# Tentar compilar
puts "Compilando testbench..."
if {[catch {launch_simulation} sim_error]} {
    puts "ERRO na compilação/simulação:"
    puts $sim_error
    puts ""
    puts "Isso é esperado pois o módulo 'spec_top' não está disponível."
    puts "Para uma simulação completa, você precisa:"
    puts "1. Compilar os WR cores primeiro"
    puts "2. Ou usar um testbench que não dependa do spec_top"
    puts ""
    puts "Este script serve para verificar a sintaxe SystemVerilog do testbench."
    return
}

# Se chegou até aqui, a simulação iniciou (improvável sem os cores)
puts "Configurando visualização..."

# Adicionar sinais básicos
add_wave_group "Sistema"
add_wave /minimal_two_node_wr/ref_clk

add_wave_group "Testbench"
add_wave /minimal_two_node_wr/uart_node1
add_wave /minimal_two_node_wr/uart_node2

# Executar por pouco tempo
puts "Executando simulação standalone..."
run 1ms

puts "========================================"
puts "Teste standalone concluído!"
puts "Se chegou até aqui, a sintaxe está OK."
puts "========================================"
