#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
//#include "fcntl.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void
ls(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  exit();


  // int i;
  // char *path = "."; // Default path is the current directory

  // for (i = 1; i < argc; i++) {
  //   if (argv[i][0] == '-') {
  //     if (strcmp(argv[i], "-d") == 0) {
  //       // Handle -d option
  //     } else if (strcmp(argv[i], "-t") == 0) {
  //       // Handle -t option
  //     } else {
  //       printf(1, "Usage: dls [-d] [-t] [path]\n");
  //       exit();
  //     }
  //   } else {
  //     path = argv[i];
  //   }
  // }

  // int num_directories = 0;
  // int num_files = 0;

  // int dir = open(path, O_RDONLY);
  // if (dir < 0) {
  //   printf(2, "dls: cannot open %s\n", path);
  //   exit();
  // }

  // struct dirent de;
  // while (read(dir, &de, sizeof(de)) == sizeof(de)) {
  //   if (de.inum == 0)
  //     continue;

  //   // Determine whether the entry is a directory or a file based on the name
  //   if (de.name[0] == '.') {
  //     // Skip current directory (.) and parent directory (..) entries
  //     continue;
  //   } else if (de.name[strlen(de.name) - 1] == '/') {
  //     num_directories++;
  //   } else {
  //     num_files++;
  //   }
  // }

  // close(dir);

  // // Display the number of directories and files
  // printf(1, "Number of directories: %d\n", num_directories);
  // printf(1, "Number of files: %d\n", num_files);

  // return 0;
  // exit();
}
