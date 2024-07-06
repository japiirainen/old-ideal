cmake_minimum_required(VERSION 3.27)

project(ideal)

set(CMAKE_CXX_STANDARD 23)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES 
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

add_library(math src/math.cpp)

# `idea` executable
add_executable(ideal src/main.cpp)
target_link_libraries(ideal math)

# `unit_tests` using googletest
add_executable(unit_tests test/unit.cpp)
target_link_libraries(unit_tests math gtest)

# prevent build on all targets build
set_target_properties(unit_tests PROPERTIES EXCLUDE_FROM_ALL TRUE)
