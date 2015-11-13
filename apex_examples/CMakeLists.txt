# Copyright (c) 2015 Hartmut Kaiser
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

set(category apex_examples)
set(programs apex_fibonacci 1d_stencil_4 1d_stencil_4_throttle 1d_stencil_4_repart)

foreach(program ${programs})

  set(${program}_FLAGS DEPENDENCIES iostreams_component)

  set(sources ${program}.cpp)

  source_group("Source Files" FILES ${sources})

  # add executable
  add_hpx_executable(${program}
                     SOURCES ${sources}
                     ${${program}_FLAGS}
                     FOLDER "apex_examples")

  add_hpx_pseudo_target(apex_examples.${category}.${program})
  add_hpx_pseudo_dependencies(apex_examples.${category} apex_examples.${category}.${program})
  add_hpx_pseudo_dependencies(apex_examples.${category}.${program} ${program}_exe)

endforeach()

