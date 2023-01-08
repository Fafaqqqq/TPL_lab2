cmake_minimum_required(VERSION 3.21)

set(target cparser)

project(${target})

file(GLOB_RECURSE sources 
    src/*.h
    src/*.c
)

add_executable(${target} ${sources})

set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)

