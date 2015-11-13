# SC15_APEX_tutorial
APEX examples for SC15 HPX tutorial

This collection of files contains exercises for the SC15 tutorial:
*Massively Parallel Task-Based Programming with HPX*
http://sc15.supercomputing.org/schedule/event_detail?evid=tut139

Any questions or comments, please contact khuck@cs.uoregon.edu.

# BEFORE YOU START:
To run the exercises in this tutorial, make sure you have set up your environment on edison.nersc.gov or babbage.nersc.gov to build HPX examples:

```
source /project/projectdirs/training/SC15/HPX-SC15/hpx_install/env.sh
```
should give this output:
```
Loading environment for Babbage

Newly available modules:

-------------------------- /project/projectdirs/xpress/tau2-hpx-babbage/modulefiles --------------------------
tau/host-2.25 tau/mic-2.25

-------------- /chos/global/project/projectdirs/training/SC15/HPX-SC15/hpx_install/modulefiles ---------------
hpx/0.9.11-debug        hpx/host-0.9.11-debug   hpx/mic-0.9.11-debug
hpx/0.9.11-release      hpx/host-0.9.11-release hpx/mic-0.9.11-release
```

Then load the appropriate module (for the first example, load the Babbage host module):
```
# to build examples to run on the Babbage host nodes
module load hpx/host-0.9.11-release
# to build examples to run on the Babbage MIC devices
module load hpx/mic-0.9.11-release
# to build examples to run on Edison
module load hpx/0.9.11-release
```

Download and expand these examples:

```
cd $HOME
wget https://github.com/khuck/SC15_APEX_tutorial/archive/master.zip
unzip master.zip
cd SC15_APEX_tutorial
```

# Exercise 1

