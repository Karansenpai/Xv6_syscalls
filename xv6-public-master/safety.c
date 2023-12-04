// safety.c

#include "types.h"
#include "defs.h"
#include "param.h"
#include "proc.h"
int resource_available[NUM_RESOURCE_TYPES];
//int resource_available[NUM_RESOURCE_TYPES] = {10, 10, 10};

// Initialize the available resources here
void init_resource_manager(void) {
  for (int i = 0; i < NUM_RESOURCE_TYPES; i++) {
    resource_available[i] = 10; // Set an initial count
  }
}
int is_safe(int request[NUM_RESOURCE_TYPES], int pid) {
  // Check if granting the request leads to a safe state
  struct proc* p = myproc();

  // Temporarily allocate resources for the request
  for (int i = 0; i < NUM_RESOURCE_TYPES; i++) {
    if (request[i] > p->max_claim[i] - p->allocated[i])
      return 0; // Request exceeds maximum claim
    if (request[i] > resource_available[i])
      return 0; // Insufficient resources
  }

  // Simulate resource allocation and deallocation to check safety
  // (You may need to implement more complex logic here)

  return 1; // Request is safe
}

int request_resources(int pid, int request[NUM_RESOURCE_TYPES]) {
  // Check if the request is safe
  if (is_safe(request, pid)) {
    // Allocate the resources
    struct proc* p = get_proc_by_pid(pid);
    for (int i = 0; i < NUM_RESOURCE_TYPES; i++) {
      p->allocated[i] += request[i];
      resource_available[i] -= request[i];
    }
    return 0; // Request granted
  } else {
    return -1; // Request denied
  }
}

int release_resources(int pid, int release[NUM_RESOURCE_TYPES]) {
  // Release the allocated resources
  struct proc* p = get_proc_by_pid(pid);
  for (int i = 0; i < NUM_RESOURCE_TYPES; i++) {
    p->allocated[i] -= release[i];
    resource_available[i] += release[i];
  }
  return 0; // Resources released
}