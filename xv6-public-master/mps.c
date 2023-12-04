// #include "types.h"
// #include "stat.h"
// #include "user.h"

// int main(int argc, char *argv[]) {
//     int i, j;

//     for (i = 0; i < 5; i++) {
//         int pid = fork(); // Create a new child process
//         if (pid < 0) {
//             printf(2, "Fork failed!\n");
//         } else if (pid == 0) {
//             // This is the child process
//             for (j = 0; j < 10; j++) {
//                 printf(1, "Child %d is running...\n", getpid());
//                 for (int k = 0; k < 10000000; k++) {
//                     // Some dummy computation to consume CPU time
//                     int x = k * k;
//                     (void)x; // Avoid unused variable warning
//                 }
//             }
//             exit();
//         }
//     }

//     for (i = 0; i < 5; i++) {
//         wait(); // Wait for child processes to exit
//     }

//     exit();
// }
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int i;
   int n = atoi(argv[1]);
    for (i = 0; i < n; i++) {
        int pid = fork();
        if (pid < 0) {
            printf(2, "Fork failed!\n");
        } else if (pid == 0) {
            // This is the child process
            int j;
            for (j = 0; j < 4000000000; j=j+0.1) {
                // Some dummy computation to consume CPU time
                int x = j * j;
                (void)x; // Avoid unused variable warning
            }
            exit();
        }
    }

    for (i = 0; i < 5; i++) {
        wait(); // Wait for child processes to exit
    }

    exit();
}
