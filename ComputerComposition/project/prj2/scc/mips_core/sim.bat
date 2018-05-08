set testbentch_module=%1
set testbentch_file="%testbentch_module%"

iverilog -o "%testbentch_module%.vvp" "%testbentch_file%" "%2" "%3" "%4" "%5" "%6" "%7" "%8" "%9"
vvp "%testbentch_module%.vvp"

gtkwave out.vcd