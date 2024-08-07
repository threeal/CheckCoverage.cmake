function(configure_sample)
  cmake_parse_arguments(PARSE_ARGV 0 ARG WITHOUT_COVERAGE_FLAGS "" "")
  section("configure sample project")
    if(ARG_WITHOUT_COVERAGE_FLAGS)
      list(APPEND CONFIGURE_ARGS -D WITHOUT_COVERAGE_FLAGS=TRUE)
    endif()
    assert_execute_process(
      "${CMAKE_COMMAND}"
        -B ${CMAKE_CURRENT_LIST_DIR}/sample/build
        ${CONFIGURE_ARGS}
        --fresh
        ${CMAKE_CURRENT_LIST_DIR}/sample)
  endsection()
endfunction()

function(build_sample)
  section("build sample project")
    assert_execute_process(
      "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_LIST_DIR}/sample/build)
  endsection()
endfunction()

function(test_sample)
  section("test sample project")
    find_program(CTEST_PROGRAM ctest REQUIRED)
    assert_execute_process(
      "${CTEST_PROGRAM}"
        -C debug
        --test-dir ${CMAKE_CURRENT_LIST_DIR}/sample/build
        --no-tests=error)
  endsection()
endfunction()

function(check_sample_test_coverage)
  cmake_parse_arguments(PARSE_ARGV 0 ARG SHOULD_FAIL "" "")

  section("check sample project test coverage")
    execute_process(
      COMMAND "${CMAKE_COMMAND}" -L -N ${CMAKE_CURRENT_LIST_DIR}/sample/build
      OUTPUT_VARIABLE OUT
    )
    string(REPLACE "\n" ";" VARS "${OUT}")
    foreach(VAR ${VARS})
      if(VAR STREQUAL MSVC:BOOL=1)
        message(WARNING "skipp sample project test coverage check on MSVC")
        return()
      endif()
    endforeach()

    find_program(GCOVR_PROGRAM gcovr REQUIRED)
    if(ARG_SHOULD_FAIL)
      assert_execute_process(
        COMMAND "${GCOVR_PROGRAM}"
          --root ${CMAKE_CURRENT_LIST_DIR}/sample
          --fail-under-line 100
        ERROR "failed minimum line coverage")
    else()
      assert_execute_process(
        "${GCOVR_PROGRAM}"
          --root ${CMAKE_CURRENT_LIST_DIR}/sample
          --fail-under-line 100)
    endif()
  endsection()
endfunction()

section("it should check test coverage")
  configure_sample()
  build_sample()
  test_sample()
  check_sample_test_coverage()
endsection()

section("it should check test coverage without coverage flags")
  configure_sample(WITHOUT_COVERAGE_FLAGS)
  build_sample()
  test_sample()
  check_sample_test_coverage(SHOULD_FAIL)
endsection()
