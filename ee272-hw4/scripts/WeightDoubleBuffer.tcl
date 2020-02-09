set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {WeightDoubleBuffer<4096, 16, 16>} 
}

go compile

source scripts/set_libraries.tcl

go libraries
directive set -CLOCKS $clocks

go assembly

# -------------------------------
# Your code starts here
# Set the correct word widths and the stage replication
# -------------------------------
return -code error "Remove this once implemented."
# -------------------------------
# Your code ends here
# -------------------------------

go architect

go allocate
go extract
