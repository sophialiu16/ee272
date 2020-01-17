#!/bin/bash
echo *****************************
for f in examples/layer/ce/* 
do 
    echo $f
    echo *****************************
    python ./tools/run_optimizer.py mem_explore ./examples/arch/archs/baseline16.json ./$f -s ./examples/schedule/dataflow_C_K_16.json -v
done
