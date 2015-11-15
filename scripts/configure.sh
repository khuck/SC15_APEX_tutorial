#!/bin/bash -e

check_module()
{
if [ "x${HPX_ROOT}" = "x" ] ; then
  echo "HPX_ROOT is undefined - please source /project/projectdirs/training/SC15/HPX-SC15/hpx_install/env.sh and load an HPX module"
  kill -INT $$
else
  local ret=0
  `echo "${HPX_ROOT}" | grep -q ${expected_arch}` || ret=$?
  if [ ${ret} -eq 1 -a ! ${expected_arch} = "x86_64" ] ; then
    echo ""
    echo "The HPX module loaded does not match the expected one."
    echo "Please check that you loaded the correct HPX module for the platform '${expected_arch}'."
    kill -INT $$
  fi
fi
}

do_cmake()
{
  check_module
  rm -rf ${builddir}
  mkdir ${builddir}
  cd ${builddir}
  cmake -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
        -DCMAKE_BUILD_TYPE=${buildtype} \
        -DHPX_WITH_MALLOC=jemalloc \
        ..
  echo "CMake configuration done. To build:"
  echo "cd ${builddir}"
  echo "make"
}

