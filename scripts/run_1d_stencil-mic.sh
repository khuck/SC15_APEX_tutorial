#!/bin/bash -e

nx=100000
np=1000
nt=45
i=60

rm -f apex.conf tau.conf
cat << EOF > apex.conf
APEX_TAU=1
EOF
cat << EOF > tau.conf
TAU_TRACE=1
TAU_PROFILE=1
EOF
#TAU_PROFILE_FORMAT=merged

get_micfile 
cmd="srun mpirun.mic -n 1 -hostfile micfile.$SLURM_JOB_ID -ppn 1 ./build-mic/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt --hpx:bind=balanced --hpx:print-bind"
echo ${cmd}
${cmd}

rm -f apex.conf tau.conf
