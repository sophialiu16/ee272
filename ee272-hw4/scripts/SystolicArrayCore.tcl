set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {SystolicArrayCore<IDTYPE, WDTYPE, ODTYPE, 16, 16>}
}

go compile

source scripts/set_libraries.tcl

solution library add {[CCORE] ProcessingElement<IDTYPE,ODTYPE>.v1}

go libraries
directive set -CLOCKS $clocks
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/ProcessingElement<IDTYPE,ODTYPE> -MAP_TO_MODULE {[CCORE] ProcessingElement<IDTYPE,ODTYPE>.v1}

directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16> -REGISTER_THRESHOLD 4096

go assembly

directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run -DESIGN_GOAL Latency
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run -CLOCK_OVERHEAD 0.000000

# -------------------------------
# Your code starts here
# Make sure that the accumulation buffer has the appropriate word width 
# -------------------------------
return -code error "Remove this once implemented."
# -------------------------------
# Your code ends here
# -------------------------------


# -------------------------------
# Your code starts here
# Map the input register, partial sum register, and weight register to registers and not memories
# -------------------------------
return -code error "Remove this once implemented."
# -------------------------------
# Your code ends here
# -------------------------------

go architect

# -------------------------------
# Your code starts here
# If you try to schedule with an initiation interval of 1, you might run into a dependency error involving the accumulation buffer
# To solve this, you need to use 'ignore_memory_precedences'
# -------------------------------
return -code error "Remove this once implemented."
# -------------------------------
# Your code ends here
# -------------------------------

go allocate
go extract
