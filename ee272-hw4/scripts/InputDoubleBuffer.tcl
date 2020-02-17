set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {InputDoubleBuffer<4096, 16, 16>} 
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
directive set /InputDoubleBuffer<4096,16,16>/weights_in -WORD_WIDTH 6
directive set /InputDoubleBuffer<4096,16,16>/weights_in -BASE_ADDR 0
directive set /InputDoubleBuffer<4096,16,16>/weights_in -BASE_BIT 0

directive set /InputDoubleBuffer<4096,16,16>/weights_out -WORD_WIDTH 144
directive set /InputDoubleBuffer<4096,16,16>/weights_out -BASE_ADDR 0
directive set /InputDoubleBuffer<4096,16,16>/weights_out -BASE_BIT 6
# -------------------------------
# Your code ends here
# -------------------------------

go architect

go allocate
go extract
