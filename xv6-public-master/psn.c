#include "Info_req.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(void)
{
    //struct proc *p;
	enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
	 static char *states[] = {
  		[UNUSED]    "UNUSED  ",
  		[EMBRYO]    "EMBRYO  ",
  		[SLEEPING]  "SLEEPING",
  		[RUNNABLE]  "RUNNABLE",
  		[RUNNING]   "RUNNING ",
  		[ZOMBIE]    "ZOMBIE  "
  		};
        //printf(1, "%s \t ","NAME");
		printf(1, "%s \t ","PID");
        printf(1, "%s \t ","STATE");
        printf(1, "\t %s \t ", "running-time");
        printf(1, "%s \t " ,"waiting-time");
        printf(1, "%s \t " ,"n_run");
        printf(1,"\n");

	struct Info_req InfoTable[NPROC];
	int numbers = getprocstable(InfoTable);
	for (int i = 0; i < numbers; i++)
	{
		printf(1, "%d \t " ,InfoTable[i].pid);
        printf(1, "%s \t ",states[InfoTable[i].state]);
        printf(1, "%d \t " ,InfoTable[i].rtime);
        printf(1, " \t %d \t " ,InfoTable[i].wtime);
        printf(1, "\t %d \t " ,InfoTable[i].n_run);
        
		printf(1, "\n");
	}
	exit();
}