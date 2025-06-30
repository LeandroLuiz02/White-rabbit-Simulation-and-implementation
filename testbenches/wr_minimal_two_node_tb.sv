//
// White Rabbit Two-Node Example - Minimal Version
//
// This is the simplest possible two-node White Rabbit setup.
// It's based on lesson02 from the WR Course but with two nodes connected.
//
// Each node will boot up, initialize, and attempt to establish communication.
// Look for UART output from both nodes showing their boot process and
// any synchronization messages.
//

`timescale 1ps/1ps

module uart_monitor 
  (
   input            rxd,
   input [7:0]      node_id
   );

   parameter g_bit_time = 160ns;
   
   reg [9:0] rx_bits;
   reg [7:0] rx_data;
   
   initial forever begin
      int i;

      @(negedge rxd);  // Wait for start bit
      rx_bits = 0;
      
      for(i = 0; i < 10; i++) begin
         #(g_bit_time / 2);
         rx_bits[i] = rxd;
         #(g_bit_time / 2);
      end
      
      rx_data = rx_bits[8:1];  // Extract data bits
      // system task - print on simulation console
      $display("[Node %0d] UART: '%c' (0x%02x)", node_id, rx_data, rx_data);
   end
endmodule

module wr_minimal_two_node_tb;

   // Reference clock - 125 MHz
   parameter g_ref_clock_period = 8ns;
   reg ref_clk = 0;
   always #(g_ref_clock_period / 2) ref_clk <= ~ref_clk;

   // UART outputs from both nodes
   wire uart_node1, uart_node2;
   
   // Gigabit Ethernet connections between nodes
   wire [1:0] gb_txp, gb_txn;  // [0] = node1 tx, [1] = node2 tx 
   wire [1:0] gb_rxp, gb_rxn;  // [0] = node1 rx, [1] = node2 rx

   // Cross-connect the nodes: node1 tx -> node2 rx, node2 tx -> node1 rx
   assign gb_rxp[0] = gb_txp[1];  // Node1 receives from Node2
   assign gb_rxn[0] = gb_txn[1];
   assign gb_rxp[1] = gb_txp[0];  // Node2 receives from Node1  
   assign gb_rxn[1] = gb_txn[0];

   //
   // Node 1: Will act as the Master/Grandmaster
   //
   spec_top #(
       .g_simulation(1)
   ) wr_node1 (
       // Reference clock inputs
       .clk_125m_pllref_p_i(ref_clk),
       .clk_125m_pllref_n_i(~ref_clk),
       
       // UART debug output
       .uart_txd_o(uart_node1),
       
       // Gigabit Ethernet to Node 2
       .sfp_txp_o(gb_txp[0]),
       .sfp_txn_o(gb_txn[0]),
       .sfp_rxp_i(gb_rxp[0]),
       .sfp_rxn_i(gb_rxn[0])
   );

   //
   // Node 2: Will act as a Slave, synchronizing to Node 1
   //
   spec_top #(
       .g_simulation(1)
   ) wr_node2 (
       // Reference clock inputs  
       .clk_125m_pllref_p_i(ref_clk),
       .clk_125m_pllref_n_i(~ref_clk),
       
       // UART debug output
       .uart_txd_o(uart_node2),
       
       // Gigabit Ethernet to Node 1
       .sfp_txp_o(gb_txp[1]),
       .sfp_txn_o(gb_txn[1]),
       .sfp_rxp_i(gb_rxp[1]),
       .sfp_rxn_i(gb_rxn[1])
   );

   // Monitor UART output from both nodes
   uart_monitor node1_uart_mon(
      .rxd(uart_node1),
      .node_id(8'd1)
   );

   uart_monitor node2_uart_mon(
      .rxd(uart_node2), 
      .node_id(8'd2)
   );

   // Simulation control and monitoring
   initial begin
      $display("========================================");
      $display("  White Rabbit Two-Node Example");
      $display("========================================");
      $display("Node 1: Master (will become Grandmaster)");
      $display("Node 2: Slave (will sync to Node 1)");
      $display("");
      $display("Watch for:");
      $display("- Boot messages from both nodes");
      $display("- Link establishment");
      $display("- PTP synchronization messages");
      $display("========================================");
      
      // Let the simulation run long enough to see initialization
      // and hopefully some synchronization
      #200ms;
      
      $display("========================================");
      $display("Simulation completed after 200ms");
      $display("========================================");
      $finish;
   end
   
   // Optional: Create VCD file for waveform analysis
   initial begin
      $dumpfile("minimal_two_node.vcd");
      $dumpvars(0, wr_minimal_two_node_tb);
   end

endmodule
