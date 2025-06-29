# --- Script Principal Vivado - White Rabbit Two-Node ---
# Este script permite escolher qual versão da simulação executar
#
# USO:
#   1. No Vivado TCL Console: source run_vivado_main.tcl
#   2. Ou via linha de comando: vivado -mode batch -source run_vivado_main.tcl
#

proc print_banner {} {
    puts "========================================"
    puts "    WHITE RABBIT TWO-NODE SIMULATION"
    puts "========================================"
    puts "Versões disponíveis:"
    puts "1. Minimal  - Versão mais simples"
    puts "2. Simple   - Versão intermediária" 
    puts "3. Full     - Versão completa"
    puts "========================================"
}

proc check_files {} {
    set files_status [dict create]
    
    # Verificar arquivos de testbench
    set testbenches [list "minimal_two_node.sv" "simple_two_node.sv" "two_node_testbench.sv"]
    foreach tb $testbenches {
        dict set files_status $tb [file exists $tb]
        if {[file exists $tb]} {
            puts "✓ Encontrado: $tb"
        } else {
            puts "✗ Faltando: $tb"
        }
    }
    
    # Verificar WR cores
    set wr_cores_path "../wr-cores"
    if {[file exists $wr_cores_path]} {
        puts "✓ Diretório wr-cores encontrado"
        dict set files_status "wr_cores" true
    } else {
        puts "✗ Diretório wr-cores não encontrado em $wr_cores_path"
        dict set files_status "wr_cores" false
    }
    
    return $files_status
}

proc run_minimal {} {
    puts "Executando versão MINIMAL..."
    if {[file exists "minimal_two_node.sv"]} {
        source "run_vivado.tcl"
    } else {
        puts "ERRO: Arquivo minimal_two_node.sv não encontrado!"
    }
}

proc run_simple {} {
    puts "Executando versão SIMPLE..."
    if {[file exists "simple_two_node.sv"]} {
        source "run_vivado_simple.tcl"
    } else {
        puts "ERRO: Arquivo simple_two_node.sv não encontrado!"
    }
}

proc run_full {} {
    puts "Executando versão FULL..."
    if {[file exists "two_node_testbench.sv"]} {
        source "run_vivado_full.tcl"
    } else {
        puts "ERRO: Arquivo two_node_testbench.sv não encontrado!"
    }
}

proc interactive_mode {} {
    print_banner
    
    puts "Verificando arquivos..."
    set status [check_files]
    puts ""
    
    puts "Escolha uma opção:"
    puts "1 - Executar versão Minimal"
    puts "2 - Executar versão Simple"  
    puts "3 - Executar versão Full"
    puts "q - Sair"
    puts ""
    puts -nonewline "Sua escolha: "
    flush stdout
    
    gets stdin choice
    
    switch $choice {
        "1" { run_minimal }
        "2" { run_simple }
        "3" { run_full }
        "q" { puts "Saindo..."; return }
        default { 
            puts "Opção inválida: $choice"
            puts "Executando versão Minimal por padrão..."
            run_minimal
        }
    }
}

proc batch_mode {version} {
    print_banner
    puts "Modo batch - executando versão: $version"
    
    switch $version {
        "minimal" { run_minimal }
        "simple"  { run_simple }
        "full"    { run_full }
        default {
            puts "Versão desconhecida: $version"
            puts "Versões válidas: minimal, simple, full"
            puts "Executando versão minimal por padrão..."
            run_minimal
        }
    }
}

# Função principal
proc main {} {
    global argc argv
    
    # Verificar se estamos em modo batch ou interativo
    if {$argc > 0} {
        # Modo batch com argumentos
        set version [lindex $argv 0]
        batch_mode $version
    } else {
        # Modo interativo (padrão quando executado do TCL console)
        interactive_mode
    }
}

# Auto-executar se o script for chamado diretamente
if {[info exists argc]} {
    main
} else {
    # Executado do console TCL - modo interativo
    puts "Script carregado. Digite 'main' para começar ou:"
    puts "- run_minimal para versão mínima"
    puts "- run_simple para versão simples"  
    puts "- run_full para versão completa"
}
