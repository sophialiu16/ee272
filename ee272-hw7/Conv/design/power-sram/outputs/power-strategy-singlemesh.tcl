#=========================================================================
# power-strategy-singlemesh.tcl
#=========================================================================
# This script implements a single power mesh on the upper metal layers.
# Note that M2 is expected to be vertical, and the lower metal layer of
# the power mesh is expected to be horizontal.
#
# Author : Christopher Torng
# Date   : January 20, 2019

#-------------------------------------------------------------------------
# Stripes over SRAM
#-------------------------------------------------------------------------

#deselectAll
#selectInst sram
#setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer metal8 -stacked_via_bottom_layer metal3 -via_using_exact_crossover_size false -split_vias false -orthogonal_only false -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
#addStripe -nets {VDD VSS} -layer metal3 -direction horizontal -width pin_width -over_pins 1 -pin_layer metal3 -all_blocks 1 -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit metal8 -padcore_ring_bottom_layer_limit metal3 -block_ring_top_layer_limit metal8 -block_ring_bottom_layer_limit metal3 -use_wire_group 0 -snap_wire_center_to_grid None
#deselectAll

#-------------------------------------------------------------------------
# Shorter names from the ADK
#-------------------------------------------------------------------------

set pmesh_bot $ADK_POWER_MESH_BOT_LAYER
set pmesh_top $ADK_POWER_MESH_TOP_LAYER

#-------------------------------------------------------------------------
# Power ring
#-------------------------------------------------------------------------

addRing -nets {VDD VSS} -type core_rings -follow core   \
        -layer [list top  $pmesh_top bottom $pmesh_top  \
                     left $pmesh_bot right  $pmesh_bot] \
        -width $savedvars(p_ring_width)                 \
        -spacing $savedvars(p_ring_spacing)             \
        -offset $savedvars(p_ring_spacing)              \
        -extend_corner {tl tr bl br lt lb rt rb}

#-------------------------------------------------------------------------
# Power mesh bottom settings (vertical)
#-------------------------------------------------------------------------
# - pmesh_bot_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_bot_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_bot_str_intraset_spacing : Space between VSS/VDD, choosing
#                                    constant pitch across VSS/VDD stripes
# - pmesh_bot_str_interset_pitch   : Pitch between same-signal stripes

# Get M1 min width and signal routing pitch as defined in the LEF

set M1_min_width    [dbGet [dbGetLayerByZ 1].minWidth]
set M1_route_pitchX [dbGet [dbGetLayerByZ 1].pitchX]

# Bottom stripe params

set pmesh_bot_str_width [expr  8 *  3 * $M1_min_width   ]
set pmesh_bot_str_pitch [expr 10 * 10 * $M1_route_pitchX]

set pmesh_bot_str_intraset_spacing [expr ($pmesh_bot_str_pitch - $pmesh_bot_str_width)/4]
set pmesh_bot_str_interset_pitch   [expr 1*$pmesh_bot_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer 1 \
                 -stacked_via_top_layer    $pmesh_top

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

addStripe -nets {VSS VDD} -layer $pmesh_bot -direction vertical \
    -width $pmesh_bot_str_width                                 \
    -spacing $pmesh_bot_str_intraset_spacing                    \
    -set_to_set_distance $pmesh_bot_str_interset_pitch          \
    -max_same_layer_jog_length $pmesh_bot_str_pitch             \
    -padcore_ring_bottom_layer_limit $pmesh_bot                 \
    -padcore_ring_top_layer_limit $pmesh_top                    \
    -start [expr $pmesh_bot_str_pitch]

#-------------------------------------------------------------------------
# Power mesh top settings (horizontal)
#-------------------------------------------------------------------------
# - pmesh_top_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_top_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_top_str_intraset_spacing : Space between VSS/VDD, choosing
#                                    constant pitch across VSS/VDD stripes
# - pmesh_top_str_interset_pitch   : Pitch between same-signal stripes

set pmesh_top_str_width [expr  8 *  3 * $M1_min_width   ]
set pmesh_top_str_pitch [expr 10 * 10 * $M1_route_pitchX]

set pmesh_top_str_intraset_spacing [expr ($pmesh_top_str_pitch - $pmesh_top_str_width)/4]
set pmesh_top_str_interset_pitch   [expr 1*$pmesh_top_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer $pmesh_bot \
                 -stacked_via_top_layer    $pmesh_top

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

addStripe -nets {VSS VDD} -layer $pmesh_top -direction horizontal \
    -width $pmesh_top_str_width                                   \
    -spacing $pmesh_top_str_intraset_spacing                      \
    -set_to_set_distance $pmesh_top_str_interset_pitch            \
    -max_same_layer_jog_length $pmesh_top_str_pitch               \
    -padcore_ring_bottom_layer_limit $pmesh_bot                   \
    -padcore_ring_top_layer_limit $pmesh_top                      \
    -start [expr $pmesh_top_str_pitch]

set all_macros [dbGet [dbGet -p2 top.insts.cell.baseClass block].name]
foreach macro $all_macros {
    selectInst $macro
    addRing -nets {VDD VSS} -type block_rings \
        -around selected \
        -layer {top metal7 bottom metal7 left metal6 right metal6} \
        -width 1 -spacing 1 -offset 0.5
    deselectAll

    sroute -connect blockPin \
       -allowJogging 1 \
       -allowLayerChange 1 \
       -blockPin useLef \
       -blockPinTarget nearestTarget \
       -crossoverViaLayerRange "metal4 metal7" \
       -inst $macro \
       -layerChangeRange "metal4 metal7" \
       -nets {VDD VSS} \
       -noBlockPinOneAmongOverlappedPins \
       -targetViaLayerRange "metal4 metal7" \
       -verbose
}

deselectAll
selectVia 46.7600 19.8400 48.4400 21.6700 8 VDD
deleteSelectedFromFPlan
selectVia 46.7600 20.6600 48.4400 21.6700 7 VDD
deleteSelectedFromFPlan
selectVia 46.7600 21.4000 48.4400 21.5400 6 VDD
deleteSelectedFromFPlan
selectVia 47.6500 21.4000 48.0500 21.5400 5 VDD
deleteSelectedFromFPlan
selectVia 47.6500 21.4000 48.0500 21.5400 4 VDD
deleteSelectedFromFPlan
selectVia 47.4500 21.4050 48.4400 21.5350 3 VDD
deleteSelectedFromFPlan
selectVia 47.4500 21.4050 48.4400 21.5350 2 VDD
deleteSelectedFromFPlan
selectVia 46.7600 20.7900 48.4400 20.9300 6 VDD
deleteSelectedFromFPlan
selectVia 47.6500 20.7900 48.0500 20.9300 5 VDD
deleteSelectedFromFPlan
selectVia 46.7600 19.8400 48.4400 20.2400 7 VDD
deleteSelectedFromFPlan
selectVia 46.7600 19.9700 48.4400 20.1100 6 VDD
deleteSelectedFromFPlan
selectVia 47.6500 19.9700 48.0500 20.1100 5 VDD
deleteSelectedFromFPlan
deselectAll
