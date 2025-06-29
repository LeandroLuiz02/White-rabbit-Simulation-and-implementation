// wr_pps_gen_tb.sv
// White Rabbit PPS Generator Testbench

`timescale 1ns/1ps

module wr_pps_gen_tb;

    logic clk_125m = 0;
    logic rst_n = 0;
    logic pps_out;
    logic [63:0] tm_tai;
    logic tm_tai_valid;
    
    always #4ns clk_125m = ~clk_125m;
    
    initial begin
        rst_n = 0;
        tm_tai = 0;
        tm_tai_valid = 0;
        
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR PPS Generator Testbench Starting...");
        
        // Simulate time counter
        tm_tai_valid = 1;
        repeat(1000) begin
            @(posedge clk_125m);
            tm_tai = tm_tai + 8; // 8ns increment
        end
        
        $display("WR PPS Generator Testbench Complete");
        $finish;
    end
    
    // Monitor PPS output
    always @(posedge pps_out) begin
        $display("PPS pulse at time: %0t, TAI: %0d", $time, tm_tai);
    end

endmodule
