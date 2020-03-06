#=========================================================================
# pin-assignments.tcl
#=========================================================================
# The ports of this design become physical pins along the perimeter of the
# design. The commands below will spread the pins along the left and right
# perimeters of the core area. This will work for most designs, but a
# detail-oriented project should customize or replace this section.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Pin Assignments
#-------------------------------------------------------------------------

# Here pin assignments are done keeping in mind the location of the SRAM pins
# If you update pin assignments below you should rerun the pin-placement step 
# before re-running init step

# addr[0] is lower left, addr[6] is upper left
set pins_left {{addr[0]} clk csb web {addr[1]} {addr[2]} {addr[3]} {addr[4]} {addr[5]} {addr[6]}}

# dout[0] is upper left, dout[31] is upper right
set pins_top []
for {set i 0} {$i < 32} {incr i} {
  lappend pins_top "dout[$i]"
}

# din[31] is lower right, din[0] is lower left
set pins_bottom []
for {set i 31} {$i >= 0} {incr i -1} {
  lappend pins_bottom "din[$i]"
}

# Spread the pins evenly across the left and right sides of the block

set ports_layer M4

editPin -layer $ports_layer -pin $pins_left  -side LEFT  -spreadType SIDE
editPin -layer $ports_layer -pin $pins_bottom -side BOTTOM -spreadType SIDE
editPin -layer $ports_layer -pin $pins_top -side TOP -spreadType SIDE
