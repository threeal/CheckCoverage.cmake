#include <fibonacci.hpp>

int main() {
  if (fibonacci_sequence(0) != std::vector<int>{}) return 1;
  if (fibonacci_sequence(1) != std::vector<int>{1}) return 1;
  if (fibonacci_sequence(5) != std::vector<int>{1, 1, 2, 3, 5}) return 1;
  return 0;
}
