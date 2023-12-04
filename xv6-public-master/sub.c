#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int a, b;
  if(argc < 3){
    printf(2,"Error! enter 2 numbers\n");
    exit();
  }
  a = atoi(argv[1]);
  b = atoi(argv[2]);
  printf(1,"Subtraction of %d and %d is = %d\n",a,b,a-b);
  exit();
}