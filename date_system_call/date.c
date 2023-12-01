#include "types.h"
#include "user.h"
#include "date.h"

int main(int argc, char *argv[])
{
  struct rtcdate r;
  if(gettime(&r))
  {
    printf(2,"date failed\n");
    exit();
  }
  printf(1,"current time : %d-%d-%d-%d %d:%d:%d\n",r.year,r.month,r.day,r.hour,r.minute,r.second);
  exit();
}
