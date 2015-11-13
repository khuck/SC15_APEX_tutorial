#!/bin/bash -e

base=`dirname $(readlink -e $0)`
. ${base}/configure.sh

expected_arch=mic
builddir=build-mic
CC=icc
CXX=icpc
TOOLCHAIN=${base}/../etc/XeonPhi.cmake
buildtype=RelWithDebInfo

do_cmake
make -j
