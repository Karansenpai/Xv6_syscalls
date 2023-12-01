
_load:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  while (wait() != -1)
    ;
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp

  if (argc != 3)
  13:	83 39 03             	cmpl   $0x3,(%ecx)
{
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  if (argc != 3)
  19:	74 13                	je     2e <main+0x2e>
  {
    printf(1, "Usage <Test Type Number> <Number of Procs>\n");
  1b:	52                   	push   %edx
  1c:	52                   	push   %edx
  1d:	68 9c 0d 00 00       	push   $0xd9c
  22:	6a 01                	push   $0x1
  24:	e8 f7 09 00 00       	call   a20 <printf>
    exit();
  29:	e8 94 08 00 00       	call   8c2 <exit>
  }
  int n = atoi(argv[2]);
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	ff 73 08             	pushl  0x8(%ebx)
  34:	e8 17 08 00 00       	call   850 <atoi>
  39:	89 c6                	mov    %eax,%esi
  int test = atoi(argv[1]);
  3b:	58                   	pop    %eax
  3c:	ff 73 04             	pushl  0x4(%ebx)
  3f:	e8 0c 08 00 00       	call   850 <atoi>
  switch (test)
  44:	83 e8 01             	sub    $0x1,%eax
  47:	83 c4 10             	add    $0x10,%esp
  4a:	83 f8 06             	cmp    $0x6,%eax
  4d:	77 13                	ja     62 <main+0x62>
  4f:	ff 24 85 c8 0d 00 00 	jmp    *0xdc8(,%eax,4)
    break;
  case 6:
    AdvancedBenchmark(n); // A modified version of given Benchmark
    break;
  case 7:
    ShowFailureofFCFS(n); // Here we show why FCFS fails if many Process IO Heavy and they come first. First n/2 are IO bound and n-n/2 is CPU bound but IO is made first
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	56                   	push   %esi
  5a:	e8 e1 04 00 00       	call   540 <ShowFailureofFCFS>
    break;
  5f:	83 c4 10             	add    $0x10,%esp
  }

  exit();
  62:	e8 5b 08 00 00       	call   8c2 <exit>
    AdvancedBenchmark(n); // A modified version of given Benchmark
  67:	83 ec 0c             	sub    $0xc,%esp
  6a:	56                   	push   %esi
  6b:	e8 70 00 00 00       	call   e0 <AdvancedBenchmark>
    break;
  70:	83 c4 10             	add    $0x10,%esp
  73:	eb ed                	jmp    62 <main+0x62>
    benchmark(n); //normal benchmark
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	56                   	push   %esi
  79:	e8 b2 01 00 00       	call   230 <benchmark>
    break;
  7e:	83 c4 10             	add    $0x10,%esp
  81:	eb df                	jmp    62 <main+0x62>
    cpuBound(n); //benchmark for n CPU Bound Processes
  83:	83 ec 0c             	sub    $0xc,%esp
  86:	56                   	push   %esi
  87:	e8 84 02 00 00       	call   310 <cpuBound>
    break;
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb d1                	jmp    62 <main+0x62>
    IoBound(n); //n IO Bound Processes
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	56                   	push   %esi
  95:	e8 d6 02 00 00       	call   370 <IoBound>
    break;
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	eb c3                	jmp    62 <main+0x62>
    IntelligentProcess(n); //The intelligent Process test... A test which gives up CPU during its calcs to stay in higher Queue.. Only useful for MLFQ Testing
  9f:	83 ec 0c             	sub    $0xc,%esp
  a2:	56                   	push   %esi
  a3:	e8 58 03 00 00       	call   400 <IntelligentProcess>
    break;
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	eb b5                	jmp    62 <main+0x62>
    Mixture(n); //Mixture of IO Bound  and CPU Bound Process
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	56                   	push   %esi
  b1:	e8 ea 03 00 00       	call   4a0 <Mixture>
    break;
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	eb a7                	jmp    62 <main+0x62>
  bb:	66 90                	xchg   %ax,%ax
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <IntelligentProcess.part.2>:
void cpuBound(int n)
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 08             	sub    $0x8,%esp
  c6:	8d 76 00             	lea    0x0(%esi),%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while (wait() != -1)
  d0:	e8 f5 07 00 00       	call   8ca <wait>
  d5:	83 f8 ff             	cmp    $0xffffffff,%eax
  d8:	75 f6                	jne    d0 <IntelligentProcess.part.2+0x10>
}
  da:	c9                   	leave  
  db:	c3                   	ret    
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000e0 <AdvancedBenchmark>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	83 ec 2c             	sub    $0x2c,%esp
  e9:	8b 75 08             	mov    0x8(%ebp),%esi
  for (j = 0; j < n; j++)
  ec:	85 f6                	test   %esi,%esi
  ee:	7e 50                	jle    140 <AdvancedBenchmark+0x60>
  f0:	31 db                	xor    %ebx,%ebx
      set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
  f2:	bf 50 00 00 00       	mov    $0x50,%edi
  f7:	eb 21                	jmp    11a <AdvancedBenchmark+0x3a>
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (pid == 0)
 100:	74 62                	je     164 <AdvancedBenchmark+0x84>
      set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
 102:	83 ec 08             	sub    $0x8,%esp
 105:	50                   	push   %eax
 106:	89 f8                	mov    %edi,%eax
 108:	29 d8                	sub    %ebx,%eax
  for (j = 0; j < n; j++)
 10a:	83 c3 01             	add    $0x1,%ebx
      set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
 10d:	50                   	push   %eax
 10e:	e8 5f 08 00 00       	call   972 <set_priority>
 113:	83 c4 10             	add    $0x10,%esp
  for (j = 0; j < n; j++)
 116:	39 de                	cmp    %ebx,%esi
 118:	74 26                	je     140 <AdvancedBenchmark+0x60>
    int pid = fork();
 11a:	e8 9b 07 00 00       	call   8ba <fork>
    if (pid < 0)
 11f:	85 c0                	test   %eax,%eax
 121:	79 dd                	jns    100 <AdvancedBenchmark+0x20>
      printf(1, "Fork failed\n");
 123:	83 ec 08             	sub    $0x8,%esp
  for (j = 0; j < n; j++)
 126:	83 c3 01             	add    $0x1,%ebx
      printf(1, "Fork failed\n");
 129:	68 78 0d 00 00       	push   $0xd78
 12e:	6a 01                	push   $0x1
 130:	e8 eb 08 00 00       	call   a20 <printf>
      continue;
 135:	83 c4 10             	add    $0x10,%esp
  for (j = 0; j < n; j++)
 138:	39 de                	cmp    %ebx,%esi
 13a:	75 de                	jne    11a <AdvancedBenchmark+0x3a>
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (j = 0; j < n + 5; j++)
 140:	83 fe fc             	cmp    $0xfffffffc,%esi
 143:	7c 17                	jl     15c <AdvancedBenchmark+0x7c>
 145:	83 c6 05             	add    $0x5,%esi
 148:	31 db                	xor    %ebx,%ebx
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 150:	83 c3 01             	add    $0x1,%ebx
    wait();
 153:	e8 72 07 00 00       	call   8ca <wait>
  for (j = 0; j < n + 5; j++)
 158:	39 de                	cmp    %ebx,%esi
 15a:	75 f4                	jne    150 <AdvancedBenchmark+0x70>
}
 15c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15f:	5b                   	pop    %ebx
 160:	5e                   	pop    %esi
 161:	5f                   	pop    %edi
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
      for (volatile int k = 0; k < n; k++)
 164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 16b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 16e:	39 c6                	cmp    %eax,%esi
 170:	0f 8e 97 00 00 00    	jle    20d <AdvancedBenchmark+0x12d>
          sleep(200 + j * 10 + k * 5); //io time
 176:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
            if (i % 1000000 == 0)
 179:	bf 83 de 1b 43       	mov    $0x431bde83,%edi
          sleep(200 + j * 10 + k * 5); //io time
 17e:	8d 84 00 c8 00 00 00 	lea    0xc8(%eax,%eax,1),%eax
 185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 188:	eb 2e                	jmp    1b8 <AdvancedBenchmark+0xd8>
 18a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	8d 04 80             	lea    (%eax,%eax,4),%eax
 193:	03 45 d4             	add    -0x2c(%ebp),%eax
 196:	50                   	push   %eax
 197:	e8 c6 07 00 00       	call   962 <sleep>
          i = i ^ 1;
 19c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	83 f0 01             	xor    $0x1,%eax
 1a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for (volatile int k = 0; k < n; k++)
 1a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ab:	83 c0 01             	add    $0x1,%eax
 1ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b4:	39 f0                	cmp    %esi,%eax
 1b6:	7d 55                	jge    20d <AdvancedBenchmark+0x12d>
        if (k <= j)
 1b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1bb:	39 d8                	cmp    %ebx,%eax
 1bd:	7e cb                	jle    18a <AdvancedBenchmark+0xaa>
          for (i = 0; i < 100000000; i++)
 1bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 1c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1c9:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 1ce:	7f d8                	jg     1a8 <AdvancedBenchmark+0xc8>
            if (i % 1000000 == 0)
 1d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	f7 ef                	imul   %edi
 1d7:	89 c8                	mov    %ecx,%eax
 1d9:	c1 f8 1f             	sar    $0x1f,%eax
 1dc:	c1 fa 12             	sar    $0x12,%edx
 1df:	29 c2                	sub    %eax,%edx
 1e1:	69 c2 40 42 0f 00    	imul   $0xf4240,%edx,%eax
 1e7:	39 c1                	cmp    %eax,%ecx
 1e9:	75 0d                	jne    1f8 <AdvancedBenchmark+0x118>
              sleep(10);
 1eb:	83 ec 0c             	sub    $0xc,%esp
 1ee:	6a 0a                	push   $0xa
 1f0:	e8 6d 07 00 00       	call   962 <sleep>
 1f5:	83 c4 10             	add    $0x10,%esp
          for (i = 0; i < 100000000; i++)
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	83 c0 01             	add    $0x1,%eax
 1fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
 201:	8b 45 e0             	mov    -0x20(%ebp),%eax
 204:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 209:	7e c5                	jle    1d0 <AdvancedBenchmark+0xf0>
 20b:	eb 9b                	jmp    1a8 <AdvancedBenchmark+0xc8>
        printf(1, "Process: %d Finished\n", j);
 20d:	83 ec 04             	sub    $0x4,%esp
 210:	53                   	push   %ebx
 211:	68 85 0d 00 00       	push   $0xd85
 216:	6a 01                	push   $0x1
 218:	e8 03 08 00 00       	call   a20 <printf>
      exit();
 21d:	e8 a0 06 00 00       	call   8c2 <exit>
 222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <benchmark>:
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	83 ec 10             	sub    $0x10,%esp
 238:	8b 75 08             	mov    0x8(%ebp),%esi
  for (j = 0; j < n; j++)
 23b:	85 f6                	test   %esi,%esi
 23d:	7e 39                	jle    278 <benchmark+0x48>
 23f:	31 db                	xor    %ebx,%ebx
 241:	eb 0e                	jmp    251 <benchmark+0x21>
 243:	90                   	nop
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (pid == 0)
 248:	74 51                	je     29b <benchmark+0x6b>
  for (j = 0; j < n; j++)
 24a:	83 c3 01             	add    $0x1,%ebx
 24d:	39 de                	cmp    %ebx,%esi
 24f:	74 27                	je     278 <benchmark+0x48>
    int pid = fork();
 251:	e8 64 06 00 00       	call   8ba <fork>
    if (pid < 0)
 256:	85 c0                	test   %eax,%eax
 258:	79 ee                	jns    248 <benchmark+0x18>
      printf(1, "Fork failed\n");
 25a:	83 ec 08             	sub    $0x8,%esp
  for (j = 0; j < n; j++)
 25d:	83 c3 01             	add    $0x1,%ebx
      printf(1, "Fork failed\n");
 260:	68 78 0d 00 00       	push   $0xd78
 265:	6a 01                	push   $0x1
 267:	e8 b4 07 00 00       	call   a20 <printf>
      continue;
 26c:	83 c4 10             	add    $0x10,%esp
  for (j = 0; j < n; j++)
 26f:	39 de                	cmp    %ebx,%esi
 271:	75 de                	jne    251 <benchmark+0x21>
 273:	90                   	nop
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (j = 0; j < n + 5; j++)
 278:	83 fe fc             	cmp    $0xfffffffc,%esi
 27b:	7c 17                	jl     294 <benchmark+0x64>
 27d:	83 c6 05             	add    $0x5,%esi
 280:	31 db                	xor    %ebx,%ebx
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 288:	83 c3 01             	add    $0x1,%ebx
    wait();
 28b:	e8 3a 06 00 00       	call   8ca <wait>
  for (j = 0; j < n + 5; j++)
 290:	39 de                	cmp    %ebx,%esi
 292:	75 f4                	jne    288 <benchmark+0x58>
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	5b                   	pop    %ebx
 298:	5e                   	pop    %esi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
      for (volatile int k = 0; k < n; k++)
 29b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a5:	39 c6                	cmp    %eax,%esi
 2a7:	7f 24                	jg     2cd <benchmark+0x9d>
 2a9:	eb 4f                	jmp    2fa <benchmark+0xca>
 2ab:	90                   	nop
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          sleep(5); // Shorter I/O time
 2b0:	83 ec 0c             	sub    $0xc,%esp
 2b3:	6a 05                	push   $0x5
 2b5:	e8 a8 06 00 00       	call   962 <sleep>
 2ba:	83 c4 10             	add    $0x10,%esp
      for (volatile int k = 0; k < n; k++)
 2bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c0:	83 c0 01             	add    $0x1,%eax
 2c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 2c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c9:	39 f0                	cmp    %esi,%eax
 2cb:	7d 2d                	jge    2fa <benchmark+0xca>
        if (k <= j)
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	39 d8                	cmp    %ebx,%eax
 2d2:	7e dc                	jle    2b0 <benchmark+0x80>
          for (i = 0; i < 100000000; i++)
 2d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2de:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 2e3:	7f d8                	jg     2bd <benchmark+0x8d>
 2e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2e8:	83 c0 01             	add    $0x1,%eax
 2eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2f1:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 2f6:	7e ed                	jle    2e5 <benchmark+0xb5>
 2f8:	eb c3                	jmp    2bd <benchmark+0x8d>
        printf(1, "Process: %d Finished\n", j);
 2fa:	83 ec 04             	sub    $0x4,%esp
 2fd:	53                   	push   %ebx
 2fe:	68 85 0d 00 00       	push   $0xd85
 303:	6a 01                	push   $0x1
 305:	e8 16 07 00 00       	call   a20 <printf>
      exit();
 30a:	e8 b3 05 00 00       	call   8c2 <exit>
 30f:	90                   	nop

00000310 <cpuBound>:
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
 315:	8b 75 08             	mov    0x8(%ebp),%esi
  for (int i = 0; i < n; i++)
 318:	85 f6                	test   %esi,%esi
 31a:	7e 14                	jle    330 <cpuBound+0x20>
 31c:	31 db                	xor    %ebx,%ebx
 31e:	66 90                	xchg   %ax,%ax
    int pid = fork();
 320:	e8 95 05 00 00       	call   8ba <fork>
    if (pid == 0)
 325:	85 c0                	test   %eax,%eax
 327:	74 12                	je     33b <cpuBound+0x2b>
  for (int i = 0; i < n; i++)
 329:	83 c3 01             	add    $0x1,%ebx
 32c:	39 de                	cmp    %ebx,%esi
 32e:	75 f0                	jne    320 <cpuBound+0x10>
}
 330:	8d 65 f8             	lea    -0x8(%ebp),%esp
 333:	5b                   	pop    %ebx
 334:	5e                   	pop    %esi
 335:	5d                   	pop    %ebp
 336:	e9 85 fd ff ff       	jmp    c0 <IntelligentProcess.part.2>
      for (double z = 0; z < 1000000.0; z += 0.01)
 33b:	d9 ee                	fldz   
 33d:	dd 05 e8 0d 00 00    	fldl   0xde8
 343:	dc c1                	fadd   %st,%st(1)
 345:	d9 05 f0 0d 00 00    	flds   0xdf0
 34b:	df ea                	fucomip %st(2),%st
 34d:	77 f4                	ja     343 <cpuBound+0x33>
 34f:	dd d8                	fstp   %st(0)
 351:	dd d8                	fstp   %st(0)
        printf(1, "Process: %d Finished\n", i);
 353:	83 ec 04             	sub    $0x4,%esp
 356:	53                   	push   %ebx
 357:	68 85 0d 00 00       	push   $0xd85
 35c:	6a 01                	push   $0x1
 35e:	e8 bd 06 00 00       	call   a20 <printf>
      exit(); //bye bye
 363:	e8 5a 05 00 00       	call   8c2 <exit>
 368:	90                   	nop
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000370 <IoBound>:
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
 376:	83 ec 1c             	sub    $0x1c,%esp
 379:	8b 75 08             	mov    0x8(%ebp),%esi
  for (int i = 0; i < n; i++)
 37c:	85 f6                	test   %esi,%esi
 37e:	7e 1a                	jle    39a <IoBound+0x2a>
 380:	31 db                	xor    %ebx,%ebx
 382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int pid = fork();
 388:	e8 2d 05 00 00       	call   8ba <fork>
    if (pid == 0)
 38d:	85 c0                	test   %eax,%eax
    int pid = fork();
 38f:	89 c1                	mov    %eax,%ecx
    if (pid == 0)
 391:	74 13                	je     3a6 <IoBound+0x36>
  for (int i = 0; i < n; i++)
 393:	83 c3 01             	add    $0x1,%ebx
 396:	39 de                	cmp    %ebx,%esi
 398:	75 ee                	jne    388 <IoBound+0x18>
}
 39a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39d:	5b                   	pop    %ebx
 39e:	5e                   	pop    %esi
 39f:	5f                   	pop    %edi
 3a0:	5d                   	pop    %ebp
 3a1:	e9 1a fd ff ff       	jmp    c0 <IntelligentProcess.part.2>
        sleep((10 * (n - i)) % 3 + 1);
 3a6:	29 de                	sub    %ebx,%esi
 3a8:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 3ad:	8d 34 b6             	lea    (%esi,%esi,4),%esi
      for (int k = 0; k < i * 100 + 1; k++)
 3b0:	6b fb 64             	imul   $0x64,%ebx,%edi
        sleep((10 * (n - i)) % 3 + 1);
 3b3:	01 f6                	add    %esi,%esi
 3b5:	89 f0                	mov    %esi,%eax
 3b7:	f7 e2                	mul    %edx
 3b9:	83 c7 01             	add    $0x1,%edi
 3bc:	89 d0                	mov    %edx,%eax
 3be:	d1 e8                	shr    %eax
 3c0:	8d 04 40             	lea    (%eax,%eax,2),%eax
 3c3:	29 c6                	sub    %eax,%esi
 3c5:	83 c6 01             	add    $0x1,%esi
 3c8:	83 ec 0c             	sub    $0xc,%esp
 3cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 3ce:	56                   	push   %esi
 3cf:	e8 8e 05 00 00       	call   962 <sleep>
      for (int k = 0; k < i * 100 + 1; k++)
 3d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 3d7:	83 c4 10             	add    $0x10,%esp
 3da:	83 c1 01             	add    $0x1,%ecx
 3dd:	39 cf                	cmp    %ecx,%edi
 3df:	75 e7                	jne    3c8 <IoBound+0x58>
        printf(1, "Process: %d Finished\n", i);
 3e1:	83 ec 04             	sub    $0x4,%esp
 3e4:	53                   	push   %ebx
 3e5:	68 85 0d 00 00       	push   $0xd85
 3ea:	6a 01                	push   $0x1
 3ec:	e8 2f 06 00 00       	call   a20 <printf>
      exit(); //bye bye
 3f1:	e8 cc 04 00 00       	call   8c2 <exit>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <IntelligentProcess>:
{ //you might want to tweak the sleep intervals.. according to timing of desired queue..
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 1c             	sub    $0x1c,%esp
 409:	8b 7d 08             	mov    0x8(%ebp),%edi
  for (int i = 0; i < n; i++)
 40c:	85 ff                	test   %edi,%edi
 40e:	7e 1a                	jle    42a <IntelligentProcess+0x2a>
 410:	31 db                	xor    %ebx,%ebx
 412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int pid = fork();
 418:	e8 9d 04 00 00       	call   8ba <fork>
    if (pid == 0)
 41d:	85 c0                	test   %eax,%eax
    int pid = fork();
 41f:	89 c6                	mov    %eax,%esi
    if (pid == 0)
 421:	74 13                	je     436 <IntelligentProcess+0x36>
  for (int i = 0; i < n; i++)
 423:	83 c3 01             	add    $0x1,%ebx
 426:	39 df                	cmp    %ebx,%edi
 428:	75 ee                	jne    418 <IntelligentProcess+0x18>
}
 42a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42d:	5b                   	pop    %ebx
 42e:	5e                   	pop    %esi
 42f:	5f                   	pop    %edi
 430:	5d                   	pop    %ebp
 431:	e9 8a fc ff ff       	jmp    c0 <IntelligentProcess.part.2>
      for (double z = 0; z < 1000000.0; z += 0.01, j++)
 436:	d9 ee                	fldz   
          if (j % 100000 == 0)
 438:	bf c5 5a 7c 0a       	mov    $0xa7c5ac5,%edi
        if (i == 0)
 43d:	85 db                	test   %ebx,%ebx
 43f:	75 18                	jne    459 <IntelligentProcess+0x59>
          if (j % 100000 == 0)
 441:	89 f2                	mov    %esi,%edx
 443:	c1 ea 05             	shr    $0x5,%edx
 446:	89 d0                	mov    %edx,%eax
 448:	f7 e7                	mul    %edi
 44a:	89 d0                	mov    %edx,%eax
 44c:	c1 e8 07             	shr    $0x7,%eax
 44f:	69 c0 a0 86 01 00    	imul   $0x186a0,%eax,%eax
 455:	39 c6                	cmp    %eax,%esi
 457:	74 2a                	je     483 <IntelligentProcess+0x83>
      for (double z = 0; z < 1000000.0; z += 0.01, j++)
 459:	dc 05 e8 0d 00 00    	faddl  0xde8
 45f:	83 c6 01             	add    $0x1,%esi
 462:	d9 05 f0 0d 00 00    	flds   0xdf0
 468:	df e9                	fucomip %st(1),%st
 46a:	77 d1                	ja     43d <IntelligentProcess+0x3d>
 46c:	dd d8                	fstp   %st(0)
        printf(1, "Process: %d Finished\n", i);
 46e:	83 ec 04             	sub    $0x4,%esp
 471:	53                   	push   %ebx
 472:	68 85 0d 00 00       	push   $0xd85
 477:	6a 01                	push   $0x1
 479:	e8 a2 05 00 00       	call   a20 <printf>
      exit(); //bye bye
 47e:	e8 3f 04 00 00       	call   8c2 <exit>
            sleep(1);
 483:	83 ec 0c             	sub    $0xc,%esp
 486:	dd 5d e0             	fstpl  -0x20(%ebp)
 489:	6a 01                	push   $0x1
 48b:	e8 d2 04 00 00       	call   962 <sleep>
 490:	83 c4 10             	add    $0x10,%esp
 493:	dd 45 e0             	fldl   -0x20(%ebp)
 496:	eb c1                	jmp    459 <IntelligentProcess+0x59>
 498:	90                   	nop
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <Mixture>:
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 0c             	sub    $0xc,%esp
 4a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  for (int i = 0; i < n; i++)
 4ac:	85 ff                	test   %edi,%edi
 4ae:	7e 1a                	jle    4ca <Mixture+0x2a>
 4b0:	31 db                	xor    %ebx,%ebx
 4b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
 4b8:	e8 fd 03 00 00       	call   8ba <fork>
    if (pid == 0)
 4bd:	85 c0                	test   %eax,%eax
    pid = fork();
 4bf:	89 c6                	mov    %eax,%esi
    if (pid == 0)
 4c1:	74 13                	je     4d6 <Mixture+0x36>
  for (int i = 0; i < n; i++)
 4c3:	83 c3 01             	add    $0x1,%ebx
 4c6:	39 df                	cmp    %ebx,%edi
 4c8:	75 ee                	jne    4b8 <Mixture+0x18>
}
 4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5f                   	pop    %edi
 4d0:	5d                   	pop    %ebp
 4d1:	e9 ea fb ff ff       	jmp    c0 <IntelligentProcess.part.2>
      j = (getpid() - 4) % 2;
 4d6:	e8 77 04 00 00       	call   952 <getpid>
 4db:	83 e8 04             	sub    $0x4,%eax
 4de:	89 c2                	mov    %eax,%edx
 4e0:	c1 ea 1f             	shr    $0x1f,%edx
 4e3:	01 d0                	add    %edx,%eax
 4e5:	83 e0 01             	and    $0x1,%eax
      switch (j)
 4e8:	29 d0                	sub    %edx,%eax
 4ea:	74 3a                	je     526 <Mixture+0x86>
 4ec:	83 f8 01             	cmp    $0x1,%eax
 4ef:	75 20                	jne    511 <Mixture+0x71>
        for (k = 0; k < i; k++)
 4f1:	85 db                	test   %ebx,%ebx
 4f3:	74 1c                	je     511 <Mixture+0x71>
          sleep((10 * (n - i)) + 1);
 4f5:	29 df                	sub    %ebx,%edi
 4f7:	8d 04 bf             	lea    (%edi,%edi,4),%eax
 4fa:	8d 7c 00 01          	lea    0x1(%eax,%eax,1),%edi
 4fe:	83 ec 0c             	sub    $0xc,%esp
        for (k = 0; k < i; k++)
 501:	83 c6 01             	add    $0x1,%esi
          sleep((10 * (n - i)) + 1);
 504:	57                   	push   %edi
 505:	e8 58 04 00 00       	call   962 <sleep>
        for (k = 0; k < i; k++)
 50a:	83 c4 10             	add    $0x10,%esp
 50d:	39 de                	cmp    %ebx,%esi
 50f:	75 ed                	jne    4fe <Mixture+0x5e>
        printf(1, "Process: %d Finished\n", i);
 511:	83 ec 04             	sub    $0x4,%esp
 514:	53                   	push   %ebx
 515:	68 85 0d 00 00       	push   $0xd85
 51a:	6a 01                	push   $0x1
 51c:	e8 ff 04 00 00       	call   a20 <printf>
      exit(); //bye bye
 521:	e8 9c 03 00 00       	call   8c2 <exit>
        for (double z = 0; z < 1000000.0; z += 0.01)
 526:	d9 ee                	fldz   
 528:	dd 05 e8 0d 00 00    	fldl   0xde8
 52e:	dc c1                	fadd   %st,%st(1)
 530:	d9 05 f0 0d 00 00    	flds   0xdf0
 536:	df ea                	fucomip %st(2),%st
 538:	77 f4                	ja     52e <Mixture+0x8e>
 53a:	dd d8                	fstp   %st(0)
 53c:	dd d8                	fstp   %st(0)
 53e:	eb d1                	jmp    511 <Mixture+0x71>

00000540 <ShowFailureofFCFS>:
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 1c             	sub    $0x1c,%esp
 549:	8b 75 08             	mov    0x8(%ebp),%esi
  for (int i = 0; i < n; i++)
 54c:	85 f6                	test   %esi,%esi
 54e:	7e 60                	jle    5b0 <ShowFailureofFCFS+0x70>
      if (i < n / 2)
 550:	89 f7                	mov    %esi,%edi
  for (int i = 0; i < n; i++)
 552:	31 db                	xor    %ebx,%ebx
      if (i < n / 2)
 554:	d1 ff                	sar    %edi
 556:	eb 0f                	jmp    567 <ShowFailureofFCFS+0x27>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 0; i < n; i++)
 560:	83 c3 01             	add    $0x1,%ebx
 563:	39 de                	cmp    %ebx,%esi
 565:	74 49                	je     5b0 <ShowFailureofFCFS+0x70>
    pid = fork();
 567:	e8 4e 03 00 00       	call   8ba <fork>
    if (pid == 0)
 56c:	85 c0                	test   %eax,%eax
 56e:	74 52                	je     5c2 <ShowFailureofFCFS+0x82>
      if (i < n / 2)
 570:	39 df                	cmp    %ebx,%edi
 572:	7e ec                	jle    560 <ShowFailureofFCFS+0x20>
        set_priority((60 - (10 * i) % 50), pid); //win-win for PBS
 574:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
 577:	83 ec 08             	sub    $0x8,%esp
  for (int i = 0; i < n; i++)
 57a:	83 c3 01             	add    $0x1,%ebx
        set_priority((60 - (10 * i) % 50), pid); //win-win for PBS
 57d:	50                   	push   %eax
 57e:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
 583:	01 c9                	add    %ecx,%ecx
 585:	f7 e9                	imul   %ecx
 587:	89 c8                	mov    %ecx,%eax
 589:	c1 f8 1f             	sar    $0x1f,%eax
 58c:	c1 fa 04             	sar    $0x4,%edx
 58f:	29 c2                	sub    %eax,%edx
 591:	b8 3c 00 00 00       	mov    $0x3c,%eax
 596:	6b d2 32             	imul   $0x32,%edx,%edx
 599:	29 d1                	sub    %edx,%ecx
 59b:	29 c8                	sub    %ecx,%eax
 59d:	50                   	push   %eax
 59e:	e8 cf 03 00 00       	call   972 <set_priority>
 5a3:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < n; i++)
 5a6:	39 de                	cmp    %ebx,%esi
 5a8:	75 bd                	jne    567 <ShowFailureofFCFS+0x27>
 5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while (wait() != -1)
 5b0:	e8 15 03 00 00       	call   8ca <wait>
 5b5:	83 f8 ff             	cmp    $0xffffffff,%eax
 5b8:	75 f6                	jne    5b0 <ShowFailureofFCFS+0x70>
}
 5ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bd:	5b                   	pop    %ebx
 5be:	5e                   	pop    %esi
 5bf:	5f                   	pop    %edi
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    
      if (i > n / 2)
 5c2:	39 df                	cmp    %ebx,%edi
 5c4:	89 c1                	mov    %eax,%ecx
 5c6:	7c 59                	jl     621 <ShowFailureofFCFS+0xe1>
        for (double z = 0; z < (i % 2 + 1) * 1.5 * 1000000.0; z += 0.01)
 5c8:	89 d8                	mov    %ebx,%eax
 5ca:	83 e0 01             	and    $0x1,%eax
 5cd:	83 c0 01             	add    $0x1,%eax
 5d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 5d3:	db 45 e4             	fildl  -0x1c(%ebp)
 5d6:	d8 0d f4 0d 00 00    	fmuls  0xdf4
 5dc:	d8 0d f0 0d 00 00    	fmuls  0xdf0
 5e2:	d9 ee                	fldz   
 5e4:	dd 05 e8 0d 00 00    	fldl   0xde8
 5ea:	d9 ca                	fxch   %st(2)
 5ec:	db e9                	fucomi %st(1),%st
 5ee:	76 16                	jbe    606 <ShowFailureofFCFS+0xc6>
 5f0:	d9 c9                	fxch   %st(1)
 5f2:	eb 02                	jmp    5f6 <ShowFailureofFCFS+0xb6>
 5f4:	d9 c9                	fxch   %st(1)
 5f6:	d8 c2                	fadd   %st(2),%st
 5f8:	d9 c9                	fxch   %st(1)
 5fa:	db e9                	fucomi %st(1),%st
 5fc:	77 f6                	ja     5f4 <ShowFailureofFCFS+0xb4>
 5fe:	dd d8                	fstp   %st(0)
 600:	dd d8                	fstp   %st(0)
 602:	dd d8                	fstp   %st(0)
 604:	eb 06                	jmp    60c <ShowFailureofFCFS+0xcc>
 606:	dd d8                	fstp   %st(0)
 608:	dd d8                	fstp   %st(0)
 60a:	dd d8                	fstp   %st(0)
        printf(1, "Process: %d Finished\n", i);
 60c:	83 ec 04             	sub    $0x4,%esp
 60f:	53                   	push   %ebx
 610:	68 85 0d 00 00       	push   $0xd85
 615:	6a 01                	push   $0x1
 617:	e8 04 04 00 00       	call   a20 <printf>
      exit(); //bye bye
 61c:	e8 a1 02 00 00       	call   8c2 <exit>
          sleep((10 * (n - i)) % (9) + 1);
 621:	29 de                	sub    %ebx,%esi
 623:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
 628:	8d 34 b6             	lea    (%esi,%esi,4),%esi
 62b:	01 f6                	add    %esi,%esi
 62d:	89 f0                	mov    %esi,%eax
 62f:	f7 ea                	imul   %edx
 631:	89 d0                	mov    %edx,%eax
 633:	89 f2                	mov    %esi,%edx
 635:	d1 f8                	sar    %eax
 637:	c1 fa 1f             	sar    $0x1f,%edx
 63a:	29 d0                	sub    %edx,%eax
 63c:	8d 04 c0             	lea    (%eax,%eax,8),%eax
 63f:	29 c6                	sub    %eax,%esi
        for (int k = 0; k < i * 10 + 1; k++)
 641:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
          sleep((10 * (n - i)) % (9) + 1);
 644:	83 c6 01             	add    $0x1,%esi
 647:	8d 7c 00 01          	lea    0x1(%eax,%eax,1),%edi
 64b:	83 ec 0c             	sub    $0xc,%esp
 64e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 651:	56                   	push   %esi
 652:	e8 0b 03 00 00       	call   962 <sleep>
        for (int k = 0; k < i * 10 + 1; k++)
 657:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 65a:	83 c4 10             	add    $0x10,%esp
 65d:	83 c1 01             	add    $0x1,%ecx
 660:	39 cf                	cmp    %ecx,%edi
 662:	75 e7                	jne    64b <ShowFailureofFCFS+0x10b>
 664:	eb a6                	jmp    60c <ShowFailureofFCFS+0xcc>
 666:	66 90                	xchg   %ax,%ax
 668:	66 90                	xchg   %ax,%ax
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	53                   	push   %ebx
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 67a:	89 c2                	mov    %eax,%edx
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 680:	83 c1 01             	add    $0x1,%ecx
 683:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 687:	83 c2 01             	add    $0x1,%edx
 68a:	84 db                	test   %bl,%bl
 68c:	88 5a ff             	mov    %bl,-0x1(%edx)
 68f:	75 ef                	jne    680 <strcpy+0x10>
    ;
  return os;
}
 691:	5b                   	pop    %ebx
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    
 694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 69a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	53                   	push   %ebx
 6a4:	8b 55 08             	mov    0x8(%ebp),%edx
 6a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 6aa:	0f b6 02             	movzbl (%edx),%eax
 6ad:	0f b6 19             	movzbl (%ecx),%ebx
 6b0:	84 c0                	test   %al,%al
 6b2:	75 1c                	jne    6d0 <strcmp+0x30>
 6b4:	eb 2a                	jmp    6e0 <strcmp+0x40>
 6b6:	8d 76 00             	lea    0x0(%esi),%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 6c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 6c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 6c6:	83 c1 01             	add    $0x1,%ecx
 6c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 6cc:	84 c0                	test   %al,%al
 6ce:	74 10                	je     6e0 <strcmp+0x40>
 6d0:	38 d8                	cmp    %bl,%al
 6d2:	74 ec                	je     6c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 6d4:	29 d8                	sub    %ebx,%eax
}
 6d6:	5b                   	pop    %ebx
 6d7:	5d                   	pop    %ebp
 6d8:	c3                   	ret    
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 6e2:	29 d8                	sub    %ebx,%eax
}
 6e4:	5b                   	pop    %ebx
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	89 f6                	mov    %esi,%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006f0 <strlen>:

uint
strlen(const char *s)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 6f6:	80 39 00             	cmpb   $0x0,(%ecx)
 6f9:	74 15                	je     710 <strlen+0x20>
 6fb:	31 d2                	xor    %edx,%edx
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
 700:	83 c2 01             	add    $0x1,%edx
 703:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 707:	89 d0                	mov    %edx,%eax
 709:	75 f5                	jne    700 <strlen+0x10>
    ;
  return n;
}
 70b:	5d                   	pop    %ebp
 70c:	c3                   	ret    
 70d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 710:	31 c0                	xor    %eax,%eax
}
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    
 714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 71a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000720 <memset>:

void*
memset(void *dst, int c, uint n)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 727:	8b 4d 10             	mov    0x10(%ebp),%ecx
 72a:	8b 45 0c             	mov    0xc(%ebp),%eax
 72d:	89 d7                	mov    %edx,%edi
 72f:	fc                   	cld    
 730:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 732:	89 d0                	mov    %edx,%eax
 734:	5f                   	pop    %edi
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <strchr>:

char*
strchr(const char *s, char c)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	53                   	push   %ebx
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 74a:	0f b6 10             	movzbl (%eax),%edx
 74d:	84 d2                	test   %dl,%dl
 74f:	74 1d                	je     76e <strchr+0x2e>
    if(*s == c)
 751:	38 d3                	cmp    %dl,%bl
 753:	89 d9                	mov    %ebx,%ecx
 755:	75 0d                	jne    764 <strchr+0x24>
 757:	eb 17                	jmp    770 <strchr+0x30>
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 760:	38 ca                	cmp    %cl,%dl
 762:	74 0c                	je     770 <strchr+0x30>
  for(; *s; s++)
 764:	83 c0 01             	add    $0x1,%eax
 767:	0f b6 10             	movzbl (%eax),%edx
 76a:	84 d2                	test   %dl,%dl
 76c:	75 f2                	jne    760 <strchr+0x20>
      return (char*)s;
  return 0;
 76e:	31 c0                	xor    %eax,%eax
}
 770:	5b                   	pop    %ebx
 771:	5d                   	pop    %ebp
 772:	c3                   	ret    
 773:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000780 <gets>:

char*
gets(char *buf, int max)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 786:	31 f6                	xor    %esi,%esi
 788:	89 f3                	mov    %esi,%ebx
{
 78a:	83 ec 1c             	sub    $0x1c,%esp
 78d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 790:	eb 2f                	jmp    7c1 <gets+0x41>
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 798:	8d 45 e7             	lea    -0x19(%ebp),%eax
 79b:	83 ec 04             	sub    $0x4,%esp
 79e:	6a 01                	push   $0x1
 7a0:	50                   	push   %eax
 7a1:	6a 00                	push   $0x0
 7a3:	e8 42 01 00 00       	call   8ea <read>
    if(cc < 1)
 7a8:	83 c4 10             	add    $0x10,%esp
 7ab:	85 c0                	test   %eax,%eax
 7ad:	7e 1c                	jle    7cb <gets+0x4b>
      break;
    buf[i++] = c;
 7af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 7b3:	83 c7 01             	add    $0x1,%edi
 7b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 7b9:	3c 0a                	cmp    $0xa,%al
 7bb:	74 23                	je     7e0 <gets+0x60>
 7bd:	3c 0d                	cmp    $0xd,%al
 7bf:	74 1f                	je     7e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 7c1:	83 c3 01             	add    $0x1,%ebx
 7c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 7c7:	89 fe                	mov    %edi,%esi
 7c9:	7c cd                	jl     798 <gets+0x18>
 7cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 7cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 7d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 7d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7d6:	5b                   	pop    %ebx
 7d7:	5e                   	pop    %esi
 7d8:	5f                   	pop    %edi
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    
 7db:	90                   	nop
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7e0:	8b 75 08             	mov    0x8(%ebp),%esi
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
 7e6:	01 de                	add    %ebx,%esi
 7e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 7ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 7ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7f0:	5b                   	pop    %ebx
 7f1:	5e                   	pop    %esi
 7f2:	5f                   	pop    %edi
 7f3:	5d                   	pop    %ebp
 7f4:	c3                   	ret    
 7f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <stat>:

int
stat(const char *n, struct stat *st)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	56                   	push   %esi
 804:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 805:	83 ec 08             	sub    $0x8,%esp
 808:	6a 00                	push   $0x0
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 00 01 00 00       	call   912 <open>
  if(fd < 0)
 812:	83 c4 10             	add    $0x10,%esp
 815:	85 c0                	test   %eax,%eax
 817:	78 27                	js     840 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	ff 75 0c             	pushl  0xc(%ebp)
 81f:	89 c3                	mov    %eax,%ebx
 821:	50                   	push   %eax
 822:	e8 03 01 00 00       	call   92a <fstat>
  close(fd);
 827:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 82a:	89 c6                	mov    %eax,%esi
  close(fd);
 82c:	e8 c9 00 00 00       	call   8fa <close>
  return r;
 831:	83 c4 10             	add    $0x10,%esp
}
 834:	8d 65 f8             	lea    -0x8(%ebp),%esp
 837:	89 f0                	mov    %esi,%eax
 839:	5b                   	pop    %ebx
 83a:	5e                   	pop    %esi
 83b:	5d                   	pop    %ebp
 83c:	c3                   	ret    
 83d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 840:	be ff ff ff ff       	mov    $0xffffffff,%esi
 845:	eb ed                	jmp    834 <stat+0x34>
 847:	89 f6                	mov    %esi,%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <atoi>:

int
atoi(const char *s)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	53                   	push   %ebx
 854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 857:	0f be 11             	movsbl (%ecx),%edx
 85a:	8d 42 d0             	lea    -0x30(%edx),%eax
 85d:	3c 09                	cmp    $0x9,%al
  n = 0;
 85f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 864:	77 1f                	ja     885 <atoi+0x35>
 866:	8d 76 00             	lea    0x0(%esi),%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 870:	8d 04 80             	lea    (%eax,%eax,4),%eax
 873:	83 c1 01             	add    $0x1,%ecx
 876:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 87a:	0f be 11             	movsbl (%ecx),%edx
 87d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 880:	80 fb 09             	cmp    $0x9,%bl
 883:	76 eb                	jbe    870 <atoi+0x20>
  return n;
}
 885:	5b                   	pop    %ebx
 886:	5d                   	pop    %ebp
 887:	c3                   	ret    
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000890 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	56                   	push   %esi
 894:	53                   	push   %ebx
 895:	8b 5d 10             	mov    0x10(%ebp),%ebx
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 89e:	85 db                	test   %ebx,%ebx
 8a0:	7e 14                	jle    8b6 <memmove+0x26>
 8a2:	31 d2                	xor    %edx,%edx
 8a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 8a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 8ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 8af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 8b2:	39 d3                	cmp    %edx,%ebx
 8b4:	75 f2                	jne    8a8 <memmove+0x18>
  return vdst;
}
 8b6:	5b                   	pop    %ebx
 8b7:	5e                   	pop    %esi
 8b8:	5d                   	pop    %ebp
 8b9:	c3                   	ret    

000008ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8ba:	b8 01 00 00 00       	mov    $0x1,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <exit>:
SYSCALL(exit)
 8c2:	b8 02 00 00 00       	mov    $0x2,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <wait>:
SYSCALL(wait)
 8ca:	b8 03 00 00 00       	mov    $0x3,%eax
 8cf:	cd 40                	int    $0x40
 8d1:	c3                   	ret    

000008d2 <waitx>:
SYSCALL(waitx)
 8d2:	b8 16 00 00 00       	mov    $0x16,%eax
 8d7:	cd 40                	int    $0x40
 8d9:	c3                   	ret    

000008da <getprocstable>:
SYSCALL(getprocstable)
 8da:	b8 18 00 00 00       	mov    $0x18,%eax
 8df:	cd 40                	int    $0x40
 8e1:	c3                   	ret    

000008e2 <pipe>:
SYSCALL(pipe)
 8e2:	b8 04 00 00 00       	mov    $0x4,%eax
 8e7:	cd 40                	int    $0x40
 8e9:	c3                   	ret    

000008ea <read>:
SYSCALL(read)
 8ea:	b8 05 00 00 00       	mov    $0x5,%eax
 8ef:	cd 40                	int    $0x40
 8f1:	c3                   	ret    

000008f2 <write>:
SYSCALL(write)
 8f2:	b8 10 00 00 00       	mov    $0x10,%eax
 8f7:	cd 40                	int    $0x40
 8f9:	c3                   	ret    

000008fa <close>:
SYSCALL(close)
 8fa:	b8 15 00 00 00       	mov    $0x15,%eax
 8ff:	cd 40                	int    $0x40
 901:	c3                   	ret    

00000902 <kill>:
SYSCALL(kill)
 902:	b8 06 00 00 00       	mov    $0x6,%eax
 907:	cd 40                	int    $0x40
 909:	c3                   	ret    

0000090a <exec>:
SYSCALL(exec)
 90a:	b8 07 00 00 00       	mov    $0x7,%eax
 90f:	cd 40                	int    $0x40
 911:	c3                   	ret    

00000912 <open>:
SYSCALL(open)
 912:	b8 0f 00 00 00       	mov    $0xf,%eax
 917:	cd 40                	int    $0x40
 919:	c3                   	ret    

0000091a <mknod>:
SYSCALL(mknod)
 91a:	b8 11 00 00 00       	mov    $0x11,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <unlink>:
SYSCALL(unlink)
 922:	b8 12 00 00 00       	mov    $0x12,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <fstat>:
SYSCALL(fstat)
 92a:	b8 08 00 00 00       	mov    $0x8,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <link>:
SYSCALL(link)
 932:	b8 13 00 00 00       	mov    $0x13,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <mkdir>:
SYSCALL(mkdir)
 93a:	b8 14 00 00 00       	mov    $0x14,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <chdir>:
SYSCALL(chdir)
 942:	b8 09 00 00 00       	mov    $0x9,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <dup>:
SYSCALL(dup)
 94a:	b8 0a 00 00 00       	mov    $0xa,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <getpid>:
SYSCALL(getpid)
 952:	b8 0b 00 00 00       	mov    $0xb,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <sbrk>:
SYSCALL(sbrk)
 95a:	b8 0c 00 00 00       	mov    $0xc,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <sleep>:
SYSCALL(sleep)
 962:	b8 0d 00 00 00       	mov    $0xd,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <uptime>:
SYSCALL(uptime)
 96a:	b8 0e 00 00 00       	mov    $0xe,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <set_priority>:
SYSCALL(set_priority)
 972:	b8 17 00 00 00       	mov    $0x17,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    
 97a:	66 90                	xchg   %ax,%ax
 97c:	66 90                	xchg   %ax,%ax
 97e:	66 90                	xchg   %ax,%ax

00000980 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 989:	85 d2                	test   %edx,%edx
{
 98b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 98e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 990:	79 76                	jns    a08 <printint+0x88>
 992:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 996:	74 70                	je     a08 <printint+0x88>
    x = -xx;
 998:	f7 d8                	neg    %eax
    neg = 1;
 99a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 9a1:	31 f6                	xor    %esi,%esi
 9a3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 9a6:	eb 0a                	jmp    9b2 <printint+0x32>
 9a8:	90                   	nop
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 9b0:	89 fe                	mov    %edi,%esi
 9b2:	31 d2                	xor    %edx,%edx
 9b4:	8d 7e 01             	lea    0x1(%esi),%edi
 9b7:	f7 f1                	div    %ecx
 9b9:	0f b6 92 00 0e 00 00 	movzbl 0xe00(%edx),%edx
  }while((x /= base) != 0);
 9c0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 9c2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 9c5:	75 e9                	jne    9b0 <printint+0x30>
  if(neg)
 9c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 9ca:	85 c0                	test   %eax,%eax
 9cc:	74 08                	je     9d6 <printint+0x56>
    buf[i++] = '-';
 9ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 9d3:	8d 7e 02             	lea    0x2(%esi),%edi
 9d6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 9da:	8b 7d c0             	mov    -0x40(%ebp),%edi
 9dd:	8d 76 00             	lea    0x0(%esi),%esi
 9e0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 9e3:	83 ec 04             	sub    $0x4,%esp
 9e6:	83 ee 01             	sub    $0x1,%esi
 9e9:	6a 01                	push   $0x1
 9eb:	53                   	push   %ebx
 9ec:	57                   	push   %edi
 9ed:	88 45 d7             	mov    %al,-0x29(%ebp)
 9f0:	e8 fd fe ff ff       	call   8f2 <write>

  while(--i >= 0)
 9f5:	83 c4 10             	add    $0x10,%esp
 9f8:	39 de                	cmp    %ebx,%esi
 9fa:	75 e4                	jne    9e0 <printint+0x60>
    putc(fd, buf[i]);
}
 9fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9ff:	5b                   	pop    %ebx
 a00:	5e                   	pop    %esi
 a01:	5f                   	pop    %edi
 a02:	5d                   	pop    %ebp
 a03:	c3                   	ret    
 a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 a08:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 a0f:	eb 90                	jmp    9a1 <printint+0x21>
 a11:	eb 0d                	jmp    a20 <printf>
 a13:	90                   	nop
 a14:	90                   	nop
 a15:	90                   	nop
 a16:	90                   	nop
 a17:	90                   	nop
 a18:	90                   	nop
 a19:	90                   	nop
 a1a:	90                   	nop
 a1b:	90                   	nop
 a1c:	90                   	nop
 a1d:	90                   	nop
 a1e:	90                   	nop
 a1f:	90                   	nop

00000a20 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	57                   	push   %edi
 a24:	56                   	push   %esi
 a25:	53                   	push   %ebx
 a26:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a29:	8b 75 0c             	mov    0xc(%ebp),%esi
 a2c:	0f b6 1e             	movzbl (%esi),%ebx
 a2f:	84 db                	test   %bl,%bl
 a31:	0f 84 b3 00 00 00    	je     aea <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 a37:	8d 45 10             	lea    0x10(%ebp),%eax
 a3a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 a3d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 a3f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 a42:	eb 2f                	jmp    a73 <printf+0x53>
 a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 a48:	83 f8 25             	cmp    $0x25,%eax
 a4b:	0f 84 a7 00 00 00    	je     af8 <printf+0xd8>
  write(fd, &c, 1);
 a51:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 a54:	83 ec 04             	sub    $0x4,%esp
 a57:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 a5a:	6a 01                	push   $0x1
 a5c:	50                   	push   %eax
 a5d:	ff 75 08             	pushl  0x8(%ebp)
 a60:	e8 8d fe ff ff       	call   8f2 <write>
 a65:	83 c4 10             	add    $0x10,%esp
 a68:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 a6b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 a6f:	84 db                	test   %bl,%bl
 a71:	74 77                	je     aea <printf+0xca>
    if(state == 0){
 a73:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 a75:	0f be cb             	movsbl %bl,%ecx
 a78:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 a7b:	74 cb                	je     a48 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 a7d:	83 ff 25             	cmp    $0x25,%edi
 a80:	75 e6                	jne    a68 <printf+0x48>
      if(c == 'd'){
 a82:	83 f8 64             	cmp    $0x64,%eax
 a85:	0f 84 05 01 00 00    	je     b90 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 a8b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 a91:	83 f9 70             	cmp    $0x70,%ecx
 a94:	74 72                	je     b08 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 a96:	83 f8 73             	cmp    $0x73,%eax
 a99:	0f 84 99 00 00 00    	je     b38 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a9f:	83 f8 63             	cmp    $0x63,%eax
 aa2:	0f 84 08 01 00 00    	je     bb0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 aa8:	83 f8 25             	cmp    $0x25,%eax
 aab:	0f 84 ef 00 00 00    	je     ba0 <printf+0x180>
  write(fd, &c, 1);
 ab1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 ab4:	83 ec 04             	sub    $0x4,%esp
 ab7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 abb:	6a 01                	push   $0x1
 abd:	50                   	push   %eax
 abe:	ff 75 08             	pushl  0x8(%ebp)
 ac1:	e8 2c fe ff ff       	call   8f2 <write>
 ac6:	83 c4 0c             	add    $0xc,%esp
 ac9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 acc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 acf:	6a 01                	push   $0x1
 ad1:	50                   	push   %eax
 ad2:	ff 75 08             	pushl  0x8(%ebp)
 ad5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ad8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 ada:	e8 13 fe ff ff       	call   8f2 <write>
  for(i = 0; fmt[i]; i++){
 adf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 ae3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 ae6:	84 db                	test   %bl,%bl
 ae8:	75 89                	jne    a73 <printf+0x53>
    }
  }
}
 aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 aed:	5b                   	pop    %ebx
 aee:	5e                   	pop    %esi
 aef:	5f                   	pop    %edi
 af0:	5d                   	pop    %ebp
 af1:	c3                   	ret    
 af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 af8:	bf 25 00 00 00       	mov    $0x25,%edi
 afd:	e9 66 ff ff ff       	jmp    a68 <printf+0x48>
 b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 b08:	83 ec 0c             	sub    $0xc,%esp
 b0b:	b9 10 00 00 00       	mov    $0x10,%ecx
 b10:	6a 00                	push   $0x0
 b12:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 b15:	8b 45 08             	mov    0x8(%ebp),%eax
 b18:	8b 17                	mov    (%edi),%edx
 b1a:	e8 61 fe ff ff       	call   980 <printint>
        ap++;
 b1f:	89 f8                	mov    %edi,%eax
 b21:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b24:	31 ff                	xor    %edi,%edi
        ap++;
 b26:	83 c0 04             	add    $0x4,%eax
 b29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 b2c:	e9 37 ff ff ff       	jmp    a68 <printf+0x48>
 b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 b3b:	8b 08                	mov    (%eax),%ecx
        ap++;
 b3d:	83 c0 04             	add    $0x4,%eax
 b40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 b43:	85 c9                	test   %ecx,%ecx
 b45:	0f 84 8e 00 00 00    	je     bd9 <printf+0x1b9>
        while(*s != 0){
 b4b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 b4e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 b50:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 b52:	84 c0                	test   %al,%al
 b54:	0f 84 0e ff ff ff    	je     a68 <printf+0x48>
 b5a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 b5d:	89 de                	mov    %ebx,%esi
 b5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b62:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 b65:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 b68:	83 ec 04             	sub    $0x4,%esp
          s++;
 b6b:	83 c6 01             	add    $0x1,%esi
 b6e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 b71:	6a 01                	push   $0x1
 b73:	57                   	push   %edi
 b74:	53                   	push   %ebx
 b75:	e8 78 fd ff ff       	call   8f2 <write>
        while(*s != 0){
 b7a:	0f b6 06             	movzbl (%esi),%eax
 b7d:	83 c4 10             	add    $0x10,%esp
 b80:	84 c0                	test   %al,%al
 b82:	75 e4                	jne    b68 <printf+0x148>
 b84:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 b87:	31 ff                	xor    %edi,%edi
 b89:	e9 da fe ff ff       	jmp    a68 <printf+0x48>
 b8e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 b90:	83 ec 0c             	sub    $0xc,%esp
 b93:	b9 0a 00 00 00       	mov    $0xa,%ecx
 b98:	6a 01                	push   $0x1
 b9a:	e9 73 ff ff ff       	jmp    b12 <printf+0xf2>
 b9f:	90                   	nop
  write(fd, &c, 1);
 ba0:	83 ec 04             	sub    $0x4,%esp
 ba3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 ba6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 ba9:	6a 01                	push   $0x1
 bab:	e9 21 ff ff ff       	jmp    ad1 <printf+0xb1>
        putc(fd, *ap);
 bb0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 bb3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 bb6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 bb8:	6a 01                	push   $0x1
        ap++;
 bba:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 bbd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 bc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 bc3:	50                   	push   %eax
 bc4:	ff 75 08             	pushl  0x8(%ebp)
 bc7:	e8 26 fd ff ff       	call   8f2 <write>
        ap++;
 bcc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 bcf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bd2:	31 ff                	xor    %edi,%edi
 bd4:	e9 8f fe ff ff       	jmp    a68 <printf+0x48>
          s = "(null)";
 bd9:	bb f8 0d 00 00       	mov    $0xdf8,%ebx
        while(*s != 0){
 bde:	b8 28 00 00 00       	mov    $0x28,%eax
 be3:	e9 72 ff ff ff       	jmp    b5a <printf+0x13a>
 be8:	66 90                	xchg   %ax,%ax
 bea:	66 90                	xchg   %ax,%ax
 bec:	66 90                	xchg   %ax,%ax
 bee:	66 90                	xchg   %ax,%ax

00000bf0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf1:	a1 14 12 00 00       	mov    0x1214,%eax
{
 bf6:	89 e5                	mov    %esp,%ebp
 bf8:	57                   	push   %edi
 bf9:	56                   	push   %esi
 bfa:	53                   	push   %ebx
 bfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 bfe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c08:	39 c8                	cmp    %ecx,%eax
 c0a:	8b 10                	mov    (%eax),%edx
 c0c:	73 32                	jae    c40 <free+0x50>
 c0e:	39 d1                	cmp    %edx,%ecx
 c10:	72 04                	jb     c16 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c12:	39 d0                	cmp    %edx,%eax
 c14:	72 32                	jb     c48 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c16:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c19:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c1c:	39 fa                	cmp    %edi,%edx
 c1e:	74 30                	je     c50 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 c20:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 c23:	8b 50 04             	mov    0x4(%eax),%edx
 c26:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c29:	39 f1                	cmp    %esi,%ecx
 c2b:	74 3a                	je     c67 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 c2d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 c2f:	a3 14 12 00 00       	mov    %eax,0x1214
}
 c34:	5b                   	pop    %ebx
 c35:	5e                   	pop    %esi
 c36:	5f                   	pop    %edi
 c37:	5d                   	pop    %ebp
 c38:	c3                   	ret    
 c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c40:	39 d0                	cmp    %edx,%eax
 c42:	72 04                	jb     c48 <free+0x58>
 c44:	39 d1                	cmp    %edx,%ecx
 c46:	72 ce                	jb     c16 <free+0x26>
{
 c48:	89 d0                	mov    %edx,%eax
 c4a:	eb bc                	jmp    c08 <free+0x18>
 c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 c50:	03 72 04             	add    0x4(%edx),%esi
 c53:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 c56:	8b 10                	mov    (%eax),%edx
 c58:	8b 12                	mov    (%edx),%edx
 c5a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 c5d:	8b 50 04             	mov    0x4(%eax),%edx
 c60:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c63:	39 f1                	cmp    %esi,%ecx
 c65:	75 c6                	jne    c2d <free+0x3d>
    p->s.size += bp->s.size;
 c67:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 c6a:	a3 14 12 00 00       	mov    %eax,0x1214
    p->s.size += bp->s.size;
 c6f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c72:	8b 53 f8             	mov    -0x8(%ebx),%edx
 c75:	89 10                	mov    %edx,(%eax)
}
 c77:	5b                   	pop    %ebx
 c78:	5e                   	pop    %esi
 c79:	5f                   	pop    %edi
 c7a:	5d                   	pop    %ebp
 c7b:	c3                   	ret    
 c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c80 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c80:	55                   	push   %ebp
 c81:	89 e5                	mov    %esp,%ebp
 c83:	57                   	push   %edi
 c84:	56                   	push   %esi
 c85:	53                   	push   %ebx
 c86:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c89:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 c8c:	8b 15 14 12 00 00    	mov    0x1214,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c92:	8d 78 07             	lea    0x7(%eax),%edi
 c95:	c1 ef 03             	shr    $0x3,%edi
 c98:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 c9b:	85 d2                	test   %edx,%edx
 c9d:	0f 84 9d 00 00 00    	je     d40 <malloc+0xc0>
 ca3:	8b 02                	mov    (%edx),%eax
 ca5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 ca8:	39 cf                	cmp    %ecx,%edi
 caa:	76 6c                	jbe    d18 <malloc+0x98>
 cac:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 cb2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 cb7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 cba:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 cc1:	eb 0e                	jmp    cd1 <malloc+0x51>
 cc3:	90                   	nop
 cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 cca:	8b 48 04             	mov    0x4(%eax),%ecx
 ccd:	39 f9                	cmp    %edi,%ecx
 ccf:	73 47                	jae    d18 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cd1:	39 05 14 12 00 00    	cmp    %eax,0x1214
 cd7:	89 c2                	mov    %eax,%edx
 cd9:	75 ed                	jne    cc8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 cdb:	83 ec 0c             	sub    $0xc,%esp
 cde:	56                   	push   %esi
 cdf:	e8 76 fc ff ff       	call   95a <sbrk>
  if(p == (char*)-1)
 ce4:	83 c4 10             	add    $0x10,%esp
 ce7:	83 f8 ff             	cmp    $0xffffffff,%eax
 cea:	74 1c                	je     d08 <malloc+0x88>
  hp->s.size = nu;
 cec:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 cef:	83 ec 0c             	sub    $0xc,%esp
 cf2:	83 c0 08             	add    $0x8,%eax
 cf5:	50                   	push   %eax
 cf6:	e8 f5 fe ff ff       	call   bf0 <free>
  return freep;
 cfb:	8b 15 14 12 00 00    	mov    0x1214,%edx
      if((p = morecore(nunits)) == 0)
 d01:	83 c4 10             	add    $0x10,%esp
 d04:	85 d2                	test   %edx,%edx
 d06:	75 c0                	jne    cc8 <malloc+0x48>
        return 0;
  }
}
 d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 d0b:	31 c0                	xor    %eax,%eax
}
 d0d:	5b                   	pop    %ebx
 d0e:	5e                   	pop    %esi
 d0f:	5f                   	pop    %edi
 d10:	5d                   	pop    %ebp
 d11:	c3                   	ret    
 d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 d18:	39 cf                	cmp    %ecx,%edi
 d1a:	74 54                	je     d70 <malloc+0xf0>
        p->s.size -= nunits;
 d1c:	29 f9                	sub    %edi,%ecx
 d1e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 d21:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 d24:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 d27:	89 15 14 12 00 00    	mov    %edx,0x1214
}
 d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 d30:	83 c0 08             	add    $0x8,%eax
}
 d33:	5b                   	pop    %ebx
 d34:	5e                   	pop    %esi
 d35:	5f                   	pop    %edi
 d36:	5d                   	pop    %ebp
 d37:	c3                   	ret    
 d38:	90                   	nop
 d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 d40:	c7 05 14 12 00 00 18 	movl   $0x1218,0x1214
 d47:	12 00 00 
 d4a:	c7 05 18 12 00 00 18 	movl   $0x1218,0x1218
 d51:	12 00 00 
    base.s.size = 0;
 d54:	b8 18 12 00 00       	mov    $0x1218,%eax
 d59:	c7 05 1c 12 00 00 00 	movl   $0x0,0x121c
 d60:	00 00 00 
 d63:	e9 44 ff ff ff       	jmp    cac <malloc+0x2c>
 d68:	90                   	nop
 d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 d70:	8b 08                	mov    (%eax),%ecx
 d72:	89 0a                	mov    %ecx,(%edx)
 d74:	eb b1                	jmp    d27 <malloc+0xa7>
