cmake_minimum_required(VERSION 3.5)

project(Sample)

add_library(fibonacci src/fibonacci.cpp)
target_include_directories(fibonacci PUBLIC include)
