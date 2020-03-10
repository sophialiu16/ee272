#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# DnnAccelerator
#
# Author : Kartik Prabhu
# Date   : February 25, 2020
#

import os
import sys

from mflowgen.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  adk_name = 'freepdk-45nm'
  adk_view = 'view-standard'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'Conv',
    'clock_period'   : 5.0,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
    'topographical'  : True,
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # Custom steps
  sram = Step( this_dir + '/sram' )
  hls = Step( this_dir + '/mentor-graphics-catapult-hls' )
  hls._config['sandbox'] = False

  constraints   = Step( this_dir + '/constraints'       )
  pin_placement = Step( this_dir + '/pin-placement'     )
  floorplan     = Step( this_dir + '/floorplan'         )
  power_sram    = Step( this_dir + '/power-sram'        )
  lvs           = Step( this_dir + '/mentor-calibre-lvs')

  # Default steps

  info         = Step( 'info',                          default=True )
  dc           = Step( 'synopsys-dc-synthesis',         default=True )

  iflow        = Step( 'cadence-innovus-flowsetup',     default=True )
  init         = Step( 'cadence-innovus-init',          default=True )
  power        = Step( 'cadence-innovus-power',         default=True )
  place        = Step( 'cadence-innovus-place',         default=True )
  cts          = Step( 'cadence-innovus-cts',           default=True )
  postcts_hold = Step( 'cadence-innovus-postcts_hold',  default=True )
  route        = Step( 'cadence-innovus-route',         default=True )
  postroute    = Step( 'cadence-innovus-postroute',     default=True )
  signoff      = Step( 'cadence-innovus-signoff',       default=True )
  gdsmerge     = Step( 'mentor-calibre-gdsmerge',       default=True )
  drc          = Step( 'mentor-calibre-drc',            default=True )
  pt_timing    = Step( 'synopsys-pt-timing-signoff',    default=True )
  genlibdb     = Step( 'synopsys-ptpx-genlibdb',        default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info         )
  g.add_step( sram         )
  g.add_step( hls          )
  g.add_step( constraints  )
  g.add_step( dc           )

  g.add_step( iflow        )
  g.add_step( pin_placement)
  g.add_step( floorplan    )
  g.add_step( init         )
  g.add_step( power_sram   )
  g.add_step( power        )
  g.add_step( place        )
  g.add_step( cts          )
  g.add_step( postcts_hold )
  g.add_step( route        )
  g.add_step( postroute    )
  g.add_step( signoff      )
  g.add_step( genlibdb     )
  g.add_step( gdsmerge     )
  g.add_step( drc          )
  g.add_step( lvs          )
  g.add_step( pt_timing    )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  dc.extend_inputs(['sram_tt_1p1V_25C.db'])
  pt_timing.extend_inputs(['sram_tt_1p1V_25C.db'])
  genlibdb.extend_inputs(['sram_tt_1p1V_25C.db'])
  init.extend_inputs(['floorplan.tcl', 'pin-assignments.tcl'])
  power.extend_inputs(['globalnetconnect.tcl', 'power-strategy-singlemesh.tcl'])

  for step in [iflow, init, power, place, cts, postcts_hold, route, postroute, signoff]:
    step.extend_inputs(['sram_tt_1p1V_25C.lib', 'sram.lef'])

  gdsmerge.extend_inputs(['sram.gds'])
  lvs.extend_inputs(['sram.sp'])

  # Add a set units command to init as a temporary fix for conflicting
  # units between SRAM lib and stdcells.lib

  init.pre_extend_commands( [
    r'echo -e "setLibraryUnit -cap 1fF -time 1ns\n$(cat scripts/main.tcl)"'
      r' > scripts/main.tcl',
  ] )

  # Connect by name

  g.connect_by_name( sram,        hls          )
  
  dc.extend_inputs(['sram_64_256_TT_1p1V_25C.db'])
  dc.extend_inputs(['sram_512_128_TT_1p1V_25C.db'])
  g.connect_by_name( sram,        dc           )
  g.connect_by_name( hls,         dc           )
  g.connect_by_name( adk,         dc           )
  g.connect_by_name( constraints, dc           )

  g.connect_by_name( adk,      iflow        )
  g.connect_by_name( adk,      init         )
  g.connect_by_name( adk,      power        )
  g.connect_by_name( adk,      place        )
  g.connect_by_name( adk,      cts          )
  g.connect_by_name( adk,      postcts_hold )
  g.connect_by_name( adk,      route        )
  g.connect_by_name( adk,      postroute    )
  g.connect_by_name( adk,      signoff      )
  g.connect_by_name( adk,      genlibdb     )
  g.connect_by_name( adk,      gdsmerge     )
  g.connect_by_name( adk,      drc          )
  g.connect_by_name( adk,      lvs          )
  g.connect_by_name( adk,      pt_timing    )

  g.connect_by_name( sram,        iflow     )
  g.connect_by_name( sram,        init      )
  g.connect_by_name( sram,        power     )
  g.connect_by_name( sram,        place     )
  g.connect_by_name( sram,        cts       )
  g.connect_by_name( sram,        postcts_hold )
  g.connect_by_name( sram,        route     )
  g.connect_by_name( sram,        postroute )
  g.connect_by_name( sram,        signoff   )
  g.connect_by_name( sram,        gdsmerge  )
  g.connect_by_name( sram,        lvs       )
  g.connect_by_name( sram,        pt_timing )
  g.connect_by_name( sram,        genlibdb )

  g.connect_by_name( dc,       iflow        )
  g.connect_by_name( dc,       init         )
  g.connect_by_name( dc,       power        )
  g.connect_by_name( dc,       place        )
  g.connect_by_name( dc,       cts          )

  g.connect_by_name( iflow,    init         )
  g.connect_by_name( iflow,    power        )
  g.connect_by_name( iflow,    place        )
  g.connect_by_name( iflow,    cts          )
  g.connect_by_name( iflow,    postcts_hold )
  g.connect_by_name( iflow,    route        )
  g.connect_by_name( iflow,    postroute    )
  g.connect_by_name( iflow,    signoff      )

  g.connect_by_name( floorplan,    init         )
  g.connect_by_name( pin_placement,init         )
  g.connect_by_name( init,         power        )
  g.connect_by_name( power_sram,   power        )
  g.connect_by_name( power,        place        )
  g.connect_by_name( place,        cts          )
  g.connect_by_name( cts,          postcts_hold )
  g.connect_by_name( postcts_hold, route        )
  g.connect_by_name( route,        postroute    )
  g.connect_by_name( postroute,    signoff      )
  g.connect_by_name( signoff,      genlibdb     )
  g.connect_by_name( signoff,      gdsmerge     )
  g.connect_by_name( signoff,      drc          )
  g.connect_by_name( gdsmerge,     drc          )
  g.connect_by_name( signoff,      lvs          )
  g.connect_by_name( gdsmerge,     lvs          )
  g.connect_by_name( signoff,      pt_timing    )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()
#  g.plot()

