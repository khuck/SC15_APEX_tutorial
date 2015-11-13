#!/bin/bash -e

# note: nx is TOTAL elements, nt is timesteps between repetitions, nr is number of repetitions
# nx is the TOTAL number of cells
nx=10000000
# nt is the number of timesteps
nt=50
# nr is number of repetitions
nr=50

export APEX_TAU=1
export TAU_PROFILE_FORMAT=merged
export APEX_POLICY=1

#get_hostfile 

cmd="./build-host/apex_examples/1d_stencil_4_repart --hpx:print-counter /threadqueue/length --hpx:print-counter-interval 100 --hpx:print-counter-destination /dev/null --hpx:threads 12 --nx $nx --nr $nr --nt $nt --hpx:bind=balanced"
echo ${cmd}
${cmd}
mv tauprofile.xml tauprofile-repart.xml
