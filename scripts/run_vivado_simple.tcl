# --- Script Vivado XSim - Versão Simples Two-Node ---
# Para rodar simple_two_node.sv no Vivado
#
# USO: vivado -mode batch -source run_vivado_simple.tcl
#

puts "========================================"
puts "White Rabbit Simple Two-Node Simulation"
puts "========================================"

# Caminhos principais
set current_dir [pwd]
set wr_cores_path "../wr-cores"
set course_path "../course code examples/WR-Course"

# Verificar caminhos
if {![file exists $wr_cores_path]} {
    puts "WARNING: wr-cores não encontrado em $wr_cores_path"
}

# Arquivos para compilação
set hdl_files [list "simple_two_node.sv"]

# Adicionar arquivos do curso WR se disponíveis
if {[file exists "$course_path/sim"]} {
    puts "Adicionando arquivos do WR Course..."
    # Adicionar arquivos de simulação do curso se necessário
}

# Adicionar spec_top do wr-cores se disponível
if {[file exists "$wr_cores_path/top/spec_ref_design/spec_wr_ref_top.vhd"]} {
    lappend hdl_files "$wr_cores_path/top/spec_ref_design/spec_wr_ref_top.vhd"
    puts "Adicionado: spec_wr_ref_top.vhd"
}

puts "Arquivos a compilar: $hdl_files"

# Criar projeto em memória
puts "Criando projeto de simulação..."
create_project -in_memory -part xc7a100tcsg324-1

# Adicionar arquivos
puts "Adicionando arquivos fonte..."
add_files -norecurse $hdl_files

# Configurar top level
set_property top simple_two_node_wr [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Configurações de simulação
set_property -name {xsim.simulate.runtime} -value {100ms} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

# Iniciar simulação
puts "Iniciando simulação..."
launch_simulation

# Configurar ondas
puts "Configurando visualização..."

# Sistema
add_wave_group "Sistema"
add_wave /simple_two_node_wr/clk

# Nó 1
add_wave_group "Nó 1 (Master)"
add_wave /simple_two_node_wr/uart_txd_node1
add_wave /simple_two_node_wr/uart_data_node1
add_wave /simple_two_node_wr/uart_valid_node1
add_wave /simple_two_node_wr/link_up_node1

# Nó 2  
add_wave_group "Nó 2 (Slave)"
add_wave /simple_two_node_wr/uart_txd_node2
add_wave /simple_two_node_wr/uart_data_node2
add_wave /simple_two_node_wr/uart_valid_node2
add_wave /simple_two_node_wr/link_up_node2

# Interconexão
add_wave_group "Ethernet"
add_wave /simple_two_node_wr/link_node1_to_node2_p
add_wave /simple_two_node_wr/link_node1_to_node2_n
add_wave /simple_two_node_wr/link_node2_to_node1_p
add_wave /simple_two_node_wr/link_node2_to_node1_n

# Executar simulação
puts "Executando simulação por 100ms..."
run 100ms

puts "========================================"
puts "Simulação Simple Two-Node concluída!"
puts "- Monitore UART output de ambos os nós"
puts "- Verifique status dos links Ethernet"
puts "- Use 'zoom fit' para visualizar tudo"
puts "========================================"
