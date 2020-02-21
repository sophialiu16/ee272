#=========================================================================
# mflowgen-run.sh
#=========================================================================
# Generator : /afs/ir.stanford.edu/class/ee272/mflowgen/mflowgen/BuildOrchestrator.py

# Pre

rm -f .time_end
date +%Y-%m%d-%H%M-%S > .time_start
export construct_path=/afs/ir.stanford.edu/users/s/k/skavya/ee272/ee272-hw5/GcdUnit/design/construct.py
export clock_period=2.0
export design_name=GcdUnit
export adk=freepdk-45nm
export adk_view=view-standard

# Commands

(
echo "Design name      -- GcdUnit"
echo "Clock period     -- 2.0"
echo "ADK              -- freepdk-45nm"
echo "ADK view         -- view-standard"
echo
echo "Constructed from -- /afs/ir.stanford.edu/users/s/k/skavya/ee272/ee272-hw5/GcdUnit/design/construct.py"
echo
)

# Post

date +%Y-%m%d-%H%M-%S > .time_end

