#!/bin/bash
echo *****************************
python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline16.json ./examples/layer/resnet34/conv5.json -s ./examples/schedule/dataflow_C_K_16.json -v

