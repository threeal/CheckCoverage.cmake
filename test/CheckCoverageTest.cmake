# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

function(configure_sample)
  message(STATUS "Configuring sample project")
  execute_process(
    COMMAND ${CMAKE_COMMAND}
      -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
      -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
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
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_LIST_DIR}/sample/build
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
    COMMAND ${CTEST_PROGRAM}
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
  message(STATUS "Getting sample project build information")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -L -N ${CMAKE_CURRENT_LIST_DIR}/sample/build
    OUTPUT_VARIABLE OUT
  )
  string(REPLACE "\n" ";" VARS ${OUT})
  foreach(VAR ${VARS})
    if(VAR STREQUAL MSVC:BOOL=1)
      message(WARNING "Skipping sample project test coverage check on MSVC")
      return()
    endif()
  endforeach()

  message(STATUS "Checking sample project test coverage")
  find_program(GCOVR_PROGRAM gcovr REQUIRED)
  execute_process(
    COMMAND ${GCOVR_PROGRAM}
      --root ${CMAKE_CURRENT_LIST_DIR}/sample
      --fail-under-line 100
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to check sample project test coverage")
  endif()
endfunction()

if("Check test coverage" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  configure_sample()
  build_sample()
  test_sample()
  check_sample_test_coverage()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
