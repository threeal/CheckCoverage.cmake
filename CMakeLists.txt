cmake_minimum_required(VERSION 3.21)

project(
  CheckCoverage
  VERSION 0.1.0
  DESCRIPTION "Check for test coverage in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/CheckCoverage.cmake
  LANGUAGES NONE
)

option(CHECK_COVERAGE_ENABLE_INSTALL "Enable install targets."
  "${PROJECT_IS_TOP_LEVEL}")

include(cmake/CheckCoverage.cmake)

if(PROJECT_IS_TOP_LEVEL AND BUILD_TESTING)
  enable_testing()
  add_subdirectory(test)
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
