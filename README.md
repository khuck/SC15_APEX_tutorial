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

The example also forces APEX to output its settings at program initialization, and output a summary of all observed events at the end.

```
    // force APEX output
    apex::apex_options::use_screen_output(true);
```

## Running the exercise on the Babbage MIC node

After compilation, the program is executed by starting an interactive session and running the example:

### Babbage MIC nodes:
```
salloc --reservation=SC_Reservation -N 1 -p debug
# after the allocation is granted:
./scripts/run_apex_fibonacci-mic.sh
```

The output should look something like this:

```
./build-mic/apex_examples/apex_fibonacci --hpx:threads 10
Startup event
Start event
0.9.11-4c96a9b-HEAD
Built on: 20:39:55 Nov 12 2015
C++ Language Standard version : 201103
Intel Compiler version : Intel(R) C++ g++ 4.7 mode
APEX_TAU : 0
APEX_POLICY : 1
APEX_MEASURE_CONCURRENCY : 0
APEX_UDP_SINK : 0
APEX_MEASURE_CONCURRENCY_PERIOD : 1000000
APEX_SCREEN_OUTPUT : 1
APEX_PROFILE_OUTPUT : 0
APEX_TASKGRAPH_OUTPUT : 0
APEX_PROC_CPUINFO : 0
APEX_PROC_MEMINFO : 0
APEX_PROC_NET_DEV : 0
APEX_PROC_SELF_STATUS : 0
APEX_PROC_STAT : 1
APEX_THROTTLE_CONCURRENCY : 0
APEX_THROTTLING_MAX_THREADS : 240
APEX_THROTTLING_MIN_THREADS : 1
APEX_THROTTLE_ENERGY : 0
APEX_THROTTLING_MAX_WATTS : 300
APEX_THROTTLING_MIN_WATTS : 150
APEX_PTHREAD_WRAPPER_STACK_SIZE : 0
APEX_UDP_SINK_HOST : localhost
APEX_UDP_SINK_PORT : 5560
APEX_UDP_SINK_CLIENTIP : 127.0.0.1
APEX_PAPI_METRICS : 
New thread event
New node event
New thread event
New thread event
New thread event
New thread event
... 
Sample value event
Sample value event
Sample value event
Elaspsed time: 7.66746
Cores detected: 240
Worker Threads observed: 10
Available CPU time: 76.6746
Action                         :  #calls  |  minimum |    mean  |  maximum |   total  |  stddev  |  % total  
------------------------------------------------------------------------------------------------------------
              APEX MAIN THREAD :        1    --n/a--   7.36e+00    --n/a--   7.36e+00   0.00e+00      9.599
                   CPU Guest % :        5   0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.00e+00    --n/a-- 
                CPU I/O Wait % :        5   0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.00e+00    --n/a-- 
                     CPU IRQ % :        5   0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.00e+00    --n/a-- 
                    CPU Idle % :        5   9.47e+01   9.66e+01   9.93e+01   4.83e+02   1.62e+00    --n/a-- 
                    CPU Nice % :        5   3.86e-01   3.23e+00   5.12e+00   1.62e+01   1.66e+00    --n/a-- 
                   CPU Steal % :        5   0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.00e+00    --n/a-- 
                  CPU System % :        5   1.18e-01   1.88e-01   3.22e-01   9.39e-01   8.23e-02    --n/a-- 
                    CPU User % :        5   5.60e-03   2.01e-02   7.59e-02   1.00e-01   2.79e-02    --n/a-- 
                CPU soft IRQ % :        5   3.19e-02   4.03e-02   5.98e-02   2.02e-01   1.03e-02    --n/a-- 
broadcast_call_shutdown_fun... :        2    --n/a--   5.93e-04    --n/a--   1.19e-03   0.00e+00      0.002
broadcast_call_startup_func... :        2    --n/a--   5.78e-04    --n/a--   1.16e-03   0.00e+00      0.002
call_shutdown_functions_action :        2    --n/a--   4.23e-03    --n/a--   8.47e-03   3.76e-03      0.011
 call_startup_functions_action :        2    --n/a--   4.26e-03    --n/a--   8.51e-03   3.77e-03      0.011
              fibonacci_action :      177    --n/a--   1.50e-03    --n/a--   2.65e-01   7.39e-04      0.345
                      hpx_main :        1    --n/a--   2.48e-03    --n/a--   2.48e-03   0.00e+00      0.003
        load_components_action :        2    --n/a--   6.48e-02    --n/a--   1.30e-01   5.25e-02      0.169
                      pre_main :        1    --n/a--   3.02e-02    --n/a--   3.02e-02   0.00e+00      0.039
primary_namespace_bulk_serv... :       40    --n/a--   6.75e-04    --n/a--   2.70e-02   4.46e-04      0.035
primary_namespace_service_a... :        4    --n/a--   3.42e-04    --n/a--   1.37e-03   1.65e-04      0.002
                    run_helper :        1    --n/a--   3.51e-03    --n/a--   3.51e-03   0.00e+00      0.005
symbol_namespace_service_ac... :        7    --n/a--   4.58e-04    --n/a--   3.21e-03   1.07e-04      0.004
                     APEX Idle :  --n/a--    --n/a--    --n/a--    --n/a--   6.88e+01    --n/a--     89.773
------------------------------------------------------------------------------------------------------------
Shutdown event
```

Host, CrayCNL is similar.
