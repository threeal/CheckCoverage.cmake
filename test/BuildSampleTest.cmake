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

if("Build sample project" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
  configure_sample()
  build_sample()
  test_sample()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
