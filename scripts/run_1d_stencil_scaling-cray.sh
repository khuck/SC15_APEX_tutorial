#!/bin/bash -e

# nx is the number of cells per partition
nx=250000
# np is the number of partitions
np=400
# nt is the number of timesteps
nt=500

export APEX_TAU=1
export TAU_PROFILE_FORMAT=merged

for i in 24 22 20 18 16 14 12 10 8 6 4 2 1 ; do 
    #cmd="srun mpirun.host -n 1 -hostfile hostfile.$SLURM_JOB_ID -ppn 1 ./build-host/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
    #cmd="./build-host/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
    cmd="aprun -n 1 -N 1 -d ${i} ./build-cray/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=compact"
    echo ${cmd}
    ${cmd}
    mv tauprofile.xml tauprofile-${i}.xml
done
