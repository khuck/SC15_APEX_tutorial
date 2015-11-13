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

# Building the exercises:

## Compiling the exercises for the Babbage MIC devices:

To build the exercises for the Babbage MIC devices, load the appropriate module and then run the configuration script:

```
# if no HPX module loaded:
module load hpx/mic-0.9.11-release
# if HPX module already loaded:
module swap hpx hpx/mic-0.9.11-release
# run cmake and make
./scripts/configure-mic.sh
```

The build will be configured and compiled in the build-mic directory. After compiling, you should have the executables built in the directory `build-mic/apex_examples`.  The output should look something like this:

```
-- The CXX compiler identification is Intel 16.0.0.20150815
-- Check for working CXX compiler: /opt/intel/compilers_and_libraries_2016/linux/bin/intel64/icpc
-- Check for working CXX compiler: /opt/intel/compilers_and_libraries_2016/linux/bin/intel64/icpc -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- The C compiler identification is Intel 16.0.0.20150815
-- Check for working C compiler: /opt/intel/compilers_and_libraries_2016/linux/bin/intel64/icc
-- Check for working C compiler: /opt/intel/compilers_and_libraries_2016/linux/bin/intel64/icc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Using jemalloc allocator.
-- Configuring done
-- Generating done
-- Build files have been written to: /project/projectdirs/xpress/SC15_APEX_tutorial/build-mic
CMake configuration done. To build:
cd build-mic
make
Scanning dependencies of target 1d_stencil_4_exe
Scanning dependencies of target 1d_stencil_4_repart_exe
Scanning dependencies of target apex_fibonacci_exe
Scanning dependencies of target 1d_stencil_4_throttle_exe
[ 25%] Building CXX object apex_examples/CMakeFiles/apex_fibonacci_exe.dir/apex_fibonacci.cpp.o
[ 50%] [ 75%] [100%] Building CXX object apex_examples/CMakeFiles/1d_stencil_4_throttle_exe.dir/1d_stencil_4_throttle.cpp.o
Building CXX object apex_examples/CMakeFiles/1d_stencil_4_exe.dir/1d_stencil_4.cpp.o
Building CXX object apex_examples/CMakeFiles/1d_stencil_4_repart_exe.dir/1d_stencil_4_repart.cpp.o
Linking CXX executable apex_fibonacci
[100%] Built target apex_fibonacci_exe
Linking CXX executable 1d_stencil_4
[100%] Built target 1d_stencil_4_exe
Linking CXX executable 1d_stencil_4_throttle
Linking CXX executable 1d_stencil_4_repart
[100%] Built target 1d_stencil_4_throttle_exe
[100%] Built target 1d_stencil_4_repart_exe
```

## Compiling the exercises for the Babbage host nodes:

To build the exercises for the Babbage host nodes, load the appropriate module and then run the configuration script:

```
# if no HPX module loaded:
module load hpx/host-0.9.11-release
# if HPX module already loaded:
module swap hpx hpx/host-0.9.11-release
# run cmake and make
./scripts/configure-host.sh
```

The build will be configured and compiled in the build-host directory. After compiling, you should have the executables built in the directory `build-host/apex_examples`.

## Compiling the exercises for the Edison CNL nodes:

To build the exercises for the Edison CNL nodes, load the appropriate module and then run the configuration script:

```
# if no HPX module loaded:
module load hpx/0.9.11-release
# if HPX module already loaded:
module swap hpx hpx/0.9.11-release
# run cmake and make
./scripts/configure-cray.sh
```

The build will be configured and compiled in the build-cray directory. After compiling, you should have the executables built in the directory `build-cray/apex_examples`.


# Exercise 1: apex_fibonacci.cpp

## About this exercise:

The first exercise just demonstrates the usage of the APEX Policy Engine. This example is based on the fibonacci program available in HPX, but modified to include policies for different APEX event types. Every time an event passes through APEX, the callback function (defined as a C++ lamda in main()) is executed, printing a message to the screen identifying the event type:

```
    std::set<apex_event_type> when = {APEX_STARTUP, APEX_SHUTDOWN, APEX_NEW_NODE,
        APEX_NEW_THREAD, APEX_START_EVENT, APEX_STOP_EVENT, APEX_SAMPLE_VALUE};
    apex::register_policy(when, [](apex_context const& context)->int{
        switch(context.event_type) {
            case APEX_STARTUP: {
              std::cout << "Startup event" << std::endl;
              break;
            }
            case APEX_SHUTDOWN: {
              std::cout << "Shutdown event" << std::endl;
              break;
            }
            /* ... many other event types follow ... */
                        default: {
              std::cout << "Unknown event" << std::endl;
            }
        }
        return APEX_NOERROR;
    });
```

## Running the exercise on the Babbage host node

After compilation, the program is executed by starting an interactive session and running the example:

### Babbage host nodes:
```
salloc -N 1 -p debug
# after the allocation is granted:
./scripts/run
```
