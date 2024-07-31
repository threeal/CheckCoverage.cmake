add_test(
  NAME CheckCoverageTest.cmake
  COMMAND "${CMAKE_COMMAND}"
    -P ${CMAKE_CURRENT_SOURCE_DIR}/CheckCoverageTest.cmake)
