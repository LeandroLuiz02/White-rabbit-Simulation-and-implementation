//
// White Rabbit Two-Node - Testbench Simplificado
// 
// Este testbench não depende dos módulos WR cores reais
// Útil para verificar a sintaxe e testar a estrutura básica
//

`timescale 1ns/1ps

// Módulo simulado do spec_top para testes
module spec_top #(
    parameter g_simulation = 1
) (
    // Clock inputs
    input clk_125m_pllref_p_i,
    input clk_125m_pllref_n_i,
    
    // UART 
    output uart_txd_o,
    
    // SFP Ethernet
    output sfp_txp_o,
    output sfp_txn_o,
    input  sfp_rxp_i,
    input  sfp_rxn_i
);

    // Contador para simular atividade
    reg [31:0] counter = 0;
    reg uart_bit = 1;
    reg eth_bit = 0;
    
    // Clock interno derivado
    wire clk_internal = clk_125m_pllref_p_i;
    
    always @(posedge clk_internal) begin
        counter <= counter + 1;
        
        // Simular transmissão UART periódica
        if (counter[15:0] == 16'h0000) begin
            uart_bit <= ~uart_bit;
        end
        
        // Simular atividade Ethernet
        eth_bit <= counter[10];
    end
    
    // Atribuir saídas
    assign uart_txd_o = uart_bit;
    assign sfp_txp_o = eth_bit;
    assign sfp_txn_o = ~eth_bit;
    
    // Mensagem de debug para saber que o módulo está ativo
    initial begin
        $display("SPEC_TOP simulado inicializado (instância: %m)");
    end

endmodule

// Monitor UART simplificado
module uart_monitor_simple 
  (
   input            rxd,
   input [7:0]      node_id
   );

   reg last_rxd = 1;
   
   always @(rxd) begin
      if (rxd != last_rxd) begin
         $display("[%0t] Node %0d UART mudou para: %b", $time, node_id, rxd);
         last_rxd = rxd;
      end
   end
endmodule

// Testbench principal simplificado
module wr_standalone_basic_tb;

   // Clock de referência - 125 MHz
   parameter g_ref_clock_period = 8ns;
   reg ref_clk = 0;
   always #(g_ref_clock_period / 2) ref_clk <= ~ref_clk;

   // Sinais de saída dos nós
   wire uart_node1, uart_node2;
   
   // Conexões Ethernet entre nós
   wire gb_txp_1to2, gb_txn_1to2;
   wire gb_txp_2to1, gb_txn_2to1;

   //
   // Nó 1: Master simulado
   //
   spec_top #(
       .g_simulation(1)
   ) wr_node1 (
       .clk_125m_pllref_p_i(ref_clk),
       .clk_125m_pllref_n_i(~ref_clk),
       .uart_txd_o(uart_node1),
       .sfp_txp_o(gb_txp_1to2),
       .sfp_txn_o(gb_txn_1to2),
       .sfp_rxp_i(gb_txp_2to1),
       .sfp_rxn_i(gb_txn_2to1)
   );

   //
   // Nó 2: Slave simulado
   //
   spec_top #(
       .g_simulation(1)
   ) wr_node2 (
       .clk_125m_pllref_p_i(ref_clk),
       .clk_125m_pllref_n_i(~ref_clk),
       .uart_txd_o(uart_node2),
       .sfp_txp_o(gb_txp_2to1),
       .sfp_txn_o(gb_txn_2to1),
       .sfp_rxp_i(gb_txp_1to2),
       .sfp_rxn_i(gb_txn_1to2)
   );

   // Monitores UART
   uart_monitor_simple node1_uart_mon(
      .rxd(uart_node1),
      .node_id(8'd1)
   );

   uart_monitor_simple node2_uart_mon(
      .rxd(uart_node2), 
      .node_id(8'd2)
   );

   // Controle da simulação
   initial begin
      $display("========================================");
      $display("  Testbench Simplificado White Rabbit");
      $display("========================================");
      $display("Testando estrutura básica de dois nós");
      $display("Módulos spec_top são simulações simples");
      $display("========================================");
      
      // Executar por tempo suficiente para ver atividade
      #10ms;
      
      $display("========================================");
      $display("Teste de estrutura básica concluído!");
      $display("- Clock funcionando: %0d transições", $time / g_ref_clock_period);
      $display("- Nós instanciados e conectados");
      $display("- Comunicação Ethernet simulada");
      $display("========================================");
      $finish;
   end
   
   // Gerar arquivo VCD para análise
   initial begin
      $dumpfile("simple_wr_test.vcd");
      $dumpvars(0, simple_wr_testbench);
   end
   
   // Monitor de atividade geral
   initial begin
      #1ms;
      $display("[%0t] Simulação em andamento...", $time);
      #4ms;
      $display("[%0t] Metade da simulação...", $time);
   end

endmodule
