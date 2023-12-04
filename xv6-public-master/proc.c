#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "Info_req.h"
#define NULL 0                           //! I use NULL..
#define DEFAULT_PRIORITY_PBS 60          //! Default priority
// int max_tick_of_q[5] = {1, 2, 4, 8, 16}; //! Max time slices allowed in queues
// //int q_max_time[5] = {1, 2, 3, 4, 5};     //! Max time  at each queue - good for small number for procs (benchmark)
// int q_max_time[5] = {1, 5, 10, 15, 20}; //medium number of procs, good for my tests
// //int q_max_time[5] = {1, 20, 30, 40, 120}; //Good for high number of procs

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
void updateRunsandOthers() //! This is called during clock tick to update ticks of PROCS... called from trap.c
{
  acquire(&ptable.lock);
  for (struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {

    if (p->state == RUNNING)
    {
      p->rtime++;             //increase rtime
      p->q_ticks[p->queue]++; // increase q_ticks
      p->curr_q_ticks++;      //increase ticks in current queue
    }
    if (p->state == SLEEPING)
    {
      p->iotime++;           //increase iotime
      p->lastWorkingticks++; //increase last working ticks - it is working basically I/O
    }
  }
  release(&ptable.lock);
}
void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->priority = 10;  //Default Priority of a process is set to be 10
  // Initialize time slice fields
   p->ctime = ticks;
  p->rtime = 0;
  p->etime = 0;
  p->iotime = 0;
  p->priority = DEFAULT_PRIORITY_PBS;
  p->n_run = 0;
  p->queue = 0;
  p->curr_q_ticks = 0;
  p->lastWorkingticks = ticks;
  for (int i = 0; i < 5; i++)
    p->q_ticks[i] = 0;

  p->timeslice = 0;
  p->max_timeslice = 10;  // Set the maximum time slice (adjust as needed)
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }
  

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  //! Assignment - here the process ends.. so we have to update etime
  curproc->etime = ticks;
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
//! Assignment - waitx Implementation
int waitx(int *wtime, int *rtime)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        *rtime = p->rtime; //! update rtime and wtime passed as arguments
        *wtime = p->etime - (p->ctime + p->rtime + p->iotime);
        p->etime = 0;
        p->ctime = 0;
        p->rtime = 0;
        p->iotime = 0;
        p->lastWorkingticks = 0;
        p->n_run = 0;
        p->priority = 0;
        p->q_ticks[0] = p->q_ticks[1] = p->q_ticks[2] = p->q_ticks[3] = p->q_ticks[4] = 0;
        p->curr_q_ticks = 0;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
  }
}


//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
// void
// scheduler(void)
// {
//   struct proc *p;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     // Loop over process table looking for process to run.
//     acquire(&ptable.lock);
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       if(p->state != RUNNABLE)
//         continue;

//       // Switch to chosen process.  It is the process's job
//       // to release ptable.lock and then reacquire it
//       // before jumping back to us.
//       c->proc = p;
//       switchuvm(p);
//       p->state = RUNNING;

//       swtch(&(c->scheduler), p->context);
//       switchkvm();

//       // Process is done running for now.
//       // It should have changed its p->state before coming back.
//       c->proc = 0;
//     }
//     release(&ptable.lock);

//   }
// }


//Priority based RR
// void
// scheduler(void)
// {
//   struct proc *p, *p1;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();
//     struct proc *highP;
//     // Loop over process table looking for process to run.
//     acquire(&ptable.lock);
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       if(p->state != RUNNABLE)
//         continue;

//       // Switch to chosen process.  It is the process's job
//       // to release ptable.lock and then reacquire it
//       // before jumping back to us.
//       highP = p;
//       //choose one with highest priority
//       for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
// 	if(p1->state != RUNNABLE)
// 	  continue;
// 	if(highP->priority > p1->priority)   //larger value, lower priority
// 	  highP = p1;
//       }
//       p = highP;
//       c->proc = p;
//       switchuvm(p);
//       p->state = RUNNING;

//       swtch(&(c->scheduler), p->context);
//       switchkvm();

//       // Process is done running for now.
//       // It should have changed its p->state before coming back.
//       c->proc = 0;
//     }
//     release(&ptable.lock);

//   }
// }


void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu(); // Define 'c' as a pointer to the CPU structure

  c->proc = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->n_run++;
      p->state = RUNNING;
      p->lastWorkingticks = ticks;

      swtch(&(c->scheduler), p->context);
      switchkvm();
      p->lastWorkingticks = ticks;

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
}
}




// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
cps()
{
struct proc *p;
//Enables interrupts on this processor.
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
cprintf("name \t pid \t state \t \tpriority \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  if(p->state == SLEEPING)
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNING)
 	  cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNABLE)
 	  cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
}
release(&ptable.lock);
return 22;
}


// int
// cps()
// {
// struct proc *p;
// //Enables interrupts on this processor.
// sti();

// //Loop over process table looking for process with pid.
// acquire(&ptable.lock);
// cprintf("name \t pid \t parent pid \t state \t \tpriority \t running time \t n_runs \t waiting time\n");
// for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//   if(p->pid == 1){
//     if(p->state == SLEEPING)
// 	  cprintf("%s \t %d \t %d \t SLEEPING \t %d \t\t %d \t\t %d \t \t%d \n ", p->name,p->pid,p->parent->pid,p->priority,p->rtime,p->n_run,(ticks - p->lastWorkingticks)*10);
//   }
// else{
//   if(p->state == SLEEPING)
// 	  cprintf("%s \t %d \t %d \t \t SLEEPING \t %d \t\t %d \t\t %d \t\t%d\n ", p->name,p->pid,p->parent->pid,p->priority,p->rtime,p->n_run,(ticks - p->lastWorkingticks)*10);
// 	else if(p->state == RUNNING)
//  	  cprintf("%s \t %d \t %d \t \t RUNNING \t %d \t\t %d \t\t %d \t \t%d\n ", p->name,p->pid,p->parent->pid,p->priority,p->rtime,p->n_run,(ticks - p->lastWorkingticks)*10);
// 	else if(p->state == RUNNABLE)
//  	  cprintf("%s \t %d \t %d \t \t RUNNABLE \t %d \t\t %d \t\t%d \t\t%d\n ", p->name,p->pid,p->parent->pid,p->priority,p->rtime,p->n_run,(ticks - p->lastWorkingticks)*10);
// }
// }
// release(&ptable.lock);
// return 22;
// }

int 
chpr(int pid, int priority)
{
	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  if(p->pid == pid){
			p->priority = priority;
			break;
		}
	}
	release(&ptable.lock);
	return pid;
}

// ! System call for ps
int getprocstable(struct Info_req *InfoTable)
{
  struct proc *p;
  int count = 0;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
    {
      continue;
    }
//    memset(InfoTable[count].name, 0, sizeof(InfoTable[count].name)); // Clear the `name` field.
//     strncpy(InfoTable[count].name, p->name, sizeof(InfoTable[count].name) - 1); // Copy the process name.
// InfoTable[count].name[sizeof(InfoTable[count].name) - 1] = '\0'; // Ensure null-termination

    InfoTable[count].pid = p->pid;
    InfoTable[count].state = p->state;
    InfoTable[count].priority = p->priority;
    InfoTable[count].rtime = p->rtime;
    InfoTable[count].ticks[0] = p->q_ticks[0];
    InfoTable[count].ticks[1] = p->q_ticks[1];
    InfoTable[count].ticks[2] = p->q_ticks[2];
    InfoTable[count].ticks[3] = p->q_ticks[3];
    InfoTable[count].ticks[4] = p->q_ticks[4];
    InfoTable[count].curq = p->queue;
    InfoTable[count].wtime = (ticks - p->lastWorkingticks)*10;
    InfoTable[count].n_run = p->n_run;
    
    count++;
  }
  release(&ptable.lock);
  p = 0;
  return count;
}

int
setp(int new_priority, int pid)
{

  if (new_priority <= -1 || new_priority > 100) //error handling
    return -1;
  int returnValue = -1; //error code
  int shouldYield = 0;  //variable which tells if it should yield or not
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      acquire(&ptable.lock);
      returnValue = p->priority;
      p->priority = new_priority;
      if (returnValue > new_priority) //in this case yield
        shouldYield = 1;              //may be that process has a chance at this CPU so yield...
      release(&ptable.lock);
      break;
    }
  }
  if (shouldYield)
  {
    yield(); //yield
  }
  return returnValue; //return value of set_priority
}

int
getcount()
{
  struct proc *p;
//Loop over process table looking for process with pid.
acquire(&ptable.lock);
int running =0;
int runnable =0;
int sleeping =0;
int zombie =0;
int unused =0;
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  if(p->state == RUNNING)
   running++;
  else if(p->state == RUNNABLE)
   runnable++;
  else if(p->state == SLEEPING)
   sleeping++;
  else if(p->state == ZOMBIE)
   zombie++;
  else if(p->state == UNUSED)
  unused++;
}
cprintf("Number of Process Currently RUNNING are :- %d \n", running);
cprintf("Number of Process Currently RUNNABLE are :- %d \n", runnable);
cprintf("Number of Process Currently SLEEPING are :- %d \n", sleeping);
cprintf("Number of Process Currently ZOMBIE are :- %d \n", zombie);
cprintf("Number of Process Currently UNUSED are :- %d \n", unused);
release(&ptable.lock);
return 28;
}