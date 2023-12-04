#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
  struct psinfo psinfo;

  // Call the new system call to get process information
  if (psinfo_syscall(&psinfo) < 0) {
    printf(1, "Error: psinfo_syscall failed\n");
    exit();
  }

  // Display process information
  printf(1, "PID: %d\n", psinfo.pid);
  printf(1, "PPID: %d\n", psinfo.ppid);
  printf(1, "State: %s\n", psinfo.state);
  printf(1, "Running Time: %d ticks\n", psinfo.runtime);
  printf(1, "Waiting Time: %d ticks\n", psinfo.wtime);

  exit();
}
