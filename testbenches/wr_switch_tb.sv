// wr_switch_tb.sv
// White Rabbit Switch Testbench

`timescale 1ns/1ps

module wr_switch_tb;

    logic clk_sys = 0;
    logic rst_n = 0;
    
    // Port interfaces (simplified)
    logic [17:0] wrf_src_dat [0:7];
    logic [1:0]  wrf_src_adr [0:7];
    logic        wrf_src_sel [0:7];
    logic        wrf_src_cyc [0:7];
    logic        wrf_src_stb [0:7];
    logic        wrf_src_we [0:7];
    logic        wrf_src_ack [0:7];
    logic        wrf_src_stall [0:7];
    logic        wrf_src_err [0:7];
    logic        wrf_src_rty [0:7];
    
    always #4ns clk_sys = ~clk_sys;
    
    initial begin
        rst_n = 0;
        
        // Initialize arrays
        for (int i = 0; i < 8; i++) begin
            wrf_src_cyc[i] = 0;
            wrf_src_stb[i] = 0;
            wrf_src_we[i] = 0;
            wrf_src_dat[i] = 0;
            wrf_src_adr[i] = 0;
            wrf_src_sel[i] = 0;
        end
        
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR Switch Testbench Starting...");
        
        // Test frame switching between ports
        repeat(10) begin
            @(posedge clk_sys);
            // Port 0 sends to port 1
            wrf_src_cyc[0] = 1;
            wrf_src_stb[0] = 1;
            wrf_src_we[0] = 1;
            wrf_src_dat[0] = $random;
            wrf_src_adr[0] = 2'b00;
            
            @(posedge clk_sys);
            wrf_src_cyc[0] = 0;
            wrf_src_stb[0] = 0;
        end
        
        #1000ns;
        $display("WR Switch Testbench Complete");
        $finish;
    end

endmodule
