function(add_cmake_test FILE)
  math(EXPR STOP "${ARGC} - 1")
  foreach(I RANGE 1 "${STOP}")
    add_test(
      NAME "${ARGV${I}}"
      COMMAND "${CMAKE_COMMAND}"
        -D "TEST_COMMAND=${ARGV${I}}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  CheckCoverageTest.cmake
  "Check test coverage"
  "Check test coverage without coverage flags"
)
