remove_design -all
set designer "name"
set power_preserve_rtl_hier_names "true"
set design_path "file"
set out_path "report"

set src_path $design_path
set output_path $design_path
define_design_lib work -path "work"


set link_library    /NangateOpenCellLibrary.db
set target_library  /NangateOpenCellLibrary.db


set src_files [list $src_path]
set topname "module"

analyze -library WORK -format verilog $src_files

elaborate $topname -lib work -update
current_design $topname
#create_clock -period 1000 {"clk"}
link
uniquify
check_design

set my_input_delay_ns 0
set my_output_delay_ns 0

set auto_wire_load_selection "true"

#compile -area_effort high
#set_max_delay 600 -from [ get_ports -filter {@port_direction == in}] -to [ get_ports -filter {@port_direction == out}] 


compile_ultra 
check_design

set sdfout_time_scale 0.001000

#rtl2saif -output "$out_path/file.saif" -design $topname
write -hierarchy -output "$out_path/file.ddc"
write -hier -format verilog -out "$out_path/file.v"
write_sdf -version 2.1 "$out_path/file.sdf"

report_timing -nworst 1  > "$out_path/timing.report"
report_area -hier > "$out_path/area.report"
report_constraint -all_violators > "$out_path/constraint.report"
report_power > "$out_path/power.report"
report_design > "$out_path/design.report"
report_cell > "$out_path/cell.report"
report_reference > "$out_path/ref.report"
exit
