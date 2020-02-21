#=========================================================================
# mflowgen-debug.sh
#=========================================================================
# Generator : /afs/ir.stanford.edu/class/ee272/mflowgen/mflowgen/BuildOrchestrator.py

# Pre

export flatten_effort=0
export clock_period=2.0
export design_name=GcdUnit
export topographical=True
export nthreads=16

# Debug

export DC_EXIT_AFTER_SETUP=1
ln -sf results/*.mapped.ddc debug.ddc
design_vision-xg -topographical -x "source dc.tcl; read_ddc debug.ddc"

