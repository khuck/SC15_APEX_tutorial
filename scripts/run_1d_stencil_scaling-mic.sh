#!/bin/bash -e

nx=100000
np=1000
nt=45

get_micfile 
#for i in $(seq 2 2 60); do 
for i in 1 2 4 8 16 30 60 90 120 ; do 
    cmd="srun mpirun.mic -n 1 -hostfile micfile.$SLURM_JOB_ID -ppn 1 ./build-mic/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
    echo ${cmd}
    ${cmd}
done
