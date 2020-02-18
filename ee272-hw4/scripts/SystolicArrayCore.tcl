set blockname [file rootname [file tail [info script] ]]

source scripts/common.tcl

directive set -DESIGN_HIERARCHY { 
    {SystolicArrayCore<IDTYPE, WDTYPE, ODTYPE, 16, 16>}
}

go compile

source scripts/set_libraries.tcl

solution library add {[CCORE] ProcessingElement<IDTYPE,ODTYPE,WDTYPE>.v1}

go libraries
directive set -CLOCKS $clocks
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/ProcessingElement<IDTYPE,ODTYPE,WDTYPE> -MAP_TO_MODULE {[CCORE] ProcessingElement<IDTYPE,ODTYPE,WDTYPE>.v1}

directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16> -REGISTER_THRESHOLD 4096

go assembly

directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run -DESIGN_GOAL Latency
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run -CLOCK_OVERHEAD 0.000000

# -------------------------------
# Your code starts here
# Make sure that the accumulation buffer has the appropriate word width 
# -------------------------------
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/accum_buffer -WORD_WIDTH 32 

# -------------------------------
# Your code ends here
# -------------------------------


# -------------------------------
# Your code starts here
# Map the input register, partial sum register, and weight register to registers and not memories
# -------------------------------
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/pe_ifmap_in:rsc -MAP_TO_MODULE {[Register]}
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/pe_ifmap_out:rsc -MAP_TO_MODULE {[Register]}
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/pe_weight_in:rsc -MAP_TO_MODULE {[Register]}
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/pe_psum_in:rsc -MAP_TO_MODULE {[Register]}
directive set /SystolicArrayCore<IDTYPE,WDTYPE,ODTYPE,16,16>/run/pe_psum_out:rsc -MAP_TO_MODULE {[Register]}

# -------------------------------
# Your code ends here
# -------------------------------

go architect

# -------------------------------
# Your code starts here
# If you try to schedule with an initiation interval of 1, you might run into a dependency error involving the accumulation buffer
# To solve this, you need to use 'ignore_memory_precedences'
# -------------------------------


# Error: $PROJECT_HOME/src/SystolicArrayCore.h(275):   MEMORYREAD "for:if#4:else:for:read_mem(accum_buffer:rsc.@)" SystolicArrayCore.h(275,17,33) (BASIC-25)
# # Error: $PROJECT_HOME/src/SystolicArrayCore.h(275):   MEMORYWRITE "for:if#4:else:for:write_mem(accum_buffer:rsc.@)" SystolicArrayCore.h(275,17,33) (BASIC-25)

ignore_memory_precedences -from for:if#4:else:for:write_mem(accum_buffer:rsc.@) -to for:else#2:if:for:read_mem(accum_buffer:rsc.@)

ignore_memory_precedences -from for:if#4:else:for:write_mem(accum_buffer:rsc.@) -to for:if#4:else:for:read_mem(accum_buffer:rsc.@)

#ignore_memory_precedences -from for:if#4:else:for:write_mem(accum_buffer:rsc.@) -to for:if#4:else:for:read_mem(accum_buffer:rsc.@)

# Error: $PROJECT_HOME/src/SystolicArrayCore.h(264):   MEMORYREAD "for:if#4:else:for:read_mem(accum_buffer:rsc.@)" SystolicArrayCore.h(264,17,33) (BASIC-25)
# # Error: $PROJECT_HOME/src/SystolicArrayCore.h(264):   MEMORYWRITE "for:if#4:else:for:write_mem(accum_buffer:rsc.@)" SystolicArrayCore.h(264,17,33) (BASIC-25)

# -------------------------------
# Your code ends here
# -------------------------------

go allocate
go extract
