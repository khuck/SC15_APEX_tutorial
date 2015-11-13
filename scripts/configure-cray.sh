#!/bin/bash -e

base=`dirname $(readlink -e $0)`
. ${base}/configure.sh

expected_arch=edison
builddir=build-cray
CC=icc
CXX=icpc
TOOLCHAIN=${base}/../etc/Cray-Intel.cmake
buildtype=RelWithDebInfo

do_cmake
make -j
