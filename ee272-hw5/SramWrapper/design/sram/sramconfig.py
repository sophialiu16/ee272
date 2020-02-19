# Data word size
word_size = 32
# Number of words in the memory
num_words = 128

# Technology to use in $OPENRAM_TECH
tech_name = "freepdk45"
# Process corners to characterize
process_corners = ["TT"]
# Voltage corners to characterize
supply_voltages = [ 3.3 ]
# Temperature corners to characterize
temperatures = [ 25 ]

# Output directory for the results
output_path = "outputs"
# Output file base name
output_name = "sram"
# Helpful if you have multiple SRAMs
#output_name = "sram_{0}_{1}_{2}".format(word_size,num_words,tech_name)

# Disable analytical models for full characterization (WARNING: slow!)
# analytical_delay = False

# To force this to use calibre for DRC/LVS/PEX
drc_name = "calibre"
lvs_name = "calibre"
pex_name = "calibre"
