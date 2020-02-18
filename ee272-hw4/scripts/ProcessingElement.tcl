set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {ProcessingElement<IDTYPE, ODTYPE, WDTYPE>} 
}

go compile

source scripts/set_libraries.tcl

go libraries

directive set -CLOCKS $clocks

go assembly

directive set /ProcessingElement<IDTYPE,ODTYPE,WDTYPE>/run -DESIGN_GOAL Latency
directive set /ProcessingElement<IDTYPE,ODTYPE,WDTYPE>/run -CLOCK_OVERHEAD 0.000000

go extract
