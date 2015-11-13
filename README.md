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

Host, CrayCNL is similar.  It should be noted that APEX/HPX shutdown is somewhat delayed on Babbage - the more threads are requested, the longer it takes to terminate HPX. This is a known issue and is being investigated.

# Exercise 2: Generating TAU profiles through APEX

## About this exercise

This exercise shows how to enable TAU profiling with APEX, and demonstrates what is generated. The example program is a simple 1D stencil heat diffusion program with 1000 partitions of 100000 cells each. The program is executed on the MIC with 60 threads.  This is neither the ideal program decomposition, nor the ideal number of threads, as we will see from later examples.  This exercise also uses an HPX feature to bind threads to cores using a "balanced" layout (for more information, see http://stellar-group.github.io/hpx/docs/html/hpx/manual/init/commandline/details.html).

## Running the exercise on the Babbage MIC node

The program is executed by starting (or continuing) an interactive session and running the example:

### Babbage MIC nodes:
```
salloc --reservation=SC_Reservation -N 1 -p debug
# after the allocation is granted:
./scripts/run_1d_stencil-mic.sh
```

The output should look something like this:

```
srun mpirun.mic -n 1 -hostfile micfile.8938 -ppn 1 ./build-mic/apex_examples/1d_stencil_4 --hpx:threads 60 --nx 100000 --np 1000 --nt 45 --hpx:bind=balanced --hpx:print-bind
*******************************************************************************
locality: 0
   0: PU L#4(P#1), Core L#1(P#0), Socket L#0(P#0)
   1: PU L#8(P#5), Core L#2(P#1), Socket L#0(P#0)
   2: PU L#12(P#9), Core L#3(P#2), Socket L#0(P#0)
   3: PU L#16(P#13), Core L#4(P#3), Socket L#0(P#0)
   4: PU L#20(P#17), Core L#5(P#4), Socket L#0(P#0)
   5: PU L#24(P#21), Core L#6(P#5), Socket L#0(P#0)
   6: PU L#28(P#25), Core L#7(P#6), Socket L#0(P#0)
   7: PU L#32(P#29), Core L#8(P#7), Socket L#0(P#0)
   8: PU L#36(P#33), Core L#9(P#8), Socket L#0(P#0)
   9: PU L#40(P#37), Core L#10(P#9), Socket L#0(P#0)
  10: PU L#44(P#41), Core L#11(P#10), Socket L#0(P#0)
  11: PU L#48(P#45), Core L#12(P#11), Socket L#0(P#0)
  12: PU L#52(P#49), Core L#13(P#12), Socket L#0(P#0)
  13: PU L#56(P#53), Core L#14(P#13), Socket L#0(P#0)
  14: PU L#60(P#57), Core L#15(P#14), Socket L#0(P#0)
  15: PU L#64(P#61), Core L#16(P#15), Socket L#0(P#0)
  16: PU L#68(P#65), Core L#17(P#16), Socket L#0(P#0)
  17: PU L#72(P#69), Core L#18(P#17), Socket L#0(P#0)
  18: PU L#76(P#73), Core L#19(P#18), Socket L#0(P#0)
  19: PU L#80(P#77), Core L#20(P#19), Socket L#0(P#0)
  20: PU L#84(P#81), Core L#21(P#20), Socket L#0(P#0)
  21: PU L#88(P#85), Core L#22(P#21), Socket L#0(P#0)
  22: PU L#92(P#89), Core L#23(P#22), Socket L#0(P#0)
  23: PU L#96(P#93), Core L#24(P#23), Socket L#0(P#0)
  24: PU L#100(P#97), Core L#25(P#24), Socket L#0(P#0)
  25: PU L#104(P#101), Core L#26(P#25), Socket L#0(P#0)
  26: PU L#108(P#105), Core L#27(P#26), Socket L#0(P#0)
  27: PU L#112(P#109), Core L#28(P#27), Socket L#0(P#0)
  28: PU L#116(P#113), Core L#29(P#28), Socket L#0(P#0)
  29: PU L#120(P#117), Core L#30(P#29), Socket L#0(P#0)
  30: PU L#124(P#121), Core L#31(P#30), Socket L#0(P#0)
  31: PU L#128(P#125), Core L#32(P#31), Socket L#0(P#0)
  32: PU L#132(P#129), Core L#33(P#32), Socket L#0(P#0)
  33: PU L#136(P#133), Core L#34(P#33), Socket L#0(P#0)
  34: PU L#140(P#137), Core L#35(P#34), Socket L#0(P#0)
  35: PU L#144(P#141), Core L#36(P#35), Socket L#0(P#0)
  36: PU L#148(P#145), Core L#37(P#36), Socket L#0(P#0)
  37: PU L#152(P#149), Core L#38(P#37), Socket L#0(P#0)
  38: PU L#156(P#153), Core L#39(P#38), Socket L#0(P#0)
  39: PU L#160(P#157), Core L#40(P#39), Socket L#0(P#0)
  40: PU L#164(P#161), Core L#41(P#40), Socket L#0(P#0)
  41: PU L#168(P#165), Core L#42(P#41), Socket L#0(P#0)
  42: PU L#172(P#169), Core L#43(P#42), Socket L#0(P#0)
  43: PU L#176(P#173), Core L#44(P#43), Socket L#0(P#0)
  44: PU L#180(P#177), Core L#45(P#44), Socket L#0(P#0)
  45: PU L#184(P#181), Core L#46(P#45), Socket L#0(P#0)
  46: PU L#188(P#185), Core L#47(P#46), Socket L#0(P#0)
  47: PU L#192(P#189), Core L#48(P#47), Socket L#0(P#0)
  48: PU L#196(P#193), Core L#49(P#48), Socket L#0(P#0)
  49: PU L#200(P#197), Core L#50(P#49), Socket L#0(P#0)
  50: PU L#204(P#201), Core L#51(P#50), Socket L#0(P#0)
  51: PU L#208(P#205), Core L#52(P#51), Socket L#0(P#0)
  52: PU L#212(P#209), Core L#53(P#52), Socket L#0(P#0)
  53: PU L#216(P#213), Core L#54(P#53), Socket L#0(P#0)
  54: PU L#220(P#217), Core L#55(P#54), Socket L#0(P#0)
  55: PU L#224(P#221), Core L#56(P#55), Socket L#0(P#0)
  56: PU L#228(P#225), Core L#57(P#56), Socket L#0(P#0)
  57: PU L#232(P#229), Core L#58(P#57), Socket L#0(P#0)
  58: PU L#236(P#233), Core L#59(P#58), Socket L#0(P#0)
  59: PU L#0(P#0), Core L#0(P#59), Socket L#0(P#0)
OS_Threads,Execution_Time_sec,Points_per_Partition,Partitions,Time_Steps
60,                   44.961225832, 100000,               1000,                 45                   
```

The directory should now be full of profiles and trace files.  To see the TAU summary of the profiles, use the pprof command:

```
pprof -s
Reading Profile files in profile.*

FUNCTION SUMMARY (total):
---------------------------------------------------------------------------------------
%Time    Exclusive    Inclusive       #Call      #Subrs  Inclusive Name
              msec   total msec                          usec/call 
---------------------------------------------------------------------------------------
100.0  1:27:15.217  1:42:02.260          71       76631   86229019 .TAU application
 10.3    10:30.319    10:30.319       45009           0      14004 hpx::lcos::local::dataflow::execute
  1.4       58,775     1:26.683           1          58   86683381 ProcData::read_proc
  1.4     1:26.420     1:26.420           1           0   86420417 APEX MAIN THREAD
  1.3     1:17.521     1:17.521          60           0    1292027 hpx_main
  0.5       27,833       27,908          58         385     481178 ProcData::read_proc: main loop
  0.1        5,938        5,938       31881           0        186 profiler_listener::process_profiles
  0.0          117          117           3           0      39012 load_components_action
  0.0           73           73           3           0      24360 pre_main
  0.0           12           12          31           0        389 primary_namespace_bulk_service_action
  0.0            7            7           2           0       3669 call_startup_functions_action
  0.0            6            6           2           0       3336 call_shutdown_functions_action
  0.0            6            6           9           0        708 symbol_namespace_service_action
  0.0            4            4           1           0       4924 run_helper
  0.0            2            2           5           0        436 primary_namespace_service_action
  0.0            2            2           4           0        520 broadcast_call_startup_functions_action
  0.0            1            1           4           0        473 broadcast_call_shutdown_functions_action

FUNCTION SUMMARY (mean):
---------------------------------------------------------------------------------------
%Time    Exclusive    Inclusive       #Call      #Subrs  Inclusive Name
              msec   total msec                          usec/call 
---------------------------------------------------------------------------------------
100.0     1:13.735     1:26.229           1     1079.31   86229019 .TAU application
 10.3        8,877        8,877      633.93           0      14004 hpx::lcos::local::dataflow::execute
  1.4          827        1,220   0.0140845    0.816901   86683381 ProcData::read_proc
  1.4        1,217        1,217   0.0140845           0   86420417 APEX MAIN THREAD
  1.3        1,091        1,091     0.84507           0    1292027 hpx_main
  0.5          392          393    0.816901     5.42254     481178 ProcData::read_proc: main loop
  0.1           83           83     449.028           0        186 profiler_listener::process_profiles
  0.0            1            1   0.0422535           0      39012 load_components_action
  0.0            1            1   0.0422535           0      24360 pre_main
  0.0         0.17         0.17     0.43662           0        389 primary_namespace_bulk_service_action
  0.0        0.103        0.103    0.028169           0       3669 call_startup_functions_action
  0.0        0.094        0.094    0.028169           0       3335 call_shutdown_functions_action
  0.0       0.0897       0.0897    0.126761           0        708 symbol_namespace_service_action
  0.0       0.0694       0.0694   0.0140845           0       4924 run_helper
  0.0       0.0307       0.0307   0.0704225           0        436 primary_namespace_service_action
  0.0       0.0293       0.0293    0.056338           0        520 broadcast_call_startup_functions_action
  0.0       0.0266       0.0266    0.056338           0        473 broadcast_call_shutdown_functions_action
```

Running pprof without the -s option will show data for each individual thread.  For a visualization of the profile output, use the paraprof program.

Before the trace files can be visualized, they have to be merged. The trace files are merged using the `tau_multimerge` program, and then the trace is converted to slog2 format using the `tau2slog2` program. After those two steps, the trace can be loaded into the `jumpshot` program:

```
tau_multimerge
tau2slog2 tau.trc tau.edf -o tau.slog2
jumpshot ./tau.slog2
```

# Exercise 3: APEX policy to throttle thread concurrency

## About this exercise

This program is the same 1D stencil heat diffusion program described in exercise 2, but modified to include an APEX policy that will attempt to adjust the thread concurrency to improve performance.  The program is memory-bound beyond a number of threads (system-dependent, usually around 8-12) because the memory request traffic far exceeds the amount of computation required to update a single cell. Scaling studies of this test program have shown that the *ideal* number of threads is that which maximizes concurrency without oversaturating the memory controller. The APEX policy uses ActiveHarmony to minimize the HPX thread queue length (number of tasks waiting to execute). This is the function that requests the counter from HPX and adds it to the APEX profile:

```
bool test_function(apex_context const& context) {
    if (!counters_initialized) return false;
    try {
        counter_value value1 = performance_counter::get_value(counter_id);
        apex::sample_value("thread_queue_length", value1.get_value<int>());
        return APEX_NOERROR;
    }
    catch(hpx::exception const& e) {
        std::cerr
            << "apex_policy_engine_active_thread_count: caught exception: "
            << e.what() << std::endl;
        return APEX_ERROR;
    }
}
```

and this is the APEX API call to set up concurrency throttling, using the output from that function call:

```
void register_policies() {
    apex::register_periodic_policy(100000, test_function);

    apex::setup_timer_throttling(std::string("thread_queue_length"),
        APEX_MINIMIZE_ACCUMULATED, APEX_ACTIVE_HARMONY, 200000);
}
```

The policy registration is configured to run as an HPX "startup" function:

```
    hpx::register_startup_function(&register_policies);
```

## Running the exercise on the Babbage host node:

The program is executed by starting (or continuing) an interactive session and running the example:

### Babbage host nodes:
```
salloc --reservation=SC_Reservation -N 1 -p debug
# after the allocation is granted:
./scripts/run_1d_stencil_throttle-host.sh
```

The output should look something like this:

```
./build-host/apex_examples/1d_stencil_4_throttle --hpx:queuing=throttle --hpx:threads 32 --nx 250000 --np 400 --nt 100 --hpx:bind=balanced
Counters initialized! {00000001de000001, 0000000000001001}
APEX concurrency throttling enabled, min threads: 8 max threads: 32
Cap: 32 New: 0 Prev: 0
Cap: 24 New: 123 Prev: 123
Cap: 16 New: 0 Prev: 123
Cap: 20 New: 336 Prev: 459
Cap: 16 New: 0 Prev: 459
Cap: 12 New: 0 Prev: 459
Cap: 16 New: 0 Prev: 459
Cap: 18 New: 304 Prev: 763
Cap: 16 New: 0 Prev: 763
Cap: 14 New: 0 Prev: 763
Cap: 16 New: 0 Prev: 763
Cap: 17 New: 206 Prev: 969
Cap: 16 New: 0 Prev: 969
Cap: 15 New: 0 Prev: 969
Cap: 16 New: 0 Prev: 969
Cap: 16 New: 106 Prev: 1075
Cap: 16 New: 94 Prev: 1169
Thread Cap value optimization has converged.
Thread Cap value : 16
Cap: 16 New: 0 Prev: 1169
Cap: 16 New: 0 Prev: 1169
Cap: 16 New: 0 Prev: 1169
...
Cap: 16 New: 39 Prev: 5224
Cap: 16 New: 42 Prev: 5266
OS_Threads,Execution_Time_sec,Points_per_Partition,Partitions,Time_Steps
32,                   27.285449883, 250000,               400,                  100                  
```

While 16 is not the *optimal* solution, it is an improvement over the performance without the adaptation.
