cmake_minimum_required(VERSION 3.19)

project(
  CheckCoverage
  VERSION 0.1.0
  DESCRIPTION "Check for test coverage in your CMake project"
  HOMEPAGE_URL https://github.com/threeal/CheckCoverage.cmake
  LANGUAGES NONE
)

if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(SUBPROJECT TRUE)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
if(SUBPROJECT)
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endif()

if(NOT SUBPROJECT)
  if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
  endif()

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    CheckCoverageConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
  )

  install(
    FILES
      cmake/CheckCoverage.cmake
      cmake/MkdirRecursive.cmake
      cmake/CheckCoverageConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/CheckCoverageConfigVersion.cmake
    DESTINATION lib/cmake/CheckCoverage
  )
endif()
