//
// White Rabbit Two-Node Example
//
// This testbench demonstrates two White Rabbit nodes connected together.
// Node 1 acts as the master (Grandmaster Clock) and Node 2 synchronizes to it.
//

`timescale 1ps/1ps

// Simple UART receiver module to decode messages from WR nodes
module uart_receiver 
  (
   input            clk,
   input            rxd,
   output reg [7:0] data,
   output reg       valid,
   input [31:0]     node_id
   );

   parameter g_bit_time = 160ns;
   
   reg [9:0] rx_shift_reg;
   
   initial forever begin
      int i;
      @(negedge rxd);
      rx_shift_reg = 0;
      valid = 0;
      
      for(i = 0; i < 10; i++) begin
         #(g_bit_time / 2);
         rx_shift_reg[i] = rxd;
         #(g_bit_time / 2);
      end
      
      data <= rx_shift_reg[8:1];
      valid <= 1;
      #10ns;
      valid <= 0;
   end
endmodule

module wr_master_slave_sync_tb;

   // Clock and reset signals
   parameter g_ref_clock_period = 8ns;  // 125 MHz reference clock
   parameter g_20m_clock_period = 50ns; // 20 MHz VCXO clock
   
   reg clk_125m = 0;
   reg clk_20m = 0;
   reg rst_n = 0;
   
   // Generate clocks
   always #(g_ref_clock_period / 2) clk_125m <= ~clk_125m;
   always #(g_20m_clock_period / 2) clk_20m <= ~clk_20m;
   
   // Node 1 signals (Master/Grandmaster)
   wire uart_txd_node1;
   wire link_up_node1;
   wire pps_node1;
   wire [7:0] uart_data_node1;
   wire uart_valid_node1;
   
   // Node 2 signals (Slave)
   wire uart_txd_node2;
   wire link_up_node2;
   wire pps_node2;
   wire [7:0] uart_data_node2;
   wire uart_valid_node2;
   
   // Interconnection signals between nodes
   wire sfp_txp_1to2, sfp_txn_1to2;
   wire sfp_txp_2to1, sfp_txn_2to1;
   
   // Reset generation
   initial begin
      rst_n = 0;
      #1000ns;
      rst_n = 1;
      $display("Reset released, starting White Rabbit node initialization...");
   end
   
   // Node 1: Master/Grandmaster Clock
   spec_top #(
      .g_simulation(1),
      .g_dpram_initf("../../../bin/wrpc/wrc.bram")
   ) node1 (
      // Clock inputs
      .clk_125m_pllref_p_i(clk_125m),
      .clk_125m_pllref_n_i(~clk_125m),
      .fpga_pll_ref_clk_101_p_i(clk_125m),
      .fpga_pll_ref_clk_101_n_i(~clk_125m),
      .clk_20m_vcxo_i(clk_20m),
      
      // Reset
      .rst_n_i(rst_n),
      
      // UART output
      .uart_txd_o(uart_txd_node1),
      
      // PPS output
      .pps_p_o(pps_node1),
      
      // SFP interface (connected to Node 2)
      .sfp_txp_o(sfp_txp_1to2),
      .sfp_txn_o(sfp_txn_1to2),
      .sfp_rxp_i(sfp_txp_2to1),
      .sfp_rxn_i(sfp_txn_2to1),
      
      // Link status
      .link_up_o(link_up_node1),
      
      // Unused inputs tied off
      .button1_i(1'b0),
      .button2_i(1'b0)
   );
   
   // Node 2: Slave Node
   spec_top #(
      .g_simulation(1),
      .g_dpram_initf("../../../bin/wrpc/wrc.bram")
   ) node2 (
      // Clock inputs
      .clk_125m_pllref_p_i(clk_125m),
      .clk_125m_pllref_n_i(~clk_125m),
      .fpga_pll_ref_clk_101_p_i(clk_125m),
      .fpga_pll_ref_clk_101_n_i(~clk_125m),
      .clk_20m_vcxo_i(clk_20m),
      
      // Reset
      .rst_n_i(rst_n),
      
      // UART output
      .uart_txd_o(uart_txd_node2),
      
      // PPS output
      .pps_p_o(pps_node2),
      
      // SFP interface (connected to Node 1)
      .sfp_txp_o(sfp_txp_2to1),
      .sfp_txn_o(sfp_txn_2to1),
      .sfp_rxp_i(sfp_txp_1to2),
      .sfp_rxn_i(sfp_txn_1to2),
      
      // Link status
      .link_up_o(link_up_node2),
      
      // Unused inputs tied off
      .button1_i(1'b0),
      .button2_i(1'b0)
   );
   
   // UART receivers for both nodes
   uart_receiver uart_rx_node1 (
      .clk(clk_125m),
      .rxd(uart_txd_node1),
      .data(uart_data_node1),
      .valid(uart_valid_node1),
      .node_id(32'd1)
   );
   
   uart_receiver uart_rx_node2 (
      .clk(clk_125m),
      .rxd(uart_txd_node2),
      .data(uart_data_node2),
      .valid(uart_valid_node2),
      .node_id(32'd2)
   );
   
   // Monitor and display UART output from Node 1
   always @(posedge uart_valid_node1) begin
      $display("[%0t] Node 1 (Master): '%c' (0x%02x)", $time, uart_data_node1, uart_data_node1);
   end
   
   // Monitor and display UART output from Node 2
   always @(posedge uart_valid_node2) begin
      $display("[%0t] Node 2 (Slave):  '%c' (0x%02x)", $time, uart_data_node2, uart_data_node2);
   end
   
   // Monitor link status
   always @(posedge link_up_node1) begin
      if (link_up_node1)
         $display("[%0t] Node 1: Ethernet link established", $time);
   end
   
   always @(posedge link_up_node2) begin
      if (link_up_node2)
         $display("[%0t] Node 2: Ethernet link established", $time);
   end
   
   // Monitor PPS signals to check synchronization
   real pps1_time, pps2_time, time_diff;
   
   always @(posedge pps_node1) begin
      pps1_time = $realtime;
      $display("[%0t] Node 1: PPS pulse", $time);
   end
   
   always @(posedge pps_node2) begin
      pps2_time = $realtime;
      time_diff = pps2_time - pps1_time;
      $display("[%0t] Node 2: PPS pulse (offset: %0.3f ns)", $time, time_diff);
   end
   
   // Testbench initialization
   initial begin
      $display("=== White Rabbit Two-Node Example ===");
      $display("Starting simulation with two WR nodes...");
      $display("Node 1: Master (Grandmaster Clock)");
      $display("Node 2: Slave (will sync to Node 1)");
      $display("=====================================");
      
      // Wait for significant time to see synchronization
      #50ms;
      
      $display("=== Simulation completed ===");
      $finish;
   end
   
   // Generate VCD file for waveform viewing
   initial begin
      $dumpfile("two_node_wr.vcd");
      $dumpvars(0, wr_master_slave_sync_tb);
   end

endmodule
