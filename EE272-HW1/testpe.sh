#!/bin/bash 
for f in examples/layer/resnet34/*
do 
    for a in examples/arch/archs/*
    do
        echo $f
        echo $a
        python ./tools/run_optimizer.py mem_explore ./$a ./$f -s ./examples/schedule/dataflow_C_K_16.json -v 2>&1 | tee petest.txt
    done
done
