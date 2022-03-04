cmake_minimum_required(VERSION 3.10)
project(OS C)

set(CMAKE_C_STANDARD 99)

add_executable(OS program.c chapter4/my_pthread.c chapter4/q3.c chapter4/q4.c chapter4/q5.c)