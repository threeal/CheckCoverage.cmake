cmake_minimum_required(VERSION 3.5)

project(Sample)

add_library(fibonacci src/fibonacci.cpp)
target_include_directories(fibonacci PUBLIC include)

enable_testing()

add_executable(fibonacci_test test/fibonacci_test.cpp)
target_link_libraries(fibonacci_test PRIVATE fibonacci)

add_test(
  NAME fibonacci_test
  COMMAND $<TARGET_FILE:fibonacci_test>
)
