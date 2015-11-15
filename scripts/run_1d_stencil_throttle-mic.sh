#!/bin/bash -e

# nx is the number of cells per partition
nx=100000
# np is the number of partitions
np=1000
# nt is the number of timesteps
nt=450
i=60

export APEX_TAU=1
export TAU_PROFILE_FORMAT=merged
export APEX_POLICY=1
export APEX_THROTTLE_CONCURRENCY=1
export APEX_THROTTLING_MIN_THREADS=4
export APEX_THROTTLING_MAX_THREADS=${i}

get_micfile 

cmd="mpirun.mic -n 1 -hostfile micfile.$SLURM_JOB_ID -ppn 1 ./build-mic/apex_examples/1d_stencil_4_throttle --hpx:queuing=throttle --hpx:threads ${i} --nx $nx --np $np --nt $nt"
echo ${cmd}
${cmd}
mv tauprofile.xml tauprofile-mic-throttled.xml
