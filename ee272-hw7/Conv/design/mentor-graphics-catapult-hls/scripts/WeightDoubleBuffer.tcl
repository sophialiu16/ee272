set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {WeightDoubleBuffer<384, 16, 16>} 
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
directive set /WeightDoubleBuffer<384,16,16>/WeightDoubleBufferReader<384,16,16>/din -WORD_WIDTH 128
directive set /WeightDoubleBuffer<384,16,16>/WeightDoubleBufferWriter<384,16,16>/dout -WORD_WIDTH 128
directive set /WeightDoubleBuffer<384,16,16>/mem:cns -STAGE_REPLICATION 2
directive set /WeightDoubleBuffer<384,16,16>/mem -WORD_WIDTH 128
directive set /WeightDoubleBuffer<384,16,16>/WeightDoubleBufferWriter<384,16,16>/run/while:tmp.data.value -WORD_WIDTH 128
directive set /WeightDoubleBuffer<384,16,16>/WeightDoubleBufferReader<384,16,16>/run/while:tmp.data.value -WORD_WIDTH 128
# -------------------------------
# Your code ends here
# -------------------------------

go architect

go allocate
go extract
