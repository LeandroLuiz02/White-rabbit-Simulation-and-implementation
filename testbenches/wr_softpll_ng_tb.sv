// wr_softpll_ng_tb.sv
// White Rabbit Software PLL Next Generation Testbench

`timescale 1ns/1ps

module wr_softpll_ng_tb;

    logic clk_sys = 0;
    logic clk_ref = 0;
    logic rst_n = 0;
    logic [15:0] dac_dmtd_data;
    logic dac_dmtd_load;
    logic [15:0] dac_out_data;
    logic dac_out_load;
    logic pps_csync;
    
    always #4ns clk_sys = ~clk_sys;   // 125 MHz
    always #3.2ns clk_ref = ~clk_ref; // 156.25 MHz
    
    initial begin
        rst_n = 0;
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR SoftPLL NG Testbench Starting...");
        
        // Let PLL settle
        #10000ns;
        
        $display("WR SoftPLL NG Testbench Complete");
        $finish;
    end
    
    // Monitor DAC outputs
    always @(posedge dac_dmtd_load) begin
        $display("DMTD DAC update: %h at time %0t", dac_dmtd_data, $time);
    end
    
    always @(posedge dac_out_load) begin
        $display("Output DAC update: %h at time %0t", dac_out_data, $time);
    end

endmodule
