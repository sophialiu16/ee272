#!/bin/bash 
python ./tools/run_optimizer.py basic ./examples/arch/baseline.json ./examples/layer/resnet34/conv1.json -s ./examples/schedule/dataflow_C_K.json -v
