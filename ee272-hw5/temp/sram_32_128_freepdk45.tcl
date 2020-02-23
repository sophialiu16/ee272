flow package require MemGen
flow run /MemGen/MemoryGenerator_BuildLib {
VENDOR           *
RTLTOOL          DesignCompiler
TECHNOLOGY       *
LIBRARY          sram_32_128_freepdk45_TT_1p1V_25C_lib
MODULE           sram_32_128_freepdk45
OUTPUT_DIR       /home/users/skavya/ee272/ee272-hw5/temp
FILES {
  { FILENAME /home/users/skavya/ee272/ee272-hw5/temp/sram_32_128_freepdk45.v               FILETYPE Verilog MODELTYPE generic   PARSE 0 PATHTYPE copy STATICFILE 1 VHDL_LIB_MAPS work }
  { FILENAME /home/users/skavya/ee272/ee272-hw5/temp/sram_32_128_freepdk45_TT_1p1V_25C.lib FILETYPE Liberty MODELTYPE synthesis PARSE 1 PATHTYPE copy STATICFILE 1 VHDL_LIB_MAPS work }
}
VHDLARRAYPATH    {}
WRITEDELAY       0.1
INITDELAY        1
READDELAY        0.0
VERILOGARRAYPATH {}
INPUTDELAY       0.01
TIMEUNIT         1ns
WIDTH            32.0
AREA             14579.75895
RDWRRESOLUTION   UNKNOWN
WRITELATENCY     1
READLATENCY      1
DEPTH            128.0
PARAMETERS {
}
PORTS {
  { NAME port_0 MODE ReadWrite }
}
PINMAPS {
  { PHYPIN din0  LOGPIN DATA_IN      DIRECTION in  WIDTH 32.0 PHASE {} DEFAULT {} PORTS port_0 }
  { PHYPIN dout0 LOGPIN DATA_OUT     DIRECTION out WIDTH 32.0 PHASE {} DEFAULT {} PORTS port_0 }
  { PHYPIN addr0 LOGPIN ADDRESS      DIRECTION in  WIDTH 7.0  PHASE {} DEFAULT {} PORTS port_0 }
  { PHYPIN csb0  LOGPIN CHIP_SELECT  DIRECTION in  WIDTH 1.0  PHASE 0  DEFAULT {} PORTS {}     }
  { PHYPIN web0  LOGPIN WRITE_ENABLE DIRECTION in  WIDTH 1.0  PHASE 0  DEFAULT {} PORTS port_0 }
  { PHYPIN clk0  LOGPIN CLOCK        DIRECTION in  WIDTH 1.0  PHASE 1  DEFAULT {} PORTS port_0 }
}

}
