Done By :-

Aditya Singh IIT2022125
Rishabh Kumar IIT2022131
Karan Singh IIT2022132

FOR LINUX

1-Download qemu/aqemu (Hardware simulator)
2-Then From Terminal go to the xv6-public-master folder given here
3-Write "make clean" then "make qemu" then "make"



FOR MAC

Either Use Xv6-master-public for mac

or

1-Dowload Docker Desktop
2-Go to Docker hub and make an account
3-Install VS-Code (For convienience can be done without vs-code in terminal also)
4-Now go to the link "https://github.com/boringlily/xv6-docker-compile"
5-Instead of using the xv6-patched given in it use the one provided here
5-Follow the steps FORM 3 ONWARDS 
6-Write "make clean" then "make qemu-nox".
NOTE-"make qemu" wont work only make qemu-nox works which runs in terminal


NEW CODES THAT ARE ADDED ARE:-
ps.c,psn.c -tell process states
nice.c,setP.c -change priority
dpro.c -create -child process given by user
mps.c -create automatic child process and use cpu cycles
sum.c,prod.c,sub.c,div.c,max.c -find them by giving input at time of writing in command line
us.c - find sum by taking input after running 
date.c 
count.c 
time.c -show runtime,wait time



NOTE -(If at running make there is no error while running make qemu/make qemu-nox gives error then there is some issue with the MAKEFILE 
       spacing matters a lot and in it)
     -(if you cant start the container after stopping it in extension in vs code then check that Docker Desktop is running)  
