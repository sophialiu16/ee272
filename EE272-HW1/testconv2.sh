#!/bin/bash
echo *****************************
python ./tools/run_optimizer.py basic ./examples/arch/archs/baseline2_1.json ./examples/layer/ce/conv1.json -s ./examples/schedule/dataflow_C_K_2.json -v

for f in examples/layer/ce/* 
do 
    echo $f
    echo *****************************
    python ./tools/run_optimizer.py basic ./examples/arch/archs/baseline2.json ./$f -s ./examples/schedule/dataflow_C_K_2.json -v
done
