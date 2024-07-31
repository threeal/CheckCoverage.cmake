cmake_minimum_required(VERSION 3.5)

project(Sample)

# Add information to the CMake cache if it is built on MSVC.
if(MSVC)
  set(MSVC "${MSVC}" CACHE BOOL "")
endif()

find_package(
  CheckCoverage REQUIRED PATHS ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)

add_library(fibonacci src/fibonacci.cpp)
target_include_directories(fibonacci PUBLIC include)
set_property(TARGET fibonacci PROPERTY CXX_STANDARD 11)
if(NOT WITHOUT_COVERAGE_FLAGS)
  target_check_coverage(fibonacci)
endif()

enable_testing()

add_executable(fibonacci_test test/fibonacci_test.cpp)
target_link_libraries(fibonacci_test PRIVATE fibonacci)
set_property(TARGET fibonacci_test PROPERTY CXX_STANDARD 11)
if(NOT WITHOUT_COVERAGE_FLAGS)
  target_check_coverage(fibonacci_test)
endif()

add_test(
  NAME fibonacci_test
  COMMAND $<TARGET_FILE:fibonacci_test>
)
