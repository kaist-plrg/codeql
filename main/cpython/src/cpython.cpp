#include <stdio.h>

int f(int arg) {
  return arg;
}

int main() {
  int x = f(42);
  printf("%d\n",x);
  printf("Hello, cpp!");
  return 0;
}
