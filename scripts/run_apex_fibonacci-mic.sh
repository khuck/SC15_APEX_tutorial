#!/bin/bash -e

#get_micfile 
#cmd="srun mpirun.mic -n 1 -hostfile micfile.$SLURM_JOB_ID -ppn 1 ./build-mic/apex_examples/apex_fibonacci"
cmd="./build-mic/apex_examples/apex_fibonacci --hpx:threads 10"
echo ${cmd}
${cmd}

