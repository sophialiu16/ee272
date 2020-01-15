#!/bin/bash
echo *****************************
python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline8.json ./examples/layer/resnet34/conv5.json -s ./examples/schedule/dataflow_C_K_16.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline8.json ./examples/layer/resnet34/conv4.json -s ./examples/schedule/dataflow_C_K_16.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline8.json ./examples/layer/resnet34/conv3.json -s ./examples/schedule/dataflow_C_K_16.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline8.json ./examples/layer/resnet34/conv2.json -s ./examples/schedule/dataflow_C_K_16.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline8_true.json ./examples/layer/resnet34/conv1.json -s ./examples/schedule/dataflow_C_K.json -v





