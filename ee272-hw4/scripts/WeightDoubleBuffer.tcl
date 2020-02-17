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
directive set /WeightDoubleBuffer<4096,16,16>/mem -WORD_WIDTH 16
directive set /WeightDoubleBuffer<4096,16,16>/WeightDoubleBufferWriter<4096,16,16>/run/for:for:for:for:tmp.data.value -WORD_WIDTH 16
directive set /WeightDoubleBuffer<4096,16,16>/WeightDoubleBufferReader<4096,16,16>/run/for:for:tmp.data.value -WORD_WIDTH 16
#directive set /WeightDoubleBuffer<4096,16,16>/WeightDoubleBufferReader<4096,16,16>/run/for:for:dout_.value -WORD_WIDTH 16

directive set /WeightDoubleBuffer<4096,16,16>/mem:cns -STAGE_REPLICATION 2
directive set /WeightDoubleBuffer<4096,16,16>/WeightDoubleBufferWriter<4096,16,16>/dout:rsc -STAGE_REPLICATION 2
directive set /WeightDoubleBuffer<4096,16,16>/WeightDoubleBufferReader<4096,16,16>/din:rsc -STAGE_REPLICATION 2

# -------------------------------
# Your code ends here
# -------------------------------

go architect

go allocate
go extract
