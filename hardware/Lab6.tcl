# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Set the project name
set _xil_proj_name_ "proj_"
#default project name appended with commitID
set commitID [exec git rev-parse HEAD]
append _xil_proj_name_ [string range $commitID 0 5]

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/builds/${_xil_proj_name_}"]"

#Create Project
file mkdir $orig_proj_dir
create_project ${_xil_proj_name_} $orig_proj_dir -part xc7z010clg400-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part_repo_paths" -value "[file normalize "$origin_dir/../../.Xilinx/Vivado/2022.1/xhub/board_store/xilinx_board_store"]" -objects $obj
set_property -name "board_part" -value "digilentinc.com:zybo-z7-10:part0:1.1" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "zybo-z7-10" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "3" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "3" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "3" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "3" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "3" -objects $obj
set_property -name "webtalk.xcelium_export_sim" -value "3" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "3" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
if { $obj != {} } {
   set_property "ip_repo_paths" "[file normalize "$origin_dir/ip_repo/gpio_ctrl_ip_1.0"]" $obj

   # Rebuild user ip_repo's index before adding any source files
   update_ip_catalog -rebuild
}

# create_bd_design design_1
source $origin_dir/bd/design_1.tcl
# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# Add local files from the original project (-no_copy_sources specified)
set files [list \
[file normalize "${origin_dir}/builds/$_xil_proj_name_/$_xil_proj_name_.srcs/sources_1/bd/design_1/design_1.bd" ]\
]
set added_files [add_files -fileset sources_1 $files]

#call make_wrapper to create wrapper files
if { [get_property IS_LOCKED [ get_files -norecurse design_1.bd] ] == 1  } {
 import_files -fileset sources_1 [file normalize "${origin_dir}/builds/$_xil_proj_name_/$_xil_proj_name_.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v" ]
} else {
 set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse design_1.bd] -top]
 add_files -norecurse -fileset sources_1 $wrapper_path
}

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "design_1/design_1.bd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "registered_with_manager" -value "1" -objects $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "design_1_wrapper" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constr/zybo-z7-master.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/constr/zybo-z7-master.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "[file normalize "$origin_dir/constr/zybo-z7-master.xdc"]" -objects $obj
set_property -name "target_ucf" -value "[file normalize "$origin_dir/constr/zybo-z7-master.xdc"]" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "design_1_wrapper" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

