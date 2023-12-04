#include "types.h"
#include "user.h"

#define BUFSIZE 256

int main(int argc, char *argv[]) {
    int num1, num2;
    char buf[BUFSIZE];

    printf(1, "Enter the first number: ");
    memset(buf, 0, BUFSIZE);
    read(0, buf, BUFSIZE - 1);
    num1 = atoi(buf);

    printf(1, "Enter the second number: ");
    memset(buf, 0, BUFSIZE);
    read(0, buf, BUFSIZE - 1);
    num2 = atoi(buf);

    int sum = num1 + num2;

    printf(1, "The sum of %d and %d is %d\n", num1, num2, sum);

    exit();
}
