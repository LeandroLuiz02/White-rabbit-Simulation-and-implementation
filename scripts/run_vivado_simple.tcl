# --- Script Vivado XSim - Versão Simples Two-Node ---
# Para rodar wr_standalone_basic_tb.sv no Vivado
#
# USO: vivado -mode batch -source run_vivado_simple.tcl
#

puts "========================================"
puts "White Rabbit Simple Two-Node Simulation"
puts "========================================"

# Caminhos principais
set current_dir [pwd]
set script_dir [file dirname [info script]]
set project_root [file normalize "$script_dir/.."]
set wr_cores_path "$project_root/../wr-cores"
set course_path "$project_root/../course code examples/WR-Course"

puts "Script executado de: $current_dir"
puts "Diretório do script: $script_dir"
puts "Raiz do projeto: $project_root"

# Verificar caminhos
if {![file exists $wr_cores_path]} {
    puts "WARNING: wr-cores não encontrado em $wr_cores_path"
}

# Arquivos para compilação (caminho corrigido)
set hdl_files [list "$project_root/testbenches/wr_standalone_basic_tb.sv"]

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

# Verificar se o arquivo testbench existe
set testbench_file [lindex $hdl_files 0]
if {![file exists $testbench_file]} {
    puts "ERROR: Arquivo testbench não encontrado: $testbench_file"
    puts "Diretório atual: [pwd]"
    puts "Listando testbenches disponíveis:"
    catch {glob "$project_root/testbenches/*.sv"} available_files
    foreach file $available_files {
        puts "  - [file tail $file]"
    }
    exit 1
}

puts "Arquivos a compilar: $hdl_files"

# Criar projeto temporário (não in-memory)
set project_name "wr_simple_sim"
set project_dir "vivado_sim_temp"

puts "Criando projeto de simulação..."
if {[file exists $project_dir]} {
    file delete -force $project_dir
}
create_project $project_name $project_dir -part xc7a100tcsg324-1

# Adicionar arquivos
puts "Adicionando arquivos fonte..."
add_files -norecurse $hdl_files

# Configurar top level
set_property top wr_standalone_basic_tb [get_filesets sim_1]
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
add_wave /wr_standalone_basic_tb/clk

# Nó 1
add_wave_group "Nó 1 (Master)"
add_wave /wr_standalone_basic_tb/uart_txd_node1
add_wave /wr_standalone_basic_tb/uart_data_node1
add_wave /wr_standalone_basic_tb/uart_valid_node1
add_wave /wr_standalone_basic_tb/link_up_node1

# Nó 2  
add_wave_group "Nó 2 (Slave)"
add_wave /wr_standalone_basic_tb/uart_txd_node2
add_wave /wr_standalone_basic_tb/uart_data_node2
add_wave /wr_standalone_basic_tb/uart_valid_node2
add_wave /wr_standalone_basic_tb/link_up_node2

# Interconexão
add_wave_group "Ethernet"
add_wave /wr_standalone_basic_tb/link_node1_to_node2_p
add_wave /wr_standalone_basic_tb/link_node1_to_node2_n
add_wave /wr_standalone_basic_tb/link_node2_to_node1_p
add_wave /wr_standalone_basic_tb/link_node2_to_node1_n

# Executar simulação
puts "Executando simulação por 100ms..."
run 100ms

puts "========================================"
puts "Simulação Simple Two-Node concluída!"
puts "- Monitore UART output de ambos os nós"
puts "- Verifique status dos links Ethernet"
puts "- Use 'zoom fit' para visualizar tudo"
puts "========================================"
puts "Projeto salvo em: $project_dir"
puts "Para abrir novamente: vivado $project_dir/$project_name.xpr"

# Cleanup opcional - descomente para remover projeto temporário
# puts "Removendo projeto temporário..."
# close_project
# file delete -force $project_dir
