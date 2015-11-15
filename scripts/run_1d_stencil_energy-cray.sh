#!/bin/bash -e

# nx is the number of cells per partition
#nx=100000
nx=250000
# np is the number of partitions
#np=1000
np=400
# nt is the number of timesteps
nt=100
i=48

export APEX_TAU=0
export TAU_TRACE=1
export TAU_PROFILE=1
export TAU_PROFILE_FORMAT=merged
export APEX_POLICY=1
export APEX_THROTTLE_CONCURRENCY=1
export APEX_THROTTLE_ENERGY=1
export APEX_THROTTLING_MIN_THREADS=8
export APEX_THROTTLING_MAX_THREADS=${i}
export APEX_THROTTLING_MIN_WATTS=130
export APEX_THROTTLING_MAX_WATTS=170
export APEX_MEASURE_CONCURRENCY=1

cmd="aprun -N 1 -n 1 -d ${i} -j 2 ./build-cray/apex_examples/1d_stencil_4_energy --hpx:queuing=throttle --hpx:threads 48 --nx $nx --np $np --nt $nt"
echo ${cmd}
${cmd}
mv tauprofile.xml tauprofile-throttled-cray.xml
