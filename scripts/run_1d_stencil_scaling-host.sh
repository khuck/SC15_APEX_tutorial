#!/bin/bash -e

# nx is the number of cells per partition
nx=100000
# np is the number of partitions
np=1000
# nt is the number of timesteps
nt=45

export APEX_TAU=1
export TAU_PROFILE_FORMAT=merged

get_hostfile 
for i in 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 1 ; do 
    #cmd="srun mpirun.host -n 1 -hostfile hostfile.$SLURM_JOB_ID -ppn 1 ./build-host/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
    #cmd="./build-host/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
    cmd="./build-host/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced"
    echo ${cmd}
    ${cmd}
    mv tauprofile.xml tauprofile-${i}.xml
done
