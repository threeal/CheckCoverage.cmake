cmake_minimum_required(VERSION 3.21)

project(
  CheckCoverage
  VERSION 0.1.0
  DESCRIPTION "Check for test coverage in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/CheckCoverage.cmake
  LANGUAGES NONE
)

option(CHECK_COVERAGE_ENABLE_TESTS "Enable test targets.")
option(CHECK_COVERAGE_ENABLE_INSTALL "Enable install targets."
  "${PROJECT_IS_TOP_LEVEL}")

include(cmake/CheckCoverage.cmake)

if(CHECK_COVERAGE_ENABLE_TESTS)
  enable_testing()

  file(
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v1.0.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/Assertion.cmake
    EXPECTED_MD5 1d8ec589d6cc15772581bf77eb3873ff)
  include(${CMAKE_BINARY_DIR}/Assertion.cmake)

  assertion_add_test(test/check_coverage.cmake)
endif()

if(CHECK_COVERAGE_ENABLE_INSTALL)
  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    CheckCoverageConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
  )

  install(
    FILES
      cmake/CheckCoverage.cmake
      cmake/CheckCoverageConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/CheckCoverageConfigVersion.cmake
    DESTINATION lib/cmake/CheckCoverage
  )
endif()
