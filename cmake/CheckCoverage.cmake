# MIT License
#
# Copyright (c) 2024-2025 Alfi Maulana
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
  target_compile_options("${TARGET}" PRIVATE --coverage -O0 -fno-exceptions)
  target_link_options("${TARGET}" PRIVATE --coverage)

  # Remove GCDA files every time the target is relinked.
  get_target_property(TARGET_BINARY_DIR "${TARGET}" BINARY_DIR)
  get_target_property(TARGET_SOURCES "${TARGET}" SOURCES)
  foreach(SOURCE ${TARGET_SOURCES})
    set(GCDA ${TARGET_BINARY_DIR}/CMakeFiles/${TARGET}.dir/${SOURCE}.gcda)
    add_custom_command(
      TARGET "${TARGET}" PRE_LINK
      COMMAND "${CMAKE_COMMAND}" -E rm -f "${GCDA}"
    )
  endforeach()
endfunction()
