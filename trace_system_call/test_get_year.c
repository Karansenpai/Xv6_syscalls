
// User program to test get_year system call

#include "types.h"
#include "stat.h"
#include "user.h"
int main(void)
{

  printf(1, "Unix was released in the year %d\n",getyear());
  
  exit();

}

