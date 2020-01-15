#!/bin/bash
echo *****************************
python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline4.json ./examples/layer/resnet34/conv5.json -s ./examples/schedule/dataflow4.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline4.json ./examples/layer/resnet34/conv4.json -s ./examples/schedule/dataflow4.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline4.json ./examples/layer/resnet34/conv3.json -s ./examples/schedule/dataflow4.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline4.json ./examples/layer/resnet34/conv2.json -s ./examples/schedule/dataflow4.json -v

python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline4_true.json ./examples/layer/resnet34/conv1.json -s ./examples/schedule/dataflow4_conv1.json -v





