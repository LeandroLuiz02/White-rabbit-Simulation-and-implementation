# --- Script de Limpeza Vivado ---
# Remove todos os arquivos temporários gerados pelas simulações
#
# USO: vivado -mode batch -source cleanup_vivado.tcl
# Ou no TCL Console: source cleanup_vivado.tcl
#

puts "========================================"
puts "Limpeza de Arquivos Temporários Vivado"
puts "========================================"

set current_dir [pwd]
puts "Diretório atual: $current_dir"

# Lista de diretórios e arquivos temporários a remover
set temp_items [list \
    "vivado_test" \
    "vivado_minimal" \
    "vivado_simple" \
    "vivado_full" \
    "wr_test_project" \
    "wr_minimal_project" \
    "wr_simple_project" \
    "wr_full_project" \
    "*.wdb" \
    "*.vcd" \
    "*.log" \
    "*.jou" \
    "*.pb" \
    ".Xil" \
    "xsim.dir" \
    "webtalk*" \
]

set removed_count 0
set total_size 0

foreach item $temp_items {
    # Usar glob para encontrar arquivos/diretórios que correspondem ao padrão
    set matches [glob -nocomplain $item]
    
    foreach match $matches {
        if {[file exists $match]} {
            # Calcular tamanho antes de remover (aproximado)
            if {[file isdirectory $match]} {
                puts "Removendo diretório: $match"
            } else {
                set size [file size $match]
                set total_size [expr $total_size + $size]
                puts "Removendo arquivo: $match ([expr $size/1024] KB)"
            }
            
            # Tentar remover
            if {[catch {file delete -force $match} delete_error]} {
                puts "AVISO: Não foi possível remover $match: $delete_error"
            } else {
                incr removed_count
            }
        }
    }
}

# Fechar projeto se estiver aberto
if {[catch {close_project} close_error]} {
    # Não há problema se não houver projeto aberto
}

puts ""
puts "========================================"
puts "Limpeza Concluída!"
puts "- Itens removidos: $removed_count"
if {$total_size > 0} {
    puts "- Espaço liberado: [expr $total_size/1024/1024] MB (aproximado)"
}
puts ""
puts "Diretório limpo e pronto para novas simulações."
puts "========================================"
