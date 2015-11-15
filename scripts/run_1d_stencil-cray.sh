#!/bin/bash -e

nx=100000
np=1000
nt=100
i=24

export APEX_TAU=1
export TAU_TRACE=1
export TAU_PROFILE=1
#TAU_PROFILE_FORMAT=merged

cmd="aprun -N 1 -n 1 -d ${i} ./build-cray/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt"
echo ${cmd}
${cmd}

