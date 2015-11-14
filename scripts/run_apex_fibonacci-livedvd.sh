#!/bin/bash -e

cmd="./build-x86_64/apex_examples/apex_fibonacci --hpx:threads 4"
echo ${cmd}
${cmd}

