# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Function to enable test coverage check on a specific target.
# Arguments:
#   - TARGET: The target for which to enable test coverage check.
function(target_check_coverage TARGET)
  if(MSVC)
    message(WARNING "Test coverage check is not available on MSVC")
    return()
  endif()

  # Append options for enabling test coverage check.
  target_compile_options(${TARGET} PRIVATE --coverage -O0 -fno-exceptions)
  target_link_options(${TARGET} PRIVATE --coverage)

  # Remove GCDA files every time the target is relinked.
  get_target_property(TARGET_BINARY_DIR ${TARGET} BINARY_DIR)
  get_target_property(TARGET_SOURCES ${TARGET} SOURCES)
  foreach(SOURCE ${TARGET_SOURCES})
    set(GCDA ${TARGET_BINARY_DIR}/CMakeFiles/${TARGET}.dir/${SOURCE}.gcda)
    add_custom_command(
      TARGET ${TARGET} PRE_LINK
      COMMAND ${CMAKE_COMMAND} -E rm -f ${GCDA}
    )
  endforeach()
endfunction()
