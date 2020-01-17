#!/bin/bash
echo *****************************conv1_256
python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline16_1.json ./examples/layer/ce/conv1.json -s ./examples/schedule/dataflow_C_K.json -v
