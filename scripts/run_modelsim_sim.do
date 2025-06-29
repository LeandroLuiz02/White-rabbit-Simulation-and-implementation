# run_modelsim_sim.do
# Simple ModelSim simulation script

# Create work library
vlib work

# Compile source files
vlog testbenches/*.sv

# Start simulation
vsim work.wr_standalone_basic_tb

# Add signals to waveform
add wave -r /*

# Run simulation
run -all

# Save waveform
write format wave -window .main_pane.wave.interior.cs.body.pw.wf wr_simulation.wlf

quit
