#!/bin/bash 
for f in examples/layer/resnet/*
do 
    echo $f
    python ./tools/run_optimizer.py basic ./examples/arch/3_level_mem_basic_example.json ./$f -s ./examples/schedule/dataflow_C_K.json -v
done
