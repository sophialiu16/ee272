#!/bin/bash 
for f in examples/layer/resnet34/*
do 
    echo $f
    python ./tools/run_optimizer.py basic ./examples/arch/baseline.json ./$f -s ./examples/schedule/dataflow_C_K_16.json -v
done
