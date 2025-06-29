// wr_streamers_tb.sv
// White Rabbit Streamers Testbench

`timescale 1ns/1ps

module wr_streamers_tb;

    logic clk_sys = 0;
    logic rst_n = 0;
    
    // TX Streamer
    logic [31:0] tx_data;
    logic tx_valid, tx_dreq;
    logic tx_last, tx_flush;
    
    // RX Streamer  
    logic [31:0] rx_data;
    logic rx_valid, rx_dreq;
    logic rx_last;
    
    // Timing
    logic [63:0] tm_tai;
    logic tm_tai_valid;
    
    always #4ns clk_sys = ~clk_sys;
    
    initial begin
        rst_n = 0;
        tx_data = 0;
        tx_valid = 0;
        tx_last = 0;
        tx_flush = 0;
        rx_dreq = 1;
        tm_tai = 0;
        tm_tai_valid = 0;
        
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR Streamers Testbench Starting...");
        
        // Enable timing
        tm_tai_valid = 1;
        
        // Send test data
        repeat(16) begin
            @(posedge clk_sys);
            if (tx_dreq) begin
                tx_data = $random;
                tx_valid = 1;
                if ($random % 8 == 0) tx_last = 1;
                else tx_last = 0;
            end else begin
                tx_valid = 0;
            end
            
            tm_tai = tm_tai + 8;
        end
        
        tx_valid = 0;
        #1000ns;
        
        $display("WR Streamers Testbench Complete");
        $finish;
    end
    
    // Monitor received data
    always @(posedge clk_sys) begin
        if (rx_valid && rx_dreq) begin
            $display("RX Data: %h, Last: %b at time %0t", rx_data, rx_last, $time);
        end
    end

endmodule
