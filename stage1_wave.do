onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/DUT/MEM/addr_width
add wave -noupdate /lab7_check_tb/DUT/MEM/clk
add wave -noupdate /lab7_check_tb/DUT/MEM/data_width
add wave -noupdate /lab7_check_tb/DUT/MEM/din
add wave -noupdate /lab7_check_tb/DUT/MEM/dout
add wave -noupdate /lab7_check_tb/DUT/MEM/filename
add wave -noupdate /lab7_check_tb/DUT/MEM/mem
add wave -noupdate /lab7_check_tb/DUT/MEM/read_address
add wave -noupdate /lab7_check_tb/DUT/MEM/write
add wave -noupdate /lab7_check_tb/DUT/MEM/write_address
add wave -noupdate /lab7_check_tb/DUT/CPU/N
add wave -noupdate /lab7_check_tb/DUT/CPU/PC
add wave -noupdate /lab7_check_tb/DUT/CPU/Salu
add wave -noupdate /lab7_check_tb/DUT/CPU/Scmp
add wave -noupdate /lab7_check_tb/DUT/CPU/Sdecode
add wave -noupdate /lab7_check_tb/DUT/CPU/SgetA
add wave -noupdate /lab7_check_tb/DUT/CPU/SgetB
add wave -noupdate /lab7_check_tb/DUT/CPU/Shalt
add wave -noupdate /lab7_check_tb/DUT/CPU/Sif1
add wave -noupdate /lab7_check_tb/DUT/CPU/Sif2
add wave -noupdate /lab7_check_tb/DUT/CPU/Sint1
add wave -noupdate /lab7_check_tb/DUT/CPU/Sint2
add wave -noupdate /lab7_check_tb/DUT/CPU/Sldr
add wave -noupdate /lab7_check_tb/DUT/CPU/Sldr_mem
add wave -noupdate /lab7_check_tb/DUT/CPU/Sloadout
add wave -noupdate /lab7_check_tb/DUT/CPU/Srewrite
add wave -noupdate /lab7_check_tb/DUT/CPU/Srewrite_mem
add wave -noupdate /lab7_check_tb/DUT/CPU/Srst
add wave -noupdate /lab7_check_tb/DUT/CPU/Sshift
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr_loadout
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr_rd
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr_rd_alu
add wave -noupdate /lab7_check_tb/DUT/CPU/Sstr_write
add wave -noupdate /lab7_check_tb/DUT/CPU/SupdatePC
add wave -noupdate /lab7_check_tb/DUT/CPU/Swrite
add wave -noupdate /lab7_check_tb/DUT/CPU/V
add wave -noupdate /lab7_check_tb/DUT/CPU/Z
add wave -noupdate /lab7_check_tb/DUT/CPU/Z_out
add wave -noupdate /lab7_check_tb/DUT/CPU/addr_sel
add wave -noupdate /lab7_check_tb/DUT/CPU/asel
add wave -noupdate /lab7_check_tb/DUT/CPU/bsel
add wave -noupdate /lab7_check_tb/DUT/CPU/clk
add wave -noupdate /lab7_check_tb/DUT/CPU/data_addr_out
add wave -noupdate /lab7_check_tb/DUT/CPU/decoder_in
add wave -noupdate /lab7_check_tb/DUT/CPU/in
add wave -noupdate /lab7_check_tb/DUT/CPU/load_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/load_ir
add wave -noupdate /lab7_check_tb/DUT/CPU/load_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/loada
add wave -noupdate /lab7_check_tb/DUT/CPU/loadb
add wave -noupdate /lab7_check_tb/DUT/CPU/loadc
add wave -noupdate /lab7_check_tb/DUT/CPU/loads
add wave -noupdate /lab7_check_tb/DUT/CPU/mem_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/mem_cmd
add wave -noupdate /lab7_check_tb/DUT/CPU/next_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/nsel
add wave -noupdate /lab7_check_tb/DUT/CPU/op
add wave -noupdate /lab7_check_tb/DUT/CPU/opcode
add wave -noupdate /lab7_check_tb/DUT/CPU/out
add wave -noupdate /lab7_check_tb/DUT/CPU/readnum
add wave -noupdate /lab7_check_tb/DUT/CPU/reset
add wave -noupdate /lab7_check_tb/DUT/CPU/reset_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/shift
add wave -noupdate /lab7_check_tb/DUT/CPU/state
add wave -noupdate /lab7_check_tb/DUT/CPU/sximm5
add wave -noupdate /lab7_check_tb/DUT/CPU/sximm8
add wave -noupdate /lab7_check_tb/DUT/CPU/vsel
add wave -noupdate /lab7_check_tb/DUT/CPU/write
add wave -noupdate -radix binary /lab7_check_tb/DUT/CPU/writenum
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate -radix hexadecimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate -radix decimal /lab7_check_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/clk
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/data_in
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/data_out
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/readnum
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/readnum_out
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/write
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/writenum
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/writenum_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {492 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
configure wave -valuecolwidth 95
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {270 ps} {623 ps}
