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

  # Default steps

  info         = Step( 'info',                          default=True )
  constraints  = Step( 'constraints',                   default=True )
  dc           = Step( 'synopsys-dc-synthesis',         default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info         )
  g.add_step( sram         )
  g.add_step( hls          )
  g.add_step( constraints  )
  g.add_step( dc           )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Connect by name

  g.connect_by_name( sram,        hls          )
  
  dc.extend_inputs(['sram_64_256_TT_1p1V_25C.db'])
  dc.extend_inputs(['sram_512_128_TT_1p1V_25C.db'])
  g.connect_by_name( sram,        dc           )
  g.connect_by_name( hls,         dc           )
  g.connect_by_name( adk,         dc           )
  g.connect_by_name( constraints, dc           )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()
#  g.plot()

