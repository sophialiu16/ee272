#=========================================================================
# floorplan.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

# Set the floorplan to target a reasonable placement density with a good
# aspect ratio (height:width). An aspect ratio of 2.0 here will make a
# rectangular chip with a height that is twice the width.

set core_aspect_ratio   1.00; # Aspect ratio 1.0 for a square chip
set core_density_target 0.50; # Placement density of 70% is reasonable

# Make room in the floorplan for the core power ring

set pwr_net_list {VDD VSS}; # List of power nets in the core power ring

set M1_min_width   [dbGet [dbGetLayerByZ 1].minWidth]
set M1_min_spacing [dbGet [dbGetLayerByZ 1].minSpacing]

set savedvars(p_ring_width)   [expr 48 * $M1_min_width];   # Arbitrary!
set savedvars(p_ring_spacing) [expr 24 * $M1_min_spacing]; # Arbitrary!

# Core bounding box margins

set core_margin_t [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_b [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_r [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]
set core_margin_l [expr ([llength $pwr_net_list] * ($savedvars(p_ring_width) + $savedvars(p_ring_spacing))) + $savedvars(p_ring_spacing)]

#-------------------------------------------------------------------------
# Floorplan
#-------------------------------------------------------------------------

# Calling floorPlan with the "-r" flag sizes the floorplan according to
# the core aspect ratio and a density target (70% is a reasonable
# density).
#

floorPlan -r $core_aspect_ratio $core_density_target \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t

setFlipping s

# Use automatic floorplan synthesis to pack macros (e.g., SRAMs) together

planDesign

# not sure where this goes
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp 659.681 310.593 1053.831 751.6705
flipOrRotateObject -rotate R90
flipOrRotateObject -rotate R90
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp 1043.4945 20.5005 1437.6445 461.578
deselectAll
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 1043.4965 475.0955 1437.6465 916.173
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 1036.803 470.632 1430.953 911.7095
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 1032.3395 484.0215 1426.4895 925.099
flipOrRotateObject -rotate R90
flipOrRotateObject -rotate R90
deselectAll
selectInst weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp_1
setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp_1 22.8125 937.5525 416.9625 1378.63

setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp_1 51.8215 995.571 492.899 1389.721
deselectAll
selectInst weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp
setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp 83.0625 378.079 477.2125 819.1565

setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp 60.7475 436.0985 501.825 830.2485
deselectAll
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp 1025.643 29.426 1419.793 470.5035
deselectAll
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 1027.877 499.6425 1422.027 940.72


selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 978.7785 501.8745 1419.856 896.0245
flipOrRotateObject -rotate R90
deselectAll
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp 978.7755 33.8885 1419.853 428.0385
flipOrRotateObject -rotate R90
deselectAll
selectInst systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp
setObjFPlanBox Instance systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp 1079.677 593.4105 1238.487 1417.948
flipOrRotateObject -rotate R270
setObjFPlanBox Instance systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp 578.1855 1252.4385 1402.723 1411.2485
setObjFPlanBox Instance systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp 607.0665 1268.191 1431.604 1427.001


selectInst weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp_1
flipOrRotateObject -rotate R90
setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp_1 49.1975 906.2975 443.3475 1347.375
deselectAll
selectInst weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp
setObjFPlanBox Instance weightDoubleBuffer/WeightDoubleBuffer_384_16_16_struct_inst/mem_cns_comp 63.3735 312.6935 504.451 706.8435
flipOrRotateObject -rotate R90
deselectAll
selectInst inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1
setObjFPlanBox Instance inputDoubleBuffer/InputDoubleBuffer_512_16_16_struct_inst/mem_cns_comp_1 970.9005 557.013 1365.0505 998.0905


selectInst systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp
flipOrRotateObject -rotate R90
flipOrRotateObject -rotate R90
flipOrRotateObject -rotate R90
setObjFPlanBox Instance systolicArray/systolicArrayCore/SystolicArrayCore_IDTYPE_WDTYPE_ODTYPE_16_16_struct_inst/accumulation_buffer_rsc_comp 584.7505 1230.25 1409.288 1389.06

