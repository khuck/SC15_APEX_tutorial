# Copyright (c) 2007-2015 Hartmut Kaiser
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

project(apex_tutorials CXX)

cmake_minimum_required(VERSION 2.8)
cmake_policy(SET CMP0015 NEW)

################################################################################
# Build type (needs to be handled before project command below)
################################################################################
#
# If the user specifies -DCMAKE_BUILD_TYPE on the command line, take their definition
# and dump it in the cache along with proper documentation, otherwise set CMAKE_BUILD_TYPE
# to Debug prior to calling PROJECT()
#
IF(NOT DEFINED CMAKE_BUILD_TYPE OR NOT CMAKE_BUILD_TYPE)
   MESSAGE("*** Warning! CMAKE_BUILD_TYPE not defined!")
   MESSAGE("*** Because this is a benchmark, defaulting CMAKE_CXX_FLAGS to '-O3 -DNDEBUG'")
   # this doesn't really work.
   SET(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel.")
   SET(CMAKE_CXX_FLAGS "-O3 -DNDEBUG")
   SET(CMAKE_C_FLAGS "-O3 -DNDEBUG")
ENDIF()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

################################################################################
# enable solution folders for MSVC
if(MSVC)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

################################################################################
# Commented the following out,  
#     should work if CMAKE_PREFIX_PATH is set to include 
#     hpx build or install directory

# Find and include HPX settings
#if(NOT HPX_ROOT)
#  if(NOT $ENV{HPX_ROOT} STREQUAL "")
#      set(HPX_ROOT $ENV{HPX_ROOT})
#  endif()
#endif()
#if(NOT HPX_ROOT)
#  message(FATAL_ERROR "HPX_ROOT not set, unable to find hpx!")
#endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${HPX_ROOT}/share/cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/Modules)

find_package(HPX REQUIRED)

# find_library(MATHLIB m)                                                          
# foreach(_lib ${MATHLIB})                                                            
#     get_filename_component(_lib_name ${_lib} NAME_WE)                            
#     string(REGEX REPLACE "^lib" "" _name ${_lib_name})                           
#     list(APPEND MY_LIBS "-l${_name}")                                            
#     get_filename_component(_lib_dir ${_lib} PATH)                                
#     list(APPEND MY_LINKFLAGS "-L${_lib_dir}")                                    
# endforeach()                                                                     
# list(REMOVE_DUPLICATES MY_LIBS )                                                 
# list(REMOVE_DUPLICATES MY_LINKFLAGS )                                            
# string(REPLACE ";" " " TMP_LIBS "${MY_LIBS}")                                    
# string(REPLACE ";" " " TMP_LINKFLAGS "${MY_LINKFLAGS}")
# SET( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${TMP_LINKFLAGS} ${TMP_LIBS}" )

################################################################################
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${HPX_INCLUDE_DIR})
link_directories(${HPX_LIBRARY_DIR})

add_definitions(-DINNCABS_USE_HPX)
if(INNCABS_USE_HPX_FUTURIZED)
  add_definitions(-DINNCABS_USE_HPX_FUTURIZED)
endif()

set(subdirs
    apex_examples
    )

foreach(subdir ${subdirs})
  add_hpx_pseudo_target(benchmarks.${subdir})
  add_subdirectory(${subdir})
endforeach()


