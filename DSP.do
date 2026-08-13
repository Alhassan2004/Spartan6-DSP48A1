vlib work

vlog Reg_Mux.v DSP.v DSP_TB.v

vsim -voptargs="+acc" work.DSP48A1_tb

add wave -group "Inputs" /DSP48A1_tb/CLK
add wave -group "Inputs" /DSP48A1_tb/RST*
add wave -group "Inputs" /DSP48A1_tb/CE*
add wave -group "Inputs" -radix binary /DSP48A1_tb/OPMODE
add wave -group "Inputs" -radix hex /DSP48A1_tb/A
add wave -group "Inputs" -radix hex /DSP48A1_tb/B
add wave -group "Inputs" -radix hex /DSP48A1_tb/C
add wave -group "Inputs" -radix hex /DSP48A1_tb/D
add wave -group "Inputs" -radix hex /DSP48A1_tb/BCIN
add wave -group "Inputs" -radix hex /DSP48A1_tb/PCIN
add wave -group "Inputs" /DSP48A1_tb/CARRYIN

add wave -group "Outputs" -radix hex /DSP48A1_tb/P
add wave -group "Outputs" -radix hex /DSP48A1_tb/PCOUT
add wave -group "Outputs" -radix hex /DSP48A1_tb/M
add wave -group "Outputs" -radix hex /DSP48A1_tb/BCOUT
add wave -group "Outputs" /DSP48A1_tb/CARRYOUT
add wave -group "Outputs" /DSP48A1_tb/CARRYOUTF

run -all

wave zoom full