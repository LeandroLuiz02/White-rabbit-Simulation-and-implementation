// wr_timing_tb.sv
// White Rabbit Timing Testbench

`timescale 1ns/1ps

module wr_timing_tb;

    logic clk_sys = 0;
    logic clk_ref = 0;
    logic rst_n = 0;
    
    // Timing signals
    logic [63:0] tm_tai;
    logic [31:0] tm_cycles;
    logic tm_tai_valid;
    logic pps_out;
    logic pps_in;
    
    // WR timing specific
    logic [31:0] cntr_nsec;
    logic [39:0] cntr_utc;
    logic cntr_valid;
    
    always #4ns clk_sys = ~clk_sys;     // 125 MHz
    always #3.2ns clk_ref = ~clk_ref;   // 156.25 MHz
    
    initial begin
        rst_n = 0;
        pps_in = 0;
        tm_tai = 64'h0000000000000000;
        tm_cycles = 0;
        tm_tai_valid = 0;
        
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR Timing Testbench Starting...");
        
        // Enable timing
        tm_tai_valid = 1;
        
        // Simulate time progression
        repeat(10000) begin
            @(posedge clk_sys);
            tm_cycles = tm_cycles + 1;
            if (tm_cycles >= 125000000) begin // 1 second at 125MHz
                tm_cycles = 0;
                tm_tai = tm_tai + 1;
                pps_in = 1;
                @(posedge clk_sys);
                pps_in = 0;
                $display("Second tick: TAI = %0d", tm_tai);
            end
        end
        
        $display("WR Timing Testbench Complete");
        $finish;
    end
    
    // Monitor timing counters
    always @(posedge clk_sys) begin
        if (cntr_valid && (cntr_nsec % 1000000 == 0)) begin // Every ms
            $display("Time: UTC=%0d, nsec=%0d", cntr_utc, cntr_nsec);
        end
    end

endmodule
