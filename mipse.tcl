set search_path [concat "/home/cad/lib/osu_stdcells/lib/tsmc018/lib/" $search_path]
set LIB_MAX_FILE {osu018_stdcells.db  }

set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

read_verilog alu.v
read_verilog rfile.v
read_verilog mipse.v
current_design "mipse"
create_clock -period 9.85 clk 
set_input_delay 2.2 -clock clk [find port "readdata*"]
set_input_delay 2.2 -clock clk [find port "instr*"]
set_output_delay 2.2 -clock clk [find port "pc*"]
set_output_delay 2.2 -clock clk [find port "aluout*"]
set_output_delay 2.2 -clock clk [find port "writedata*"]
set_output_delay 2.2 -clock clk [find port "memwrite"]

set_max_fanout 12 [current_design]

set_max_area 0

compile -map_effort high -area_effort medium

redirect ./log/mipse.max.timing.log { report_timing -delay max -max_paths 3 }
redirect ./log/mipse.power.log { report_power }

write -hier -format verilog -output mipse.vnet

quit
