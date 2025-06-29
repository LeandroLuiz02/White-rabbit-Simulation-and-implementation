# run_all_modelsim_sims.do
# Run all ModelSim simulations

# Create work library
vlib work

# List of testbenches
set testbenches [list "wr_master_slave_sync_tb" "wr_minimal_two_node_tb" "wr_standalone_basic_tb"]

# Compile all source files
vlog testbenches/*.sv

foreach tb $testbenches {
    echo "Running simulation for: $tb"
    
    # Start simulation
    vsim work.$tb
    
    # Add signals to waveform
    add wave -r /*
    
    # Run simulation
    run -all
    
    # Save waveform
    write format wave -window .main_pane.wave.interior.cs.body.pw.wf ${tb}_simulation.wlf
    
    # End simulation
    quit -sim
    
    echo "Completed simulation for: $tb"
}

quit
