// wr_nic_tb.sv
// White Rabbit NIC Testbench

`timescale 1ns/1ps

module wr_nic_tb;

    logic clk_125m = 0;
    logic rst_n = 0;
    logic [31:0] wb_dat_i, wb_dat_o;
    logic [31:0] wb_adr_i;
    logic wb_we_i, wb_cyc_i, wb_stb_i;
    logic wb_ack_o;
    
    always #4ns clk_125m = ~clk_125m;
    
    initial begin
        rst_n = 0;
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;
        wb_adr_i = 0;
        wb_dat_i = 0;
        
        #100ns rst_n = 1;
        #50ns;
        
        $display("WR NIC Testbench Starting...");
        
        // Simple wishbone write/read test
        @(posedge clk_125m);
        wb_cyc_i = 1;
        wb_stb_i = 1;
        wb_we_i = 1;
        wb_adr_i = 32'h1000;
        wb_dat_i = 32'hDEADBEEF;
        
        @(posedge clk_125m);
        while (!wb_ack_o) @(posedge clk_125m);
        
        wb_cyc_i = 0;
        wb_stb_i = 0;
        
        #1000ns;
        $display("WR NIC Testbench Complete");
        $finish;
    end

endmodule
