#!/bin/bash -e

i=24

cmd="aprun -N 1 -n 1 -d ${i} ./build-cray/apex_examples/apex_fibonacci --hpx:threads ${i}"
echo ${cmd}
${cmd}

