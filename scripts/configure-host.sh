#!/bin/bash -e

base=`dirname $(readlink -e $0)`
. ${base}/configure.sh

expected_arch=host
builddir=build-host
CC=icc
CXX=icpc
TOOLCHAIN=${base}/../etc/Xeon.cmake
buildtype=RelWithDebInfo

do_cmake
make -j
