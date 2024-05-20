function(configure_sample)
  cmake_parse_arguments(ARG "WITHOUT_COVERAGE_FLAGS" "" "" ${ARGN})
  message(STATUS "Configuring sample project")
  if(ARG_WITHOUT_COVERAGE_FLAGS)
    list(APPEND CONFIGURE_ARGS -D WITHOUT_COVERAGE_FLAGS=TRUE)
  endif()
  execute_process(
    COMMAND "${CMAKE_COMMAND}"
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
      ${CONFIGURE_ARGS}
      --fresh
      ${CMAKE_CURRENT_LIST_DIR}/sample
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to configure sample project")
  endif()
endfunction()

function(build_sample)
  message(STATUS "Building sample project")
  execute_process(
    COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to build sample project")
  endif()
endfunction()

function(test_sample)
  message(STATUS "Testing sample project")
  find_program(CTEST_PROGRAM ctest REQUIRED)
  execute_process(
    COMMAND "${CTEST_PROGRAM}"
      -C debug
      --test-dir ${CMAKE_CURRENT_LIST_DIR}/sample/build
      --no-tests=error
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to test sample project")
  endif()
endfunction()

function(check_sample_test_coverage)
  cmake_parse_arguments(ARG SHOULD_FAIL "" "" ${ARGN})

  message(STATUS "Getting sample project build information")
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -L -N ${CMAKE_CURRENT_LIST_DIR}/sample/build
    OUTPUT_VARIABLE OUT
  )
  string(REPLACE "\n" ";" VARS "${OUT}")
  foreach(VAR ${VARS})
    if(VAR STREQUAL MSVC:BOOL=1)
      message(WARNING "Skipping sample project test coverage check on MSVC")
      return()
    endif()
  endforeach()

  message(STATUS "Checking sample project test coverage")
  find_program(GCOVR_PROGRAM gcovr REQUIRED)
  execute_process(
    COMMAND "${GCOVR_PROGRAM}"
      --root ${CMAKE_CURRENT_LIST_DIR}/sample
      --fail-under-line 100
    RESULT_VARIABLE RES
  )
  if(ARG_SHOULD_FAIL AND RES EQUAL 0)
    message(FATAL_ERROR "Sample project test coverage check should be failed")
  elseif(NOT ARG_SHOULD_FAIL AND NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to check sample project test coverage")
  endif()
endfunction()

function("Check test coverage")
  configure_sample()
  build_sample()
  test_sample()
  check_sample_test_coverage()
endfunction()

function("Check test coverage without coverage flags")
  configure_sample(WITHOUT_COVERAGE_FLAGS)
  build_sample()
  test_sample()
  check_sample_test_coverage(SHOULD_FAIL)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND "${TEST_COMMAND}")
  message(FATAL_ERROR "Unable to find a command named '${TEST_COMMAND}'")
endif()

cmake_language(CALL "${TEST_COMMAND}")
