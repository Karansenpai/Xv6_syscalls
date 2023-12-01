#include "Info_req.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"


int main(void)
{
	enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
	 static char *states[] = {
  		[UNUSED]    "UNUSED  ",
  		[EMBRYO]    "EMBRYO  ",
  		[SLEEPING]  "SLEEPING",
  		[RUNNABLE]  "RUNNABLE",
  		[RUNNING]   "RUNNING ",
  		[ZOMBIE]    "ZOMBIE  "
  		};
		printf(1, "%s \t ","PID");
        #ifdef PBS
        printf(1, "%s \t ","Priority");
        #endif
        printf(1, "%s \t ","STATE");
        printf(1, "\t %s \t ", "running-time");
        printf(1, "%s \t " ,"waiting-time");
        printf(1, "%s \t " ,"n_run");
        #ifdef MLFQ
        printf(1, "%s " ,"cur_q");
        printf(1, "%s " ,"ticks[0]");
        printf(1, "%s " ,"ticks[1]");
        printf(1, "%s " ,"ticks[2]");
        printf(1, "%s " ,"ticks[3]");
        printf(1, "%s " ,"ticks[4]");
        #endif
        printf(1,"\n");

	struct Info_req InfoTable[NPROC];
	int numbers = getprocstable(InfoTable);
	for (int i = 0; i < numbers; i++)
	{
		printf(1, "%d \t " ,InfoTable[i].pid);
        #ifdef PBS
        printf(1, "%d " ,InfoTable[i].priority);
        #endif
        printf(1, "%s \t ",states[InfoTable[i].state]);
        printf(1, "%d \t " ,InfoTable[i].rtime);
        printf(1, " \t %d \t " ,InfoTable[i].wtime);
        printf(1, "\t %d \t " ,InfoTable[i].n_run);
        #ifdef MLFQ
        if(states[InfoTable[i].state]==states[3]||states[InfoTable[i].state]==states[4])
        printf(1, "%d " ,InfoTable[i].curq);
        else{
            printf(1, "-1 ");
        }
        printf(1, "%d " ,InfoTable[i].ticks[0]);
        printf(1, "%d " ,InfoTable[i].ticks[1]);
        printf(1, "%d " ,InfoTable[i].ticks[2]);
        printf(1, "%d " ,InfoTable[i].ticks[3]);
        printf(1, "%d " ,InfoTable[i].ticks[4]);
        #endif
		
		printf(1, "\n");
	}
	exit();
}