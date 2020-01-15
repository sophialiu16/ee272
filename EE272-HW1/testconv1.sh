#!/bin/bash 
python ./tools/run_optimizer.py basic ./examples/arch/baseline.json ./examples/layer/resnet34/conv1.json -s ./examples/schedule/dataflow_C_K.json -v

for a in examples/arch/archs/*
do 
    echo $a
    python ./tools/run_optimizer.py mem_explore ./$a ./examples/layer/resnet34/conv1.json -s ./examples/schedule/dataflow_C_K.json -v
done
