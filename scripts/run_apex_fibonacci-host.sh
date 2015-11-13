#!/bin/bash -e

#get_hostfile 
#cmd="srun mpirun.host -n 1 -hostfile hostfile.$SLURM_JOB_ID -ppn 1 ./build-host/apex_examples/apex_fibonacci"
cmd="./build-host/apex_examples/apex_fibonacci --hpx:threads 32"
echo ${cmd}
${cmd}

