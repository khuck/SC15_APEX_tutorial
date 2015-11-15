#!/bin/bash -e

nx=100000
np=1000
nt=45
i=48

rm -f apex.conf tau.conf
cat << EOF > apex.conf
APEX_TAU=1
EOF
cat << EOF > tau.conf
TAU_TRACE=1
TAU_PROFILE=1
EOF
#TAU_PROFILE_FORMAT=merged

cmd="aprun -N 1 -n 1 -d ${i} -j 2 ./build-cray/apex_examples/1d_stencil_4 --hpx:threads $i --nx $nx --np $np --nt $nt"
echo ${cmd}
${cmd}

rm -f apex.conf tau.conf

