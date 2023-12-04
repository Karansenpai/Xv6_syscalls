#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int a, b,c;
  if(argc < 3){
    printf(2,"Error! enter 2 numbers\n");
    exit();
  }
  a = atoi(argv[1]);
  b = atoi(argv[2]);
  c = a > b ? a : b;
  printf(1,"Greater of %d and %d is = %d\n",a,b,c);
  exit();
}