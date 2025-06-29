# --- Script Vivado XSim - Versão Completa Two-Node ---
# Para rodar two_node_testbench.sv no Vivado (versão mais completa)
#
# USO: vivado -mode batch -source run_vivado_full.tcl
#

puts "========================================"
puts "White Rabbit Full Two-Node Testbench"
puts "========================================"

# Configuração de caminhos
set current_dir [pwd]
set wr_cores_path "../wr-cores"
set course_path "../course code examples/WR-Course"

puts "Diretório atual: $current_dir"
puts "WR Cores path: $wr_cores_path"

# Verificar se os caminhos existem
if {![file exists $wr_cores_path]} {
    puts "WARNING: Diretório wr-cores não encontrado"
    puts "Por favor, ajuste a variável wr_cores_path"
}

# Lista de arquivos para simulação
set hdl_files [list "two_node_testbench.sv"]

# Tentar adicionar arquivos do WR cores automaticamente
if {[file exists "$wr_cores_path"]} {
    # spec_top principal
    if {[file exists "$wr_cores_path/top/spec_ref_design/spec_wr_ref_top.vhd"]} {
        lappend hdl_files "$wr_cores_path/top/spec_ref_design/spec_wr_ref_top.vhd"
        puts "Adicionado: spec_wr_ref_top.vhd"
    }
    
    # Arquivos do core WR
    if {[file exists "$wr_cores_path/modules/wrc_core/wr_core.vhd"]} {
        lappend hdl_files "$wr_cores_path/modules/wrc_core/wr_core.vhd"
        puts "Adicionado: wr_core.vhd"
    }
}

puts "Total de arquivos: [llength $hdl_files]"
foreach file $hdl_files {
    puts "  - $file"
}

# Criar projeto de simulação em memória
puts "Criando projeto Vivado em memória..."
create_project -in_memory -part xc7a100tcsg324-1

# Adicionar arquivos ao projeto
puts "Adicionando arquivos fonte..."
if {[llength $hdl_files] > 0} {
    add_files -norecurse $hdl_files
    
    # Configurar bibliotecas VHDL se necessário
    foreach file $hdl_files {
        if {[string match "*.vhd" $file]} {
            if {[string match "*wrc*" $file] || [string match "*wr_core*" $file]} {
                catch {set_property library wr_lib [get_files [file tail $file]]}
            }
        }
    }
} else {
    puts "ERRO: Nenhum arquivo fonte encontrado!"
    return
}

# Configurar simulação
puts "Configurando simulação..."
set_property top two_node_testbench [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Parâmetros de simulação
set_property -name {xsim.simulate.runtime} -value {50ms} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.wdb} -value {two_node_testbench.wdb} -objects [get_filesets sim_1]

# Tentar compilar e iniciar simulação
puts "Compilando e iniciando simulação..."
if {[catch {launch_simulation} sim_error]} {
    puts "ERRO na simulação: $sim_error"
    puts "Verifique se todos os arquivos WR cores estão disponíveis"
    return
}

# Configurar visualização de ondas detalhada
puts "Configurando visualização avançada..."

# Grupo: Sistema
add_wave_group "Sistema" 
add_wave /two_node_testbench/clk_125m
add_wave /two_node_testbench/clk_20m
add_wave /two_node_testbench/rst_n

# Grupo: Status dos Nós
add_wave_group "Status dos Nós"
add_wave /two_node_testbench/link_up_node1
add_wave /two_node_testbench/link_up_node2
add_wave /two_node_testbench/pps_node1
add_wave /two_node_testbench/pps_node2

# Grupo: UART Debug
add_wave_group "UART Debug"
add_wave /two_node_testbench/uart_txd_node1
add_wave /two_node_testbench/uart_txd_node2
add_wave -radix ascii /two_node_testbench/uart_data_node1
add_wave -radix ascii /two_node_testbench/uart_data_node2
add_wave /two_node_testbench/uart_valid_node1
add_wave /two_node_testbench/uart_valid_node2

# Grupo: Ethernet Físico
add_wave_group "Ethernet Físico"
add_wave /two_node_testbench/sfp_txp_1to2
add_wave /two_node_testbench/sfp_txn_1to2
add_wave /two_node_testbench/sfp_txp_2to1
add_wave /two_node_testbench/sfp_txn_2to1

# Grupo: Medições de Tempo
add_wave_group "Medições"
add_wave /two_node_testbench/pps1_time
add_wave /two_node_testbench/pps2_time
add_wave /two_node_testbench/time_diff

# Configurar formato de exibição
configure_wave -namecolwidth 200
configure_wave -valuecolwidth 80

# Executar simulação
puts "Executando simulação por 50ms..."
puts "Aguarde a inicialização dos nós White Rabbit..."
run 50ms

# Status final
puts "========================================"
puts "Simulação Full Two-Node concluída!"
puts ""
puts "O que observar:"
puts "- Mensagens de boot via UART"
puts "- Estabelecimento dos links Ethernet" 
puts "- Sincronização PPS entre os nós"
puts "- Diferença temporal entre pulsos PPS"
puts ""
puts "Comandos úteis:"
puts "- 'zoom fit' para ver toda a simulação"
puts "- 'run 10ms' para continuar simulação"
puts "- Verifique o console para mensagens UART"
puts "========================================"
