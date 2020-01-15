#!/bin/bash 
for f in examples/layer/ce/*
do 
    for a in examples/arch/archsce/*
    do
        echo $f
        echo $a
        python ./tools/run_optimizer.py mem_explore ./$a ./$f -s ./examples/schedule/dataflow_C_K_16.json -v
    done
done
