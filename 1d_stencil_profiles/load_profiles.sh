#!/bin/bash -x

for i in 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 ; do
	taudb_loadtrial -g ./perfdmf.cfg.SC15_tutorial -n ${i} tauprofile-${i}.xml
done