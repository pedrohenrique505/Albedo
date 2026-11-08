# albedo - ReXGlue Recompiled Project
#
# SDK boilerplate lives in generated/rexglue.cmake (gerado pelo codegen).

cmake_minimum_required(VERSION 3.25)
project(albedo LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(generated/rexglue.cmake)

set(ALBEDO_SOURCES
    src/main.cpp
)

if(WIN32)
    add_executable(albedo WIN32 ${ALBEDO_SOURCES})
else()
    add_executable(albedo ${ALBEDO_SOURCES})
endif()

rexglue_setup_target(albedo GPU_PLUGINS xenos)
