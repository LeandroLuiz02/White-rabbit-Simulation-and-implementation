// wr_endpoint_tb.sv
// White Rabbit Endpoint Testbench
// Simplified testbench for WR endpoint functionality

`timescale 1ns/1ps

module wr_endpoint_tb;

    // Clock and reset
    logic clk_125m = 0;
    logic rst_n = 0;
    
    // WR endpoint signals
    logic [15:0] tx_data;
    logic tx_k;
    logic tx_disparity;
    logic [15:0] rx_data;
    logic rx_k;
    logic rx_enc_err;
    
    // Test control
    logic test_done = 0;
    
    // Clock generation
    always #4ns clk_125m = ~clk_125m; // 125 MHz
    
    // Reset sequence
    initial begin
        rst_n = 0;
        #100ns;
        rst_n = 1;
        #50ns;
        
        $display("WR Endpoint Testbench Starting...");
        
        // Simple test sequence
        repeat(10) begin
            @(posedge clk_125m);
            tx_data = $random;
            tx_k = $random & 1'b1;
        end
        
        #1000ns;
        test_done = 1;
        $display("WR Endpoint Testbench Complete");
        $finish;
    end
    
    // Monitor
    always @(posedge clk_125m) begin
        if (rst_n && tx_k) begin
            $display("Time: %0t, TX Data: %h, TX K: %b", $time, tx_data, tx_k);
        end
    end

endmodule
