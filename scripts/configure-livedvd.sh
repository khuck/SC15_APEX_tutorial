#!/bin/bash -e

base=`dirname $(readlink -e $0)`
. ${base}/configure.sh

expected_arch=x86_64
builddir=build-x86_64
CC=gcc
CXX=g++
TOOLCHAIN=${base}/../etc/x86_64.cmake
buildtype=RelWithDebInfo

do_cmake
make -j2
