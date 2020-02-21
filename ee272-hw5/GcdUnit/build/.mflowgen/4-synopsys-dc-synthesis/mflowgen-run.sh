#=========================================================================
# mflowgen-run.sh
#=========================================================================
# Generator : /afs/ir.stanford.edu/class/ee272/mflowgen/mflowgen/BuildOrchestrator.py

# Pre

rm -f .time_end
date +%Y-%m%d-%H%M-%S > .time_start
export flatten_effort=0
export clock_period=2.0
export design_name=GcdUnit
export topographical=True
export nthreads=16

# Commands

(
bash run.sh
)

# Post

date +%Y-%m%d-%H%M-%S > .time_end

