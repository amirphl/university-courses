cmake_minimum_required(VERSION 3.13)
project(Serial_Version)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fopenmp")

add_executable(Serial_Version main.cpp)