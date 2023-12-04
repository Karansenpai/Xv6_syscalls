#ifndef _INFO_REQ_H_
#define _INFO_REQ_H_
#include "types.h"

struct Info_req{
   // char name[16];
	int pid;
	int state;
    int rtime;
    int priority;
    int curq;
    int n_run;
    int wtime;
    int ticks[5];
};
#endif