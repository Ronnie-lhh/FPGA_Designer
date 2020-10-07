transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/source_code {D:/Project/Verilog/M_Player/source_code/CNT138T.v}
vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/source_code {D:/Project/Verilog/M_Player/source_code/F_CODE.v}
vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/source_code {D:/Project/Verilog/M_Player/source_code/SPKER.v}
vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/ip_core/rom {D:/Project/Verilog/M_Player/ip_core/rom/rom_controller.v}
vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/source_code {D:/Project/Verilog/M_Player/source_code/test.v}

vlog -vlog01compat -work work +incdir+D:/Project/Verilog/M_Player/source_code {D:/Project/Verilog/M_Player/source_code/test_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_tb

add wave *
view structure
view signals
run -all
