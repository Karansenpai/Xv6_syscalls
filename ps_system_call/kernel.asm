
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 55 11 80       	mov    $0x801155d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 73 10 80       	push   $0x80107340
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 a5 44 00 00       	call   80104500 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 73 10 80       	push   $0x80107347
80100097:	50                   	push   %eax
80100098:	e8 33 43 00 00       	call   801043d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 45 00 00       	call   801046d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 45 00 00       	call   80104670 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 42 00 00       	call   80104410 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 73 10 80       	push   $0x8010734e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 42 00 00       	call   801044b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 73 10 80       	push   $0x8010735f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 42 00 00       	call   801044b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 42 00 00       	call   80104470 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 44 00 00       	call   801046d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 43 00 00       	jmp    80104670 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 73 10 80       	push   $0x80107366
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 44 00 00       	call   801046d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 8e 3d 00 00       	call   80104060 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 43 00 00       	call   80104670 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 43 00 00       	call   80104670 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 73 10 80       	push   $0x8010736d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 23 7d 10 80 	movl   $0x80107d23,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 41 00 00       	call   80104520 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 73 10 80       	push   $0x80107381
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 31 5a 00 00       	call   80105e50 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 46 59 00 00       	call   80105e50 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 3a 59 00 00       	call   80105e50 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 2e 59 00 00       	call   80105e50 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 da 42 00 00       	call   80104830 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 42 00 00       	call   80104790 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 73 10 80       	push   $0x80107385
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 20 41 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 87 40 00 00       	call   80104670 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 b0 73 10 80 	movzbl -0x7fef8c50(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 e3 3e 00 00       	call   801046d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 98 73 10 80       	mov    $0x80107398,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 10 3e 00 00       	call   80104670 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 73 10 80       	push   $0x8010739f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 38 3e 00 00       	call   801046d0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 9b 3c 00 00       	call   80104670 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 ed 37 00 00       	jmp    80104200 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 d7 36 00 00       	call   80104120 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 a8 73 10 80       	push   $0x801073a8
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 8b 3a 00 00       	call   80104500 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 2e 00 00       	call   80103990 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 09 03 00 00    	je     80100deb <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 a7 64 00 00       	call   80106fe0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 b3 02 00 00    	je     80100e0a <exec+0x35a>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 58 62 00 00       	call   80106e00 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 32 61 00 00       	call   80106d10 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 9a 0e 00 00       	call   80101aa0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 40 63 00 00       	call   80106f60 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 cf 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c51:	e8 8a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 99 61 00 00       	call   80106e00 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 f8 63 00 00       	call   80107080 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 b8 3c 00 00       	call   80104990 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 a4 3c 00 00       	call   80104990 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 53 65 00 00       	call   80107250 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 4a 62 00 00       	call   80106f60 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 e8 64 00 00       	call   80107250 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 aa 3b 00 00       	call   80104950 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 2;
80100dca:	c7 41 7c 02 00 00 00 	movl   $0x2,0x7c(%ecx)
  switchuvm(curproc);
80100dd1:	89 0c 24             	mov    %ecx,(%esp)
80100dd4:	e8 a7 5d 00 00       	call   80106b80 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 7f 61 00 00       	call   80106f60 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100deb:	e8 f0 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 c1 73 10 80       	push   $0x801073c1
80100df8:	e8 a3 f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e05:	e9 12 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e0a:	be 00 20 00 00       	mov    $0x2000,%esi
80100e0f:	31 ff                	xor    %edi,%edi
80100e11:	e9 32 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e16:	66 90                	xchg   %ax,%ax
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 cd 73 10 80       	push   $0x801073cd
80100e2b:	68 60 ef 10 80       	push   $0x8010ef60
80100e30:	e8 cb 36 00 00       	call   80104500 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 ef 10 80       	push   $0x8010ef60
80100e51:	e8 7a 38 00 00       	call   801046d0 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 ef 10 80       	push   $0x8010ef60
80100e81:	e8 ea 37 00 00       	call   80104670 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 ef 10 80       	push   $0x8010ef60
80100e9a:	e8 d1 37 00 00       	call   80104670 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 ef 10 80       	push   $0x8010ef60
80100ebf:	e8 0c 38 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 ef 10 80       	push   $0x8010ef60
80100edc:	e8 8f 37 00 00       	call   80104670 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 d4 73 10 80       	push   $0x801073d4
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 ef 10 80       	push   $0x8010ef60
80100f11:	e8 ba 37 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 1f 37 00 00       	call   80104670 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 ed 36 00 00       	jmp    80104670 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 1e 00 00       	jmp    80102de0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 82 25 00 00       	call   80103540 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 dc 73 10 80       	push   $0x801073dc
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 3e 26 00 00       	jmp    801036e0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 e6 73 10 80       	push   $0x801073e6
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 c2 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 2d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 66 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 ef 73 10 80       	push   $0x801073ef
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 22 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 f5 73 10 80       	push   $0x801073f5
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 2e 1d 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 ff 73 10 80       	push   $0x801073ff
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 12 74 10 80       	push   $0x80107412
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 3e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 56 34 00 00       	call   80104790 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 0e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 f9 10 80       	push   $0x8010f960
8010137a:	e8 51 33 00 00       	call   801046d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 f9 10 80       	push   $0x8010f960
801013e7:	e8 84 32 00 00       	call   80104670 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 56 32 00 00       	call   80104670 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 28 74 10 80       	push   $0x80107428
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 76 1a 00 00       	call   80102f50 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 38 74 10 80       	push   $0x80107438
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 da 32 00 00       	call   80104830 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 4b 74 10 80       	push   $0x8010744b
80101581:	68 60 f9 10 80       	push   $0x8010f960
80101586:	e8 75 2f 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 52 74 10 80       	push   $0x80107452
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 2c 2e 00 00       	call   801043d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 b4 15 11 80       	push   $0x801115b4
801015cc:	e8 5f 32 00 00       	call   80104830 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 cc 15 11 80    	push   0x801115cc
801015df:	ff 35 c8 15 11 80    	push   0x801115c8
801015e5:	ff 35 c4 15 11 80    	push   0x801115c4
801015eb:	ff 35 c0 15 11 80    	push   0x801115c0
801015f1:	ff 35 bc 15 11 80    	push   0x801115bc
801015f7:	ff 35 b8 15 11 80    	push   0x801115b8
801015fd:	ff 35 b4 15 11 80    	push   0x801115b4
80101603:	68 b8 74 10 80       	push   $0x801074b8
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 ed 30 00 00       	call   80104790 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 58 74 10 80       	push   $0x80107458
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 ea 30 00 00       	call   80104830 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 02 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 f9 10 80       	push   $0x8010f960
8010176f:	e8 5c 2f 00 00       	call   801046d0 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010177f:	e8 ec 2e 00 00       	call   80104670 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 59 2c 00 00       	call   80104410 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 03 30 00 00       	call   80104830 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 70 74 10 80       	push   $0x80107470
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 6a 74 10 80       	push   $0x8010746a
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 28 2c 00 00       	call   801044b0 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 cc 2b 00 00       	jmp    80104470 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 7f 74 10 80       	push   $0x8010747f
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 3b 2b 00 00       	call   80104410 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 81 2b 00 00       	call   80104470 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018f6:	e8 d5 2d 00 00       	call   801046d0 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 5b 2d 00 00       	jmp    80104670 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 f9 10 80       	push   $0x8010f960
80101920:	e8 ab 2d 00 00       	call   801046d0 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010192f:	e8 3c 2d 00 00       	call   80104670 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 78 2a 00 00       	call   801044b0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 21 2a 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 7f 74 10 80       	push   $0x8010747f
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 e4 2c 00 00       	call   80104830 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 e8 2b 00 00       	call   80104830 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 bd 2b 00 00       	call   801048a0 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 5e 2b 00 00       	call   801048a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 99 74 10 80       	push   $0x80107499
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 87 74 10 80       	push   $0x80107487
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 d1 1b 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 f9 10 80       	push   $0x8010f960
80101dca:	e8 01 29 00 00       	call   801046d0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dda:	e8 91 28 00 00       	call   80104670 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 f4 29 00 00       	call   80104830 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 0f 26 00 00       	call   801044b0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 ad 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 40 29 00 00       	call   80104830 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 70 25 00 00       	call   801044b0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 11 25 00 00       	call   80104470 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 2e 25 00 00       	call   801044b0 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 0b 25 00 00       	call   801044b0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 b4 24 00 00       	call   80104470 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 7f 74 10 80       	push   $0x8010747f
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 9e 28 00 00       	call   801048f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 a8 74 10 80       	push   $0x801074a8
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 0a 7b 10 80       	push   $0x80107b0a
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 14 75 10 80       	push   $0x80107514
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 0b 75 10 80       	push   $0x8010750b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 26 75 10 80       	push   $0x80107526
801021db:	68 00 16 11 80       	push   $0x80111600
801021e0:	e8 1b 23 00 00       	call   80104500 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 16 11 80       	push   $0x80111600
8010225e:	e8 6d 24 00 00       	call   801046d0 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 5e 1e 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 16 11 80       	push   $0x80111600
801022db:	e8 90 23 00 00       	call   80104670 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 ad 21 00 00       	call   801044b0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 16 11 80       	push   $0x80111600
80102338:	e8 93 23 00 00       	call   801046d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 16 11 80       	push   $0x80111600
80102378:	53                   	push   %ebx
80102379:	e8 e2 1c 00 00       	call   80104060 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 d5 22 00 00       	jmp    80104670 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 55 75 10 80       	push   $0x80107555
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 40 75 10 80       	push   $0x80107540
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 2a 75 10 80       	push   $0x8010752a
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 74 75 10 80       	push   $0x80107574
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb d0 55 11 80    	cmp    $0x801155d0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 89 22 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 16 11 80       	mov    0x80111678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 16 11 80       	push   $0x80111640
80102538:	e8 93 21 00 00       	call   801046d0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 18 21 00 00       	jmp    80104670 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 a6 75 10 80       	push   $0x801075a6
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 ac 75 10 80       	push   $0x801075ac
80102630:	68 40 16 11 80       	push   $0x80111640
80102635:	e8 c6 1e 00 00       	call   80104500 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 74 16 11 80       	mov    0x80111674,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 16 11 80       	push   $0x80111640
801026c3:	e8 08 20 00 00       	call   801046d0 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026cd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 16 11 80       	push   $0x80111640
801026f1:	e8 7a 1f 00 00       	call   80104670 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 e0 76 10 80 	movzbl -0x7fef8920(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 e0 75 10 80 	movzbl -0x7fef8a20(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 c0 75 10 80 	mov    -0x7fef8a40(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave  
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 e0 76 10 80 	movzbl -0x7fef8920(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave  
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret    
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 80 16 11 80       	mov    0x80111680,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 16 11 80       	mov    0x80111680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret    
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret    
80102913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 d4 1c 00 00       	call   801047e0 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 16 11 80    	push   0x801116e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c14:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 f7 1b 00 00       	call   80104830 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 16 11 80    	push   0x801116d4
80102c7d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 e0 77 10 80       	push   $0x801077e0
80102cdf:	68 a0 16 11 80       	push   $0x801116a0
80102ce4:	e8 17 18 00 00       	call   80104500 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 3b e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d07:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 16 11 80       	push   $0x801116a0
80102d7b:	e8 50 19 00 00       	call   801046d0 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 16 11 80       	push   $0x801116a0
80102d90:	68 a0 16 11 80       	push   $0x801116a0
80102d95:	e8 c6 12 00 00       	call   80104060 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102dc7:	68 a0 16 11 80       	push   $0x801116a0
80102dcc:	e8 9f 18 00 00       	call   80104670 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 16 11 80       	push   $0x801116a0
80102dee:	e8 dd 18 00 00       	call   801046d0 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 16 11 80       	push   $0x801116a0
80102e2c:	e8 3f 18 00 00       	call   80104670 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 16 11 80       	push   $0x801116a0
80102e46:	e8 85 18 00 00       	call   801046d0 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e52:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 bf 12 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e68:	e8 03 18 00 00       	call   80104670 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret    
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ea4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 67 19 00 00       	call   80104830 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 16 11 80       	push   $0x801116a0
80102f18:	e8 03 12 00 00       	call   80104120 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f24:	e8 47 17 00 00       	call   80104670 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 e4 77 10 80       	push   $0x801077e4
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 16 11 80       	push   $0x801116a0
80102f86:	e8 45 17 00 00       	call   801046d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 a6 16 00 00       	jmp    80104670 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 f3 77 10 80       	push   $0x801077f3
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 09 78 10 80       	push   $0x80107809
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 54 09 00 00       	call   80103970 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 4d 09 00 00       	call   80103970 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 24 78 10 80       	push   $0x80107824
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 49 2a 00 00       	call   80105a80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 d4 08 00 00       	call   80103910 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 01 0c 00 00       	call   80103c50 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 15 3b 00 00       	call   80106b70 <switchkvm>
  seginit();
8010305b:	e8 80 3a 00 00       	call   80106ae0 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 d0 55 11 80       	push   $0x801155d0
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 ca 3f 00 00       	call   80107060 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 3b 3a 00 00       	call   80106ae0 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 b7 2c 00 00       	call   80105d70 <uartinit>
  pinit();         // process table
801030b9:	e8 32 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 3d 29 00 00       	call   80105a00 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 53 dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c a4 10 80       	push   $0x8010a48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 47 17 00 00       	call   80104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030f3:	00 00 00 
801030f6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030fb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 e2 07 00 00       	call   80103910 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010314b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 29 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 38 78 10 80       	push   $0x80107838
801031d3:	56                   	push   %esi
801031d4:	e8 07 16 00 00       	call   801047e0 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 3d 78 10 80       	push   $0x8010783d
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 4c 15 00 00       	call   801047e0 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 42 78 10 80       	push   $0x80107842
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 38 78 10 80       	push   $0x80107838
801033d7:	53                   	push   %ebx
801033d8:	e8 03 14 00 00       	call   801047e0 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 5c 78 10 80       	push   $0x8010785c
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 e0 d9 ff ff       	call   80100e40 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 d1 d9 ff ff       	call   80100e40 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 7b 78 10 80       	push   $0x8010787b
801034b8:	50                   	push   %eax
801034b9:	e8 42 10 00 00       	call   80104500 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 f1 d9 ff ff       	call   80100f00 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 df d9 ff ff       	call   80100f00 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 7c 11 00 00       	call   801046d0 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 ac 0b 00 00       	call   80104120 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 d7 10 00 00       	jmp    80104670 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 c7 10 00 00       	call   80104670 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 47 0b 00 00       	call   80104120 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 de 10 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 53 03 00 00       	call   80103990 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 d3 0a 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 0a 0a 00 00       	call   80104060 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 ef 0f 00 00       	call   80104670 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 51 0a 00 00       	call   80104120 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 99 0f 00 00       	call   80104670 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 d5 0f 00 00       	call   801046d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 7b 02 00 00       	call   80103990 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 36 09 00 00       	call   80104060 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 95 09 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 dd 0e 00 00       	call   80104670 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 c2 0e 00 00       	call   80104670 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 20 1d 11 80       	push   $0x80111d20
801037d1:	e8 fa 0e 00 00       	call   801046d0 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 14                	jmp    801037ef <allocproc+0x2f>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	83 eb 80             	sub    $0xffffff80,%ebx
801037e3:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801037e9:	0f 84 81 00 00 00    	je     80103870 <allocproc+0xb0>
    if(p->state == UNUSED)
801037ef:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f2:	85 c0                	test   %eax,%eax
801037f4:	75 ea                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f6:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10;

  release(&ptable.lock);
801037fb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;
80103805:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
8010380c:	89 43 10             	mov    %eax,0x10(%ebx)
8010380f:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103812:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103817:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010381d:	e8 4e 0e 00 00       	call   80104670 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103822:	e8 69 ee ff ff       	call   80102690 <kalloc>
80103827:	83 c4 10             	add    $0x10,%esp
8010382a:	89 43 08             	mov    %eax,0x8(%ebx)
8010382d:	85 c0                	test   %eax,%eax
8010382f:	74 58                	je     80103889 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103831:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103837:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103842:	c7 40 14 ef 59 10 80 	movl   $0x801059ef,0x14(%eax)
  p->context = (struct context*)sp;
80103849:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384c:	6a 14                	push   $0x14
8010384e:	6a 00                	push   $0x0
80103850:	50                   	push   %eax
80103851:	e8 3a 0f 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103859:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010385c:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103863:	89 d8                	mov    %ebx,%eax
80103865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103868:	c9                   	leave  
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103873:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103875:	68 20 1d 11 80       	push   $0x80111d20
8010387a:	e8 f1 0d 00 00       	call   80104670 <release>
}
8010387f:	89 d8                	mov    %ebx,%eax
  return 0;
80103881:	83 c4 10             	add    $0x10,%esp
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
    p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103890:	31 db                	xor    %ebx,%ebx
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 20 1d 11 80       	push   $0x80111d20
801038ab:	e8 c0 0d 00 00       	call   80104670 <release>

  if (first) {
801038b0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
    first = 0;
801038c0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038c7:	00 00 00 
    iinit(ROOTDEV);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	6a 01                	push   $0x1
801038cf:	e8 9c dc ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 f0 f3 ff ff       	call   80102cd0 <initlog>
}
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 80 78 10 80       	push   $0x80107880
801038fb:	68 20 1d 11 80       	push   $0x80111d20
80103900:	e8 fb 0b 00 00       	call   80104500 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 46                	jne    80103962 <mycpu+0x52>
  apicid = lapicid();
8010391c:	e8 df ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 2a                	jle    80103955 <mycpu+0x45>
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	eb 08                	jmp    80103937 <mycpu+0x27>
8010392f:	90                   	nop
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 1e                	je     80103955 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103937:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010393d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103944:	39 c3                	cmp    %eax,%ebx
80103946:	75 e8                	jne    80103930 <mycpu+0x20>
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010394b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103951:	5b                   	pop    %ebx
80103952:	5e                   	pop    %esi
80103953:	5d                   	pop    %ebp
80103954:	c3                   	ret    
  panic("unknown apicid\n");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 87 78 10 80       	push   $0x80107887
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 b4 79 10 80       	push   $0x801079b4
8010396a:	e8 11 ca ff ff       	call   80100380 <panic>
8010396f:	90                   	nop

80103970 <cpuid>:
cpuid() {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103976:	e8 95 ff ff ff       	call   80103910 <mycpu>
}
8010397b:	c9                   	leave  
  return mycpu()-cpus;
8010397c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103981:	c1 f8 04             	sar    $0x4,%eax
80103984:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398a:	c3                   	ret    
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <myproc>:
myproc(void) {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103997:	e8 e4 0b 00 00       	call   80104580 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 24 0c 00 00       	call   801045d0 <popcli>
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <userinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039c7:	e8 f4 fd ff ff       	call   801037c0 <allocproc>
801039cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ce:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if((p->pgdir = setupkvm()) == 0)
801039d3:	e8 08 36 00 00       	call   80106fe0 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 a4 10 80       	push   $0x8010a460
801039f0:	50                   	push   %eax
801039f1:	e8 9a 32 00 00       	call   80106c90 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 85 0d 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a31:	8b 43 18             	mov    0x18(%ebx),%eax
80103a34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a50:	8b 43 18             	mov    0x18(%ebx),%eax
80103a53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	68 b0 78 10 80       	push   $0x801078b0
80103a64:	50                   	push   %eax
80103a65:	e8 e6 0e 00 00       	call   80104950 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 b9 78 10 80 	movl   $0x801078b9,(%esp)
80103a71:	e8 3a e6 ff ff       	call   801020b0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a80:	e8 4b 0c 00 00       	call   801046d0 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a93:	e8 d8 0b 00 00       	call   80104670 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 97 78 10 80       	push   $0x80107897
80103aa8:	e8 d3 c8 ff ff       	call   80100380 <panic>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <growproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ab8:	e8 c3 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 03 0b 00 00       	call   801045d0 <popcli>
  sz = curproc->sz;
80103acd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103acf:	85 f6                	test   %esi,%esi
80103ad1:	7f 1d                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad3:	75 3b                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ad8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ada:	53                   	push   %ebx
80103adb:	e8 a0 30 00 00       	call   80106b80 <switchuvm>
  return 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	31 c0                	xor    %eax,%eax
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 01 33 00 00       	call   80106e00 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 cf                	jne    80103ad5 <growproc+0x25>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb d8                	jmp    80103ae5 <growproc+0x35>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 11 34 00 00       	call   80106f30 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 af                	jne    80103ad5 <growproc+0x25>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b39:	e8 42 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 82 0a 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103b4e:	e8 6d fc ff ff       	call   801037c0 <allocproc>
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 b7 00 00 00    	je     80103c15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	ff 33                	push   (%ebx)
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	ff 73 04             	push   0x4(%ebx)
80103b68:	e8 63 35 00 00       	call   801070d0 <copyuvm>
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	89 47 04             	mov    %eax,0x4(%edi)
80103b73:	85 c0                	test   %eax,%eax
80103b75:	0f 84 a1 00 00 00    	je     80103c1c <fork+0xec>
  np->sz = curproc->sz;
80103b7b:	8b 03                	mov    (%ebx),%eax
80103b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
80103b87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b96:	8b 40 18             	mov    0x18(%eax),%eax
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 ff d2 ff ff       	call   80100eb0 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 8f db ff ff       	call   80101760 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 6a 0d 00 00       	call   80104950 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bf0:	e8 db 0a 00 00       	call   801046d0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c03:	e8 68 0a 00 00       	call   80104670 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xdb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 08             	push   0x8(%ebx)
80103c25:	e8 a6 e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xdb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c59:	e8 b2 fc ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6a:	8d 78 04             	lea    0x4(%eax),%edi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c74:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c79:	68 20 1d 11 80       	push   $0x80111d20
80103c7e:	e8 4d 0a 00 00       	call   801046d0 <acquire>
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 db 2e 00 00       	call   80106b80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	push   0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 f4 0c 00 00       	call   801049ab <swtch>
      switchkvm();
80103cb7:	e8 b4 2e 00 00       	call   80106b70 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccc:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103cd2:	75 bc                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 20 1d 11 80       	push   $0x80111d20
80103cdc:	e8 8f 09 00 00       	call   80104670 <release>
    sti();
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	eb 8a                	jmp    80103c70 <scheduler+0x20>
80103ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi

80103cf0 <sched>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
  pushcli();
80103cf5:	e8 86 08 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103cfa:	e8 11 fc ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103cff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d05:	e8 c6 08 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 20 1d 11 80       	push   $0x80111d20
80103d12:	e8 19 09 00 00       	call   80104630 <holding>
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 4f                	je     80103d6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d1e:	e8 ed fb ff ff       	call   80103910 <mycpu>
80103d23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2a:	75 68                	jne    80103d94 <sched+0xa4>
  if(p->state == RUNNING)
80103d2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d30:	74 55                	je     80103d87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d32:	9c                   	pushf  
80103d33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d34:	f6 c4 02             	test   $0x2,%ah
80103d37:	75 41                	jne    80103d7a <sched+0x8a>
  intena = mycpu()->intena;
80103d39:	e8 d2 fb ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d47:	e8 c4 fb ff ff       	call   80103910 <mycpu>
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	ff 70 04             	push   0x4(%eax)
80103d52:	53                   	push   %ebx
80103d53:	e8 53 0c 00 00       	call   801049ab <swtch>
  mycpu()->intena = intena;
80103d58:	e8 b3 fb ff ff       	call   80103910 <mycpu>
}
80103d5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d69:	5b                   	pop    %ebx
80103d6a:	5e                   	pop    %esi
80103d6b:	5d                   	pop    %ebp
80103d6c:	c3                   	ret    
    panic("sched ptable.lock");
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	68 bb 78 10 80       	push   $0x801078bb
80103d75:	e8 06 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 e7 78 10 80       	push   $0x801078e7
80103d82:	e8 f9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 d9 78 10 80       	push   $0x801078d9
80103d8f:	e8 ec c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 cd 78 10 80       	push   $0x801078cd
80103d9c:	e8 df c5 ff ff       	call   80100380 <panic>
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <exit>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103db9:	e8 d2 fb ff ff       	call   80103990 <myproc>
  if(curproc == initproc)
80103dbe:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103dc4:	0f 84 fd 00 00 00    	je     80103ec7 <exit+0x117>
80103dca:	89 c3                	mov    %eax,%ebx
80103dcc:	8d 70 28             	lea    0x28(%eax),%esi
80103dcf:	8d 78 68             	lea    0x68(%eax),%edi
80103dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dd8:	8b 06                	mov    (%esi),%eax
80103dda:	85 c0                	test   %eax,%eax
80103ddc:	74 12                	je     80103df0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	50                   	push   %eax
80103de2:	e8 19 d1 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103de7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ded:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103df0:	83 c6 04             	add    $0x4,%esi
80103df3:	39 f7                	cmp    %esi,%edi
80103df5:	75 e1                	jne    80103dd8 <exit+0x28>
  begin_op();
80103df7:	e8 74 ef ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103dfc:	83 ec 0c             	sub    $0xc,%esp
80103dff:	ff 73 68             	push   0x68(%ebx)
80103e02:	e8 b9 da ff ff       	call   801018c0 <iput>
  end_op();
80103e07:	e8 d4 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103e0c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e13:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e1a:	e8 b1 08 00 00       	call   801046d0 <acquire>
  wakeup1(curproc->parent);
80103e1f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e22:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e25:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e2a:	eb 0e                	jmp    80103e3a <exit+0x8a>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	83 e8 80             	sub    $0xffffff80,%eax
80103e33:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e38:	74 1c                	je     80103e56 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e3e:	75 f0                	jne    80103e30 <exit+0x80>
80103e40:	3b 50 20             	cmp    0x20(%eax),%edx
80103e43:	75 eb                	jne    80103e30 <exit+0x80>
      p->state = RUNNABLE;
80103e45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e4c:	83 e8 80             	sub    $0xffffff80,%eax
80103e4f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e54:	75 e4                	jne    80103e3a <exit+0x8a>
      p->parent = initproc;
80103e56:	8b 0d 54 3d 11 80    	mov    0x80113d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e61:	eb 10                	jmp    80103e73 <exit+0xc3>
80103e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e67:	90                   	nop
80103e68:	83 ea 80             	sub    $0xffffff80,%edx
80103e6b:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80103e71:	74 3b                	je     80103eae <exit+0xfe>
    if(p->parent == curproc){
80103e73:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e76:	75 f0                	jne    80103e68 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e78:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e7c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e7f:	75 e7                	jne    80103e68 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e81:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e86:	eb 12                	jmp    80103e9a <exit+0xea>
80103e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop
80103e90:	83 e8 80             	sub    $0xffffff80,%eax
80103e93:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e98:	74 ce                	je     80103e68 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e9e:	75 f0                	jne    80103e90 <exit+0xe0>
80103ea0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ea3:	75 eb                	jne    80103e90 <exit+0xe0>
      p->state = RUNNABLE;
80103ea5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eac:	eb e2                	jmp    80103e90 <exit+0xe0>
  curproc->state = ZOMBIE;
80103eae:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103eb5:	e8 36 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 08 79 10 80       	push   $0x80107908
80103ec2:	e8 b9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 fb 78 10 80       	push   $0x801078fb
80103ecf:	e8 ac c4 ff ff       	call   80100380 <panic>
80103ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 96 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103eea:	e8 21 fa ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 d6 06 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 1d 11 80       	push   $0x80111d20
80103f02:	e8 c9 07 00 00       	call   801046d0 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f11:	eb 10                	jmp    80103f23 <wait+0x43>
80103f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f17:	90                   	nop
80103f18:	83 eb 80             	sub    $0xffffff80,%ebx
80103f1b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f21:	74 1b                	je     80103f3e <wait+0x5e>
      if(p->parent != curproc)
80103f23:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f26:	75 f0                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f28:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f2c:	74 62                	je     80103f90 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103f31:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f36:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f3c:	75 e5                	jne    80103f23 <wait+0x43>
    if(!havekids || curproc->killed){
80103f3e:	85 c0                	test   %eax,%eax
80103f40:	0f 84 a0 00 00 00    	je     80103fe6 <wait+0x106>
80103f46:	8b 46 24             	mov    0x24(%esi),%eax
80103f49:	85 c0                	test   %eax,%eax
80103f4b:	0f 85 95 00 00 00    	jne    80103fe6 <wait+0x106>
  pushcli();
80103f51:	e8 2a 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103f56:	e8 b5 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f61:	e8 6a 06 00 00       	call   801045d0 <popcli>
  if(p == 0)
80103f66:	85 db                	test   %ebx,%ebx
80103f68:	0f 84 8f 00 00 00    	je     80103ffd <wait+0x11d>
  p->chan = chan;
80103f6e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f71:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f78:	e8 73 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103f7d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f84:	eb 84                	jmp    80103f0a <wait+0x2a>
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f90:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f93:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f96:	ff 73 08             	push   0x8(%ebx)
80103f99:	e8 32 e5 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
80103f9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fa5:	5a                   	pop    %edx
80103fa6:	ff 73 04             	push   0x4(%ebx)
80103fa9:	e8 b2 2f 00 00       	call   80106f60 <freevm>
        p->pid = 0;
80103fae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fb5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fbc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fc0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fce:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fd5:	e8 96 06 00 00       	call   80104670 <release>
        return pid;
80103fda:	83 c4 10             	add    $0x10,%esp
}
80103fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe0:	89 f0                	mov    %esi,%eax
80103fe2:	5b                   	pop    %ebx
80103fe3:	5e                   	pop    %esi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
      release(&ptable.lock);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fe9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fee:	68 20 1d 11 80       	push   $0x80111d20
80103ff3:	e8 78 06 00 00       	call   80104670 <release>
      return -1;
80103ff8:	83 c4 10             	add    $0x10,%esp
80103ffb:	eb e0                	jmp    80103fdd <wait+0xfd>
    panic("sleep");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 14 79 10 80       	push   $0x80107914
80104005:	e8 76 c3 ff ff       	call   80100380 <panic>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <yield>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104017:	68 20 1d 11 80       	push   $0x80111d20
8010401c:	e8 af 06 00 00       	call   801046d0 <acquire>
  pushcli();
80104021:	e8 5a 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104026:	e8 e5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010402b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104031:	e8 9a 05 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
80104036:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010403d:	e8 ae fc ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80104042:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104049:	e8 22 06 00 00       	call   80104670 <release>
}
8010404e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	c9                   	leave  
80104055:	c3                   	ret    
80104056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405d:	8d 76 00             	lea    0x0(%esi),%esi

80104060 <sleep>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
80104069:	8b 7d 08             	mov    0x8(%ebp),%edi
8010406c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010406f:	e8 0c 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104074:	e8 97 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104079:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010407f:	e8 4c 05 00 00       	call   801045d0 <popcli>
  if(p == 0)
80104084:	85 db                	test   %ebx,%ebx
80104086:	0f 84 87 00 00 00    	je     80104113 <sleep+0xb3>
  if(lk == 0)
8010408c:	85 f6                	test   %esi,%esi
8010408e:	74 76                	je     80104106 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104090:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104096:	74 50                	je     801040e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 20 1d 11 80       	push   $0x80111d20
801040a0:	e8 2b 06 00 00       	call   801046d0 <acquire>
    release(lk);
801040a5:	89 34 24             	mov    %esi,(%esp)
801040a8:	e8 c3 05 00 00       	call   80104670 <release>
  p->chan = chan;
801040ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b7:	e8 34 fc ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040ca:	e8 a1 05 00 00       	call   80104670 <release>
    acquire(lk);
801040cf:	89 75 08             	mov    %esi,0x8(%ebp)
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
    acquire(lk);
801040dc:	e9 ef 05 00 00       	jmp    801046d0 <acquire>
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040f2:	e8 f9 fb ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104101:	5b                   	pop    %ebx
80104102:	5e                   	pop    %esi
80104103:	5f                   	pop    %edi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
    panic("sleep without lk");
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	68 1a 79 10 80       	push   $0x8010791a
8010410e:	e8 6d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 14 79 10 80       	push   $0x80107914
8010411b:	e8 60 c2 ff ff       	call   80100380 <panic>

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
80104127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412a:	68 20 1d 11 80       	push   $0x80111d20
8010412f:	e8 9c 05 00 00       	call   801046d0 <acquire>
80104134:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104137:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010413c:	eb 0c                	jmp    8010414a <wakeup+0x2a>
8010413e:	66 90                	xchg   %ax,%ax
80104140:	83 e8 80             	sub    $0xffffff80,%eax
80104143:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104148:	74 1c                	je     80104166 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010414a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010414e:	75 f0                	jne    80104140 <wakeup+0x20>
80104150:	3b 58 20             	cmp    0x20(%eax),%ebx
80104153:	75 eb                	jne    80104140 <wakeup+0x20>
      p->state = RUNNABLE;
80104155:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415c:	83 e8 80             	sub    $0xffffff80,%eax
8010415f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104164:	75 e4                	jne    8010414a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104166:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010416d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104170:	c9                   	leave  
  release(&ptable.lock);
80104171:	e9 fa 04 00 00       	jmp    80104670 <release>
80104176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417d:	8d 76 00             	lea    0x0(%esi),%esi

80104180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010418a:	68 20 1d 11 80       	push   $0x80111d20
8010418f:	e8 3c 05 00 00       	call   801046d0 <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104197:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010419c:	eb 0c                	jmp    801041aa <kill+0x2a>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	83 e8 80             	sub    $0xffffff80,%eax
801041a3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801041a8:	74 36                	je     801041e0 <kill+0x60>
    if(p->pid == pid){
801041aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ad:	75 f1                	jne    801041a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ba:	75 07                	jne    801041c3 <kill+0x43>
        p->state = RUNNABLE;
801041bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	68 20 1d 11 80       	push   $0x80111d20
801041cb:	e8 a0 04 00 00       	call   80104670 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041d3:	83 c4 10             	add    $0x10,%esp
801041d6:	31 c0                	xor    %eax,%eax
}
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 20 1d 11 80       	push   $0x80111d20
801041e8:	e8 83 04 00 00       	call   80104670 <release>
}
801041ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104208:	53                   	push   %ebx
80104209:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010420e:	83 ec 3c             	sub    $0x3c,%esp
80104211:	eb 24                	jmp    80104237 <procdump+0x37>
80104213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104217:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 23 7d 10 80       	push   $0x80107d23
80104220:	e8 7b c4 ff ff       	call   801006a0 <cprintf>
80104225:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104228:	83 eb 80             	sub    $0xffffff80,%ebx
8010422b:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104231:	0f 84 81 00 00 00    	je     801042b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104237:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010423a:	85 c0                	test   %eax,%eax
8010423c:	74 ea                	je     80104228 <procdump+0x28>
      state = "???";
8010423e:	ba 2b 79 10 80       	mov    $0x8010792b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104243:	83 f8 05             	cmp    $0x5,%eax
80104246:	77 11                	ja     80104259 <procdump+0x59>
80104248:	8b 14 85 fc 79 10 80 	mov    -0x7fef8604(,%eax,4),%edx
      state = "???";
8010424f:	b8 2b 79 10 80       	mov    $0x8010792b,%eax
80104254:	85 d2                	test   %edx,%edx
80104256:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104259:	53                   	push   %ebx
8010425a:	52                   	push   %edx
8010425b:	ff 73 a4             	push   -0x5c(%ebx)
8010425e:	68 2f 79 10 80       	push   $0x8010792f
80104263:	e8 38 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104268:	83 c4 10             	add    $0x10,%esp
8010426b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010426f:	75 a7                	jne    80104218 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104271:	83 ec 08             	sub    $0x8,%esp
80104274:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104277:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010427a:	50                   	push   %eax
8010427b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010427e:	8b 40 0c             	mov    0xc(%eax),%eax
80104281:	83 c0 08             	add    $0x8,%eax
80104284:	50                   	push   %eax
80104285:	e8 96 02 00 00       	call   80104520 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010428a:	83 c4 10             	add    $0x10,%esp
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
80104290:	8b 17                	mov    (%edi),%edx
80104292:	85 d2                	test   %edx,%edx
80104294:	74 82                	je     80104218 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104296:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104299:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010429c:	52                   	push   %edx
8010429d:	68 81 73 10 80       	push   $0x80107381
801042a2:	e8 f9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042a7:	83 c4 10             	add    $0x10,%esp
801042aa:	39 fe                	cmp    %edi,%esi
801042ac:	75 e2                	jne    80104290 <procdump+0x90>
801042ae:	e9 65 ff ff ff       	jmp    80104218 <procdump+0x18>
801042b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b7:	90                   	nop
  }
}
801042b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042bb:	5b                   	pop    %ebx
801042bc:	5e                   	pop    %esi
801042bd:	5f                   	pop    %edi
801042be:	5d                   	pop    %ebp
801042bf:	c3                   	ret    

801042c0 <cps>:

int
cps()
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
801042c7:	fb                   	sti    
struct proc *p;
//Enables interrupts on this processor.
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
801042c8:	68 20 1d 11 80       	push   $0x80111d20
801042cd:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801042d2:	e8 f9 03 00 00       	call   801046d0 <acquire>
cprintf("name \t pid \t ppid \t state \t priority \n");
801042d7:	c7 04 24 dc 79 10 80 	movl   $0x801079dc,(%esp)
801042de:	e8 bd c3 ff ff       	call   801006a0 <cprintf>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e3:	83 c4 10             	add    $0x10,%esp
801042e6:	eb 1d                	jmp    80104305 <cps+0x45>
801042e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop
  if(p->state == SLEEPING)
	  cprintf("%s \t %d \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
	else if(p->state == RUNNING)
801042f0:	83 f8 04             	cmp    $0x4,%eax
801042f3:	74 53                	je     80104348 <cps+0x88>
 	  cprintf("%s \t %d \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
	else if(p->state == RUNNABLE)
801042f5:	83 f8 03             	cmp    $0x3,%eax
801042f8:	74 66                	je     80104360 <cps+0xa0>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fa:	83 eb 80             	sub    $0xffffff80,%ebx
801042fd:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104303:	74 27                	je     8010432c <cps+0x6c>
  if(p->state == SLEEPING)
80104305:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104308:	83 f8 02             	cmp    $0x2,%eax
8010430b:	75 e3                	jne    801042f0 <cps+0x30>
	  cprintf("%s \t %d \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
8010430d:	ff 73 10             	push   0x10(%ebx)
80104310:	ff 73 a4             	push   -0x5c(%ebx)
80104313:	53                   	push   %ebx
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104314:	83 eb 80             	sub    $0xffffff80,%ebx
	  cprintf("%s \t %d \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
80104317:	68 38 79 10 80       	push   $0x80107938
8010431c:	e8 7f c3 ff ff       	call   801006a0 <cprintf>
80104321:	83 c4 10             	add    $0x10,%esp
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104324:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
8010432a:	75 d9                	jne    80104305 <cps+0x45>
 	  cprintf("%s \t %d \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
}
release(&ptable.lock);
8010432c:	83 ec 0c             	sub    $0xc,%esp
8010432f:	68 20 1d 11 80       	push   $0x80111d20
80104334:	e8 37 03 00 00       	call   80104670 <release>
return 22;
}
80104339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010433c:	b8 16 00 00 00       	mov    $0x16,%eax
80104341:	c9                   	leave  
80104342:	c3                   	ret    
80104343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104347:	90                   	nop
 	  cprintf("%s \t %d \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
80104348:	ff 73 10             	push   0x10(%ebx)
8010434b:	ff 73 a4             	push   -0x5c(%ebx)
8010434e:	53                   	push   %ebx
8010434f:	68 53 79 10 80       	push   $0x80107953
80104354:	e8 47 c3 ff ff       	call   801006a0 <cprintf>
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	eb 9c                	jmp    801042fa <cps+0x3a>
8010435e:	66 90                	xchg   %ax,%ax
 	  cprintf("%s \t %d \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->parent->pid,p->priority);
80104360:	ff 73 10             	push   0x10(%ebx)
80104363:	ff 73 a4             	push   -0x5c(%ebx)
80104366:	53                   	push   %ebx
80104367:	68 6d 79 10 80       	push   $0x8010796d
8010436c:	e8 2f c3 ff ff       	call   801006a0 <cprintf>
80104371:	83 c4 10             	add    $0x10,%esp
80104374:	eb 84                	jmp    801042fa <cps+0x3a>
80104376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <chpr>:

int 
chpr(int pid, int priority)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *p;
	acquire(&ptable.lock);
8010438a:	68 20 1d 11 80       	push   $0x80111d20
8010438f:	e8 3c 03 00 00       	call   801046d0 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104397:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010439c:	eb 0c                	jmp    801043aa <chpr+0x2a>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	83 e8 80             	sub    $0xffffff80,%eax
801043a3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801043a8:	74 0b                	je     801043b5 <chpr+0x35>
	  if(p->pid == pid){
801043aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801043ad:	75 f1                	jne    801043a0 <chpr+0x20>
			p->priority = priority;
801043af:	8b 55 0c             	mov    0xc(%ebp),%edx
801043b2:	89 50 7c             	mov    %edx,0x7c(%eax)
			break;
		}
	}
	release(&ptable.lock);
801043b5:	83 ec 0c             	sub    $0xc,%esp
801043b8:	68 20 1d 11 80       	push   $0x80111d20
801043bd:	e8 ae 02 00 00       	call   80104670 <release>
	return pid;
}
801043c2:	89 d8                	mov    %ebx,%eax
801043c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c7:	c9                   	leave  
801043c8:	c3                   	ret    
801043c9:	66 90                	xchg   %ax,%ax
801043cb:	66 90                	xchg   %ax,%ax
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043da:	68 14 7a 10 80       	push   $0x80107a14
801043df:	8d 43 04             	lea    0x4(%ebx),%eax
801043e2:	50                   	push   %eax
801043e3:	e8 18 01 00 00       	call   80104500 <initlock>
  lk->name = name;
801043e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104401:	c9                   	leave  
80104402:	c3                   	ret    
80104403:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	8d 73 04             	lea    0x4(%ebx),%esi
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	56                   	push   %esi
8010441f:	e8 ac 02 00 00       	call   801046d0 <acquire>
  while (lk->locked) {
80104424:	8b 13                	mov    (%ebx),%edx
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	85 d2                	test   %edx,%edx
8010442b:	74 16                	je     80104443 <acquiresleep+0x33>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104430:	83 ec 08             	sub    $0x8,%esp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	e8 26 fc ff ff       	call   80104060 <sleep>
  while (lk->locked) {
8010443a:	8b 03                	mov    (%ebx),%eax
8010443c:	83 c4 10             	add    $0x10,%esp
8010443f:	85 c0                	test   %eax,%eax
80104441:	75 ed                	jne    80104430 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104443:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104449:	e8 42 f5 ff ff       	call   80103990 <myproc>
8010444e:	8b 40 10             	mov    0x10(%eax),%eax
80104451:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104454:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445a:	5b                   	pop    %ebx
8010445b:	5e                   	pop    %esi
8010445c:	5d                   	pop    %ebp
  release(&lk->lk);
8010445d:	e9 0e 02 00 00       	jmp    80104670 <release>
80104462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104478:	8d 73 04             	lea    0x4(%ebx),%esi
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	56                   	push   %esi
8010447f:	e8 4c 02 00 00       	call   801046d0 <acquire>
  lk->locked = 0;
80104484:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010448a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104491:	89 1c 24             	mov    %ebx,(%esp)
80104494:	e8 87 fc ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
80104499:	89 75 08             	mov    %esi,0x8(%ebp)
8010449c:	83 c4 10             	add    $0x10,%esp
}
8010449f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
  release(&lk->lk);
801044a5:	e9 c6 01 00 00       	jmp    80104670 <release>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	31 ff                	xor    %edi,%edi
801044b6:	56                   	push   %esi
801044b7:	53                   	push   %ebx
801044b8:	83 ec 18             	sub    $0x18,%esp
801044bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044be:	8d 73 04             	lea    0x4(%ebx),%esi
801044c1:	56                   	push   %esi
801044c2:	e8 09 02 00 00       	call   801046d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044c7:	8b 03                	mov    (%ebx),%eax
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	85 c0                	test   %eax,%eax
801044ce:	75 18                	jne    801044e8 <holdingsleep+0x38>
  release(&lk->lk);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	56                   	push   %esi
801044d4:	e8 97 01 00 00       	call   80104670 <release>
  return r;
}
801044d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044dc:	89 f8                	mov    %edi,%eax
801044de:	5b                   	pop    %ebx
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801044e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044eb:	e8 a0 f4 ff ff       	call   80103990 <myproc>
801044f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801044f3:	0f 94 c0             	sete   %al
801044f6:	0f b6 c0             	movzbl %al,%eax
801044f9:	89 c7                	mov    %eax,%edi
801044fb:	eb d3                	jmp    801044d0 <holdingsleep+0x20>
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104506:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010450f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010451f:	90                   	nop

80104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104520:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104521:	31 d2                	xor    %edx,%edx
{
80104523:	89 e5                	mov    %esp,%ebp
80104525:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104526:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010452c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010452f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104530:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104536:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010453c:	77 1a                	ja     80104558 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010453e:	8b 58 04             	mov    0x4(%eax),%ebx
80104541:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104544:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104547:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104549:	83 fa 0a             	cmp    $0xa,%edx
8010454c:	75 e2                	jne    80104530 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010454e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104551:	c9                   	leave  
80104552:	c3                   	ret    
80104553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104557:	90                   	nop
  for(; i < 10; i++)
80104558:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010455b:	8d 51 28             	lea    0x28(%ecx),%edx
8010455e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104566:	83 c0 04             	add    $0x4,%eax
80104569:	39 d0                	cmp    %edx,%eax
8010456b:	75 f3                	jne    80104560 <getcallerpcs+0x40>
}
8010456d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104570:	c9                   	leave  
80104571:	c3                   	ret    
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104587:	9c                   	pushf  
80104588:	5b                   	pop    %ebx
  asm volatile("cli");
80104589:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458a:	e8 81 f3 ff ff       	call   80103910 <mycpu>
8010458f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	74 17                	je     801045b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104599:	e8 72 f3 ff ff       	call   80103910 <mycpu>
8010459e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a8:	c9                   	leave  
801045a9:	c3                   	ret    
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045b0:	e8 5b f3 ff ff       	call   80103910 <mycpu>
801045b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045c1:	eb d6                	jmp    80104599 <pushcli+0x19>
801045c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf  
801045d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045d8:	f6 c4 02             	test   $0x2,%ah
801045db:	75 35                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045dd:	e8 2e f3 ff ff       	call   80103910 <mycpu>
801045e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045e9:	78 34                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045eb:	e8 20 f3 ff ff       	call   80103910 <mycpu>
801045f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045f6:	85 d2                	test   %edx,%edx
801045f8:	74 06                	je     80104600 <popcli+0x30>
    sti();
}
801045fa:	c9                   	leave  
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 0b f3 ff ff       	call   80103910 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 eb                	je     801045fa <popcli+0x2a>
  asm volatile("sti");
8010460f:	fb                   	sti    
}
80104610:	c9                   	leave  
80104611:	c3                   	ret    
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 1f 7a 10 80       	push   $0x80107a1f
8010461a:	e8 61 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 36 7a 10 80       	push   $0x80107a36
80104627:	e8 54 bd ff ff       	call   80100380 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <holding>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 75 08             	mov    0x8(%ebp),%esi
80104638:	31 db                	xor    %ebx,%ebx
  pushcli();
8010463a:	e8 41 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010463f:	8b 06                	mov    (%esi),%eax
80104641:	85 c0                	test   %eax,%eax
80104643:	75 0b                	jne    80104650 <holding+0x20>
  popcli();
80104645:	e8 86 ff ff ff       	call   801045d0 <popcli>
}
8010464a:	89 d8                	mov    %ebx,%eax
8010464c:	5b                   	pop    %ebx
8010464d:	5e                   	pop    %esi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104650:	8b 5e 08             	mov    0x8(%esi),%ebx
80104653:	e8 b8 f2 ff ff       	call   80103910 <mycpu>
80104658:	39 c3                	cmp    %eax,%ebx
8010465a:	0f 94 c3             	sete   %bl
  popcli();
8010465d:	e8 6e ff ff ff       	call   801045d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104662:	0f b6 db             	movzbl %bl,%ebx
}
80104665:	89 d8                	mov    %ebx,%eax
80104667:	5b                   	pop    %ebx
80104668:	5e                   	pop    %esi
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret    
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <release>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104678:	e8 03 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010467d:	8b 03                	mov    (%ebx),%eax
8010467f:	85 c0                	test   %eax,%eax
80104681:	75 15                	jne    80104698 <release+0x28>
  popcli();
80104683:	e8 48 ff ff ff       	call   801045d0 <popcli>
    panic("release");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 3d 7a 10 80       	push   $0x80107a3d
80104690:	e8 eb bc ff ff       	call   80100380 <panic>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104698:	8b 73 08             	mov    0x8(%ebx),%esi
8010469b:	e8 70 f2 ff ff       	call   80103910 <mycpu>
801046a0:	39 c6                	cmp    %eax,%esi
801046a2:	75 df                	jne    80104683 <release+0x13>
  popcli();
801046a4:	e8 27 ff ff ff       	call   801045d0 <popcli>
  lk->pcs[0] = 0;
801046a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c5:	5b                   	pop    %ebx
801046c6:	5e                   	pop    %esi
801046c7:	5d                   	pop    %ebp
  popcli();
801046c8:	e9 03 ff ff ff       	jmp    801045d0 <popcli>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi

801046d0 <acquire>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046d7:	e8 a4 fe ff ff       	call   80104580 <pushcli>
  if(holding(lk))
801046dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046df:	e8 9c fe ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046e4:	8b 03                	mov    (%ebx),%eax
801046e6:	85 c0                	test   %eax,%eax
801046e8:	75 7e                	jne    80104768 <acquire+0x98>
  popcli();
801046ea:	e8 e1 fe ff ff       	call   801045d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801046f8:	8b 55 08             	mov    0x8(%ebp),%edx
801046fb:	89 c8                	mov    %ecx,%eax
801046fd:	f0 87 02             	lock xchg %eax,(%edx)
80104700:	85 c0                	test   %eax,%eax
80104702:	75 f4                	jne    801046f8 <acquire+0x28>
  __sync_synchronize();
80104704:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104709:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010470c:	e8 ff f1 ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104711:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104714:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104716:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104719:	31 c0                	xor    %eax,%eax
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104720:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104726:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010472c:	77 1a                	ja     80104748 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010472e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104731:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104735:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104738:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010473a:	83 f8 0a             	cmp    $0xa,%eax
8010473d:	75 e1                	jne    80104720 <acquire+0x50>
}
8010473f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104742:	c9                   	leave  
80104743:	c3                   	ret    
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104748:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010474c:	8d 51 34             	lea    0x34(%ecx),%edx
8010474f:	90                   	nop
    pcs[i] = 0;
80104750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104756:	83 c0 04             	add    $0x4,%eax
80104759:	39 c2                	cmp    %eax,%edx
8010475b:	75 f3                	jne    80104750 <acquire+0x80>
}
8010475d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104760:	c9                   	leave  
80104761:	c3                   	ret    
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104768:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010476b:	e8 a0 f1 ff ff       	call   80103910 <mycpu>
80104770:	39 c3                	cmp    %eax,%ebx
80104772:	0f 85 72 ff ff ff    	jne    801046ea <acquire+0x1a>
  popcli();
80104778:	e8 53 fe ff ff       	call   801045d0 <popcli>
    panic("acquire");
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 45 7a 10 80       	push   $0x80107a45
80104785:	e8 f6 bb ff ff       	call   80100380 <panic>
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	8b 55 08             	mov    0x8(%ebp),%edx
80104797:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010479a:	53                   	push   %ebx
8010479b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010479e:	89 d7                	mov    %edx,%edi
801047a0:	09 cf                	or     %ecx,%edi
801047a2:	83 e7 03             	and    $0x3,%edi
801047a5:	75 29                	jne    801047d0 <memset+0x40>
    c &= 0xFF;
801047a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047aa:	c1 e0 18             	shl    $0x18,%eax
801047ad:	89 fb                	mov    %edi,%ebx
801047af:	c1 e9 02             	shr    $0x2,%ecx
801047b2:	c1 e3 10             	shl    $0x10,%ebx
801047b5:	09 d8                	or     %ebx,%eax
801047b7:	09 f8                	or     %edi,%eax
801047b9:	c1 e7 08             	shl    $0x8,%edi
801047bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047be:	89 d7                	mov    %edx,%edi
801047c0:	fc                   	cld    
801047c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047c3:	5b                   	pop    %ebx
801047c4:	89 d0                	mov    %edx,%eax
801047c6:	5f                   	pop    %edi
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047d0:	89 d7                	mov    %edx,%edi
801047d2:	fc                   	cld    
801047d3:	f3 aa                	rep stos %al,%es:(%edi)
801047d5:	5b                   	pop    %ebx
801047d6:	89 d0                	mov    %edx,%eax
801047d8:	5f                   	pop    %edi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	8b 75 10             	mov    0x10(%ebp),%esi
801047e7:	8b 55 08             	mov    0x8(%ebp),%edx
801047ea:	53                   	push   %ebx
801047eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047ee:	85 f6                	test   %esi,%esi
801047f0:	74 2e                	je     80104820 <memcmp+0x40>
801047f2:	01 c6                	add    %eax,%esi
801047f4:	eb 14                	jmp    8010480a <memcmp+0x2a>
801047f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104806:	39 f0                	cmp    %esi,%eax
80104808:	74 16                	je     80104820 <memcmp+0x40>
    if(*s1 != *s2)
8010480a:	0f b6 0a             	movzbl (%edx),%ecx
8010480d:	0f b6 18             	movzbl (%eax),%ebx
80104810:	38 d9                	cmp    %bl,%cl
80104812:	74 ec                	je     80104800 <memcmp+0x20>
      return *s1 - *s2;
80104814:	0f b6 c1             	movzbl %cl,%eax
80104817:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
80104820:	5b                   	pop    %ebx
  return 0;
80104821:	31 c0                	xor    %eax,%eax
}
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	8b 55 08             	mov    0x8(%ebp),%edx
80104837:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483a:	56                   	push   %esi
8010483b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010483e:	39 d6                	cmp    %edx,%esi
80104840:	73 26                	jae    80104868 <memmove+0x38>
80104842:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104845:	39 fa                	cmp    %edi,%edx
80104847:	73 1f                	jae    80104868 <memmove+0x38>
80104849:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010484c:	85 c9                	test   %ecx,%ecx
8010484e:	74 0c                	je     8010485c <memmove+0x2c>
      *--d = *--s;
80104850:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104854:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104857:	83 e8 01             	sub    $0x1,%eax
8010485a:	73 f4                	jae    80104850 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010485c:	5e                   	pop    %esi
8010485d:	89 d0                	mov    %edx,%eax
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104868:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010486b:	89 d7                	mov    %edx,%edi
8010486d:	85 c9                	test   %ecx,%ecx
8010486f:	74 eb                	je     8010485c <memmove+0x2c>
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104878:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104879:	39 c6                	cmp    %eax,%esi
8010487b:	75 fb                	jne    80104878 <memmove+0x48>
}
8010487d:	5e                   	pop    %esi
8010487e:	89 d0                	mov    %edx,%eax
80104880:	5f                   	pop    %edi
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret    
80104883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104890:	eb 9e                	jmp    80104830 <memmove>
80104892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	8b 75 10             	mov    0x10(%ebp),%esi
801048a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048aa:	53                   	push   %ebx
801048ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048ae:	85 f6                	test   %esi,%esi
801048b0:	74 2e                	je     801048e0 <strncmp+0x40>
801048b2:	01 d6                	add    %edx,%esi
801048b4:	eb 18                	jmp    801048ce <strncmp+0x2e>
801048b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	38 d8                	cmp    %bl,%al
801048c2:	75 14                	jne    801048d8 <strncmp+0x38>
    n--, p++, q++;
801048c4:	83 c2 01             	add    $0x1,%edx
801048c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ca:	39 f2                	cmp    %esi,%edx
801048cc:	74 12                	je     801048e0 <strncmp+0x40>
801048ce:	0f b6 01             	movzbl (%ecx),%eax
801048d1:	0f b6 1a             	movzbl (%edx),%ebx
801048d4:	84 c0                	test   %al,%al
801048d6:	75 e8                	jne    801048c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048d8:	29 d8                	sub    %ebx,%eax
}
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax
801048e0:	5b                   	pop    %ebx
    return 0;
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	8b 75 08             	mov    0x8(%ebp),%esi
801048f8:	53                   	push   %ebx
801048f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048fc:	89 f0                	mov    %esi,%eax
801048fe:	eb 15                	jmp    80104915 <strncpy+0x25>
80104900:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104904:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104907:	83 c0 01             	add    $0x1,%eax
8010490a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010490e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104911:	84 d2                	test   %dl,%dl
80104913:	74 09                	je     8010491e <strncpy+0x2e>
80104915:	89 cb                	mov    %ecx,%ebx
80104917:	83 e9 01             	sub    $0x1,%ecx
8010491a:	85 db                	test   %ebx,%ebx
8010491c:	7f e2                	jg     80104900 <strncpy+0x10>
    ;
  while(n-- > 0)
8010491e:	89 c2                	mov    %eax,%edx
80104920:	85 c9                	test   %ecx,%ecx
80104922:	7e 17                	jle    8010493b <strncpy+0x4b>
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104928:	83 c2 01             	add    $0x1,%edx
8010492b:	89 c1                	mov    %eax,%ecx
8010492d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104931:	29 d1                	sub    %edx,%ecx
80104933:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104937:	85 c9                	test   %ecx,%ecx
80104939:	7f ed                	jg     80104928 <strncpy+0x38>
  return os;
}
8010493b:	5b                   	pop    %ebx
8010493c:	89 f0                	mov    %esi,%eax
8010493e:	5e                   	pop    %esi
8010493f:	5f                   	pop    %edi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret    
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	8b 55 10             	mov    0x10(%ebp),%edx
80104957:	8b 75 08             	mov    0x8(%ebp),%esi
8010495a:	53                   	push   %ebx
8010495b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010495e:	85 d2                	test   %edx,%edx
80104960:	7e 25                	jle    80104987 <safestrcpy+0x37>
80104962:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104966:	89 f2                	mov    %esi,%edx
80104968:	eb 16                	jmp    80104980 <safestrcpy+0x30>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104970:	0f b6 08             	movzbl (%eax),%ecx
80104973:	83 c0 01             	add    $0x1,%eax
80104976:	83 c2 01             	add    $0x1,%edx
80104979:	88 4a ff             	mov    %cl,-0x1(%edx)
8010497c:	84 c9                	test   %cl,%cl
8010497e:	74 04                	je     80104984 <safestrcpy+0x34>
80104980:	39 d8                	cmp    %ebx,%eax
80104982:	75 ec                	jne    80104970 <safestrcpy+0x20>
    ;
  *s = 0;
80104984:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104987:	89 f0                	mov    %esi,%eax
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strlen>:

int
strlen(const char *s)
{
80104990:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104991:	31 c0                	xor    %eax,%eax
{
80104993:	89 e5                	mov    %esp,%ebp
80104995:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104998:	80 3a 00             	cmpb   $0x0,(%edx)
8010499b:	74 0c                	je     801049a9 <strlen+0x19>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
801049a0:	83 c0 01             	add    $0x1,%eax
801049a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049a7:	75 f7                	jne    801049a0 <strlen+0x10>
    ;
  return n;
}
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    

801049ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049b3:	55                   	push   %ebp
  pushl %ebx
801049b4:	53                   	push   %ebx
  pushl %esi
801049b5:	56                   	push   %esi
  pushl %edi
801049b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049bb:	5f                   	pop    %edi
  popl %esi
801049bc:	5e                   	pop    %esi
  popl %ebx
801049bd:	5b                   	pop    %ebx
  popl %ebp
801049be:	5d                   	pop    %ebp
  ret
801049bf:	c3                   	ret    

801049c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ca:	e8 c1 ef ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049cf:	8b 00                	mov    (%eax),%eax
801049d1:	39 d8                	cmp    %ebx,%eax
801049d3:	76 1b                	jbe    801049f0 <fetchint+0x30>
801049d5:	8d 53 04             	lea    0x4(%ebx),%edx
801049d8:	39 d0                	cmp    %edx,%eax
801049da:	72 14                	jb     801049f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049df:	8b 13                	mov    (%ebx),%edx
801049e1:	89 10                	mov    %edx,(%eax)
  return 0;
801049e3:	31 c0                	xor    %eax,%eax
}
801049e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e8:	c9                   	leave  
801049e9:	c3                   	ret    
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f5:	eb ee                	jmp    801049e5 <fetchint+0x25>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
80104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a0a:	e8 81 ef ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
80104a0f:	39 18                	cmp    %ebx,(%eax)
80104a11:	76 2d                	jbe    80104a40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a1a:	39 d3                	cmp    %edx,%ebx
80104a1c:	73 22                	jae    80104a40 <fetchstr+0x40>
80104a1e:	89 d8                	mov    %ebx,%eax
80104a20:	eb 0d                	jmp    80104a2f <fetchstr+0x2f>
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a28:	83 c0 01             	add    $0x1,%eax
80104a2b:	39 c2                	cmp    %eax,%edx
80104a2d:	76 11                	jbe    80104a40 <fetchstr+0x40>
    if(*s == 0)
80104a2f:	80 38 00             	cmpb   $0x0,(%eax)
80104a32:	75 f4                	jne    80104a28 <fetchstr+0x28>
      return s - *pp;
80104a34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a39:	c9                   	leave  
80104a3a:	c3                   	ret    
80104a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a3f:	90                   	nop
80104a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a48:	c9                   	leave  
80104a49:	c3                   	ret    
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a55:	e8 36 ef ff ff       	call   80103990 <myproc>
80104a5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5d:	8b 40 18             	mov    0x18(%eax),%eax
80104a60:	8b 40 44             	mov    0x44(%eax),%eax
80104a63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a66:	e8 25 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6e:	8b 00                	mov    (%eax),%eax
80104a70:	39 c6                	cmp    %eax,%esi
80104a72:	73 1c                	jae    80104a90 <argint+0x40>
80104a74:	8d 53 08             	lea    0x8(%ebx),%edx
80104a77:	39 d0                	cmp    %edx,%eax
80104a79:	72 15                	jb     80104a90 <argint+0x40>
  *ip = *(int*)(addr);
80104a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a95:	eb ee                	jmp    80104a85 <argint+0x35>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104aa9:	e8 e2 ee ff ff       	call   80103990 <myproc>
80104aae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab0:	e8 db ee ff ff       	call   80103990 <myproc>
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab8:	8b 40 18             	mov    0x18(%eax),%eax
80104abb:	8b 40 44             	mov    0x44(%eax),%eax
80104abe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ac1:	e8 ca ee ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ac9:	8b 00                	mov    (%eax),%eax
80104acb:	39 c7                	cmp    %eax,%edi
80104acd:	73 31                	jae    80104b00 <argptr+0x60>
80104acf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ad2:	39 c8                	cmp    %ecx,%eax
80104ad4:	72 2a                	jb     80104b00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ad6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ad9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104adc:	85 d2                	test   %edx,%edx
80104ade:	78 20                	js     80104b00 <argptr+0x60>
80104ae0:	8b 16                	mov    (%esi),%edx
80104ae2:	39 c2                	cmp    %eax,%edx
80104ae4:	76 1a                	jbe    80104b00 <argptr+0x60>
80104ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ae9:	01 c3                	add    %eax,%ebx
80104aeb:	39 da                	cmp    %ebx,%edx
80104aed:	72 11                	jb     80104b00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104aef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104af2:	89 02                	mov    %eax,(%edx)
  return 0;
80104af4:	31 c0                	xor    %eax,%eax
}
80104af6:	83 c4 0c             	add    $0xc,%esp
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5f                   	pop    %edi
80104afc:	5d                   	pop    %ebp
80104afd:	c3                   	ret    
80104afe:	66 90                	xchg   %ax,%ax
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb ef                	jmp    80104af6 <argptr+0x56>
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	e8 76 ee ff ff       	call   80103990 <myproc>
80104b1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b1d:	8b 40 18             	mov    0x18(%eax),%eax
80104b20:	8b 40 44             	mov    0x44(%eax),%eax
80104b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b26:	e8 65 ee ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2e:	8b 00                	mov    (%eax),%eax
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	73 44                	jae    80104b78 <argstr+0x68>
80104b34:	8d 53 08             	lea    0x8(%ebx),%edx
80104b37:	39 d0                	cmp    %edx,%eax
80104b39:	72 3d                	jb     80104b78 <argstr+0x68>
  *ip = *(int*)(addr);
80104b3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b3e:	e8 4d ee ff ff       	call   80103990 <myproc>
  if(addr >= curproc->sz)
80104b43:	3b 18                	cmp    (%eax),%ebx
80104b45:	73 31                	jae    80104b78 <argstr+0x68>
  *pp = (char*)addr;
80104b47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b4e:	39 d3                	cmp    %edx,%ebx
80104b50:	73 26                	jae    80104b78 <argstr+0x68>
80104b52:	89 d8                	mov    %ebx,%eax
80104b54:	eb 11                	jmp    80104b67 <argstr+0x57>
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	39 c2                	cmp    %eax,%edx
80104b65:	76 11                	jbe    80104b78 <argstr+0x68>
    if(*s == 0)
80104b67:	80 38 00             	cmpb   $0x0,(%eax)
80104b6a:	75 f4                	jne    80104b60 <argstr+0x50>
      return s - *pp;
80104b6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	5b                   	pop    %ebx
    return -1;
80104b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b7e:	5e                   	pop    %esi
80104b7f:	5d                   	pop    %ebp
80104b80:	c3                   	ret    
80104b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop

80104b90 <syscall>:
[SYS_chpr]    sys_chpr,
};

void
syscall(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b97:	e8 f4 ed ff ff       	call   80103990 <myproc>
80104b9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ba1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ba4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ba7:	83 fa 17             	cmp    $0x17,%edx
80104baa:	77 24                	ja     80104bd0 <syscall+0x40>
80104bac:	8b 14 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%edx
80104bb3:	85 d2                	test   %edx,%edx
80104bb5:	74 19                	je     80104bd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bb7:	ff d2                	call   *%edx
80104bb9:	89 c2                	mov    %eax,%edx
80104bbb:	8b 43 18             	mov    0x18(%ebx),%eax
80104bbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc4:	c9                   	leave  
80104bc5:	c3                   	ret    
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104bd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bd4:	50                   	push   %eax
80104bd5:	ff 73 10             	push   0x10(%ebx)
80104bd8:	68 4d 7a 10 80       	push   $0x80107a4d
80104bdd:	e8 be ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104be2:	8b 43 18             	mov    0x18(%ebx),%eax
80104be5:	83 c4 10             	add    $0x10,%esp
80104be8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf2:	c9                   	leave  
80104bf3:	c3                   	ret    
80104bf4:	66 90                	xchg   %ax,%ax
80104bf6:	66 90                	xchg   %ax,%ax
80104bf8:	66 90                	xchg   %ax,%ax
80104bfa:	66 90                	xchg   %ax,%ax
80104bfc:	66 90                	xchg   %ax,%ax
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c08:	53                   	push   %ebx
80104c09:	83 ec 34             	sub    $0x34,%esp
80104c0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c12:	57                   	push   %edi
80104c13:	50                   	push   %eax
{
80104c14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c1a:	e8 b1 d4 ff ff       	call   801020d0 <nameiparent>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	0f 84 46 01 00 00    	je     80104d70 <create+0x170>
    return 0;
  ilock(dp);
80104c2a:	83 ec 0c             	sub    $0xc,%esp
80104c2d:	89 c3                	mov    %eax,%ebx
80104c2f:	50                   	push   %eax
80104c30:	e8 5b cb ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c35:	83 c4 0c             	add    $0xc,%esp
80104c38:	6a 00                	push   $0x0
80104c3a:	57                   	push   %edi
80104c3b:	53                   	push   %ebx
80104c3c:	e8 af d0 ff ff       	call   80101cf0 <dirlookup>
80104c41:	83 c4 10             	add    $0x10,%esp
80104c44:	89 c6                	mov    %eax,%esi
80104c46:	85 c0                	test   %eax,%eax
80104c48:	74 56                	je     80104ca0 <create+0xa0>
    iunlockput(dp);
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	53                   	push   %ebx
80104c4e:	e8 cd cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104c53:	89 34 24             	mov    %esi,(%esp)
80104c56:	e8 35 cb ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c5b:	83 c4 10             	add    $0x10,%esp
80104c5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c63:	75 1b                	jne    80104c80 <create+0x80>
80104c65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c6a:	75 14                	jne    80104c80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6f:	89 f0                	mov    %esi,%eax
80104c71:	5b                   	pop    %ebx
80104c72:	5e                   	pop    %esi
80104c73:	5f                   	pop    %edi
80104c74:	5d                   	pop    %ebp
80104c75:	c3                   	ret    
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	56                   	push   %esi
    return 0;
80104c84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c86:	e8 95 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104c8b:	83 c4 10             	add    $0x10,%esp
}
80104c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c91:	89 f0                	mov    %esi,%eax
80104c93:	5b                   	pop    %ebx
80104c94:	5e                   	pop    %esi
80104c95:	5f                   	pop    %edi
80104c96:	5d                   	pop    %ebp
80104c97:	c3                   	ret    
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ca0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ca4:	83 ec 08             	sub    $0x8,%esp
80104ca7:	50                   	push   %eax
80104ca8:	ff 33                	push   (%ebx)
80104caa:	e8 71 c9 ff ff       	call   80101620 <ialloc>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	89 c6                	mov    %eax,%esi
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	0f 84 cd 00 00 00    	je     80104d89 <create+0x189>
  ilock(ip);
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 cb ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104cc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104cc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ccd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cde:	89 34 24             	mov    %esi,(%esp)
80104ce1:	e8 fa c9 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cee:	74 30                	je     80104d20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104cf0:	83 ec 04             	sub    $0x4,%esp
80104cf3:	ff 76 04             	push   0x4(%esi)
80104cf6:	57                   	push   %edi
80104cf7:	53                   	push   %ebx
80104cf8:	e8 f3 d2 ff ff       	call   80101ff0 <dirlink>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 78                	js     80104d7c <create+0x17c>
  iunlockput(dp);
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	53                   	push   %ebx
80104d08:	e8 13 cd ff ff       	call   80101a20 <iunlockput>
  return ip;
80104d0d:	83 c4 10             	add    $0x10,%esp
}
80104d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d13:	89 f0                	mov    %esi,%eax
80104d15:	5b                   	pop    %ebx
80104d16:	5e                   	pop    %esi
80104d17:	5f                   	pop    %edi
80104d18:	5d                   	pop    %ebp
80104d19:	c3                   	ret    
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d28:	53                   	push   %ebx
80104d29:	e8 b2 c9 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d2e:	83 c4 0c             	add    $0xc,%esp
80104d31:	ff 76 04             	push   0x4(%esi)
80104d34:	68 00 7b 10 80       	push   $0x80107b00
80104d39:	56                   	push   %esi
80104d3a:	e8 b1 d2 ff ff       	call   80101ff0 <dirlink>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	85 c0                	test   %eax,%eax
80104d44:	78 18                	js     80104d5e <create+0x15e>
80104d46:	83 ec 04             	sub    $0x4,%esp
80104d49:	ff 73 04             	push   0x4(%ebx)
80104d4c:	68 ff 7a 10 80       	push   $0x80107aff
80104d51:	56                   	push   %esi
80104d52:	e8 99 d2 ff ff       	call   80101ff0 <dirlink>
80104d57:	83 c4 10             	add    $0x10,%esp
80104d5a:	85 c0                	test   %eax,%eax
80104d5c:	79 92                	jns    80104cf0 <create+0xf0>
      panic("create dots");
80104d5e:	83 ec 0c             	sub    $0xc,%esp
80104d61:	68 f3 7a 10 80       	push   $0x80107af3
80104d66:	e8 15 b6 ff ff       	call   80100380 <panic>
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop
}
80104d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d73:	31 f6                	xor    %esi,%esi
}
80104d75:	5b                   	pop    %ebx
80104d76:	89 f0                	mov    %esi,%eax
80104d78:	5e                   	pop    %esi
80104d79:	5f                   	pop    %edi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
    panic("create: dirlink");
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	68 02 7b 10 80       	push   $0x80107b02
80104d84:	e8 f7 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 e4 7a 10 80       	push   $0x80107ae4
80104d91:	e8 ea b5 ff ff       	call   80100380 <panic>
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi

80104da0 <sys_dup>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104da8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dab:	50                   	push   %eax
80104dac:	6a 00                	push   $0x0
80104dae:	e8 9d fc ff ff       	call   80104a50 <argint>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	78 36                	js     80104df0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dbe:	77 30                	ja     80104df0 <sys_dup+0x50>
80104dc0:	e8 cb eb ff ff       	call   80103990 <myproc>
80104dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dcc:	85 f6                	test   %esi,%esi
80104dce:	74 20                	je     80104df0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104dd0:	e8 bb eb ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104dd5:	31 db                	xor    %ebx,%ebx
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104de0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104de4:	85 d2                	test   %edx,%edx
80104de6:	74 18                	je     80104e00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104de8:	83 c3 01             	add    $0x1,%ebx
80104deb:	83 fb 10             	cmp    $0x10,%ebx
80104dee:	75 f0                	jne    80104de0 <sys_dup+0x40>
}
80104df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104df3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104df8:	89 d8                	mov    %ebx,%eax
80104dfa:	5b                   	pop    %ebx
80104dfb:	5e                   	pop    %esi
80104dfc:	5d                   	pop    %ebp
80104dfd:	c3                   	ret    
80104dfe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e03:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e07:	56                   	push   %esi
80104e08:	e8 a3 c0 ff ff       	call   80100eb0 <filedup>
  return fd;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e13:	89 d8                	mov    %ebx,%eax
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5d                   	pop    %ebp
80104e18:	c3                   	ret    
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e20 <sys_read>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2b:	53                   	push   %ebx
80104e2c:	6a 00                	push   $0x0
80104e2e:	e8 1d fc ff ff       	call   80104a50 <argint>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 5e                	js     80104e98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e3e:	77 58                	ja     80104e98 <sys_read+0x78>
80104e40:	e8 4b eb ff ff       	call   80103990 <myproc>
80104e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e4c:	85 f6                	test   %esi,%esi
80104e4e:	74 48                	je     80104e98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e50:	83 ec 08             	sub    $0x8,%esp
80104e53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e56:	50                   	push   %eax
80104e57:	6a 02                	push   $0x2
80104e59:	e8 f2 fb ff ff       	call   80104a50 <argint>
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	85 c0                	test   %eax,%eax
80104e63:	78 33                	js     80104e98 <sys_read+0x78>
80104e65:	83 ec 04             	sub    $0x4,%esp
80104e68:	ff 75 f0             	push   -0x10(%ebp)
80104e6b:	53                   	push   %ebx
80104e6c:	6a 01                	push   $0x1
80104e6e:	e8 2d fc ff ff       	call   80104aa0 <argptr>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 1e                	js     80104e98 <sys_read+0x78>
  return fileread(f, p, n);
80104e7a:	83 ec 04             	sub    $0x4,%esp
80104e7d:	ff 75 f0             	push   -0x10(%ebp)
80104e80:	ff 75 f4             	push   -0xc(%ebp)
80104e83:	56                   	push   %esi
80104e84:	e8 a7 c1 ff ff       	call   80101030 <fileread>
80104e89:	83 c4 10             	add    $0x10,%esp
}
80104e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e8f:	5b                   	pop    %ebx
80104e90:	5e                   	pop    %esi
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    
80104e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e97:	90                   	nop
    return -1;
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9d:	eb ed                	jmp    80104e8c <sys_read+0x6c>
80104e9f:	90                   	nop

80104ea0 <sys_write>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	53                   	push   %ebx
80104eac:	6a 00                	push   $0x0
80104eae:	e8 9d fb ff ff       	call   80104a50 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 5e                	js     80104f18 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 58                	ja     80104f18 <sys_write+0x78>
80104ec0:	e8 cb ea ff ff       	call   80103990 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 48                	je     80104f18 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ed0:	83 ec 08             	sub    $0x8,%esp
80104ed3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ed6:	50                   	push   %eax
80104ed7:	6a 02                	push   $0x2
80104ed9:	e8 72 fb ff ff       	call   80104a50 <argint>
80104ede:	83 c4 10             	add    $0x10,%esp
80104ee1:	85 c0                	test   %eax,%eax
80104ee3:	78 33                	js     80104f18 <sys_write+0x78>
80104ee5:	83 ec 04             	sub    $0x4,%esp
80104ee8:	ff 75 f0             	push   -0x10(%ebp)
80104eeb:	53                   	push   %ebx
80104eec:	6a 01                	push   $0x1
80104eee:	e8 ad fb ff ff       	call   80104aa0 <argptr>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 1e                	js     80104f18 <sys_write+0x78>
  return filewrite(f, p, n);
80104efa:	83 ec 04             	sub    $0x4,%esp
80104efd:	ff 75 f0             	push   -0x10(%ebp)
80104f00:	ff 75 f4             	push   -0xc(%ebp)
80104f03:	56                   	push   %esi
80104f04:	e8 b7 c1 ff ff       	call   801010c0 <filewrite>
80104f09:	83 c4 10             	add    $0x10,%esp
}
80104f0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f0f:	5b                   	pop    %ebx
80104f10:	5e                   	pop    %esi
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    
80104f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f17:	90                   	nop
    return -1;
80104f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1d:	eb ed                	jmp    80104f0c <sys_write+0x6c>
80104f1f:	90                   	nop

80104f20 <sys_close>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 1d fb ff ff       	call   80104a50 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 3e                	js     80104f78 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 38                	ja     80104f78 <sys_close+0x58>
80104f40:	e8 4b ea ff ff       	call   80103990 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f4b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f4f:	85 f6                	test   %esi,%esi
80104f51:	74 25                	je     80104f78 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f53:	e8 38 ea ff ff       	call   80103990 <myproc>
  fileclose(f);
80104f58:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f5b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f62:	00 
  fileclose(f);
80104f63:	56                   	push   %esi
80104f64:	e8 97 bf ff ff       	call   80100f00 <fileclose>
  return 0;
80104f69:	83 c4 10             	add    $0x10,%esp
80104f6c:	31 c0                	xor    %eax,%eax
}
80104f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f71:	5b                   	pop    %ebx
80104f72:	5e                   	pop    %esi
80104f73:	5d                   	pop    %ebp
80104f74:	c3                   	ret    
80104f75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ef                	jmp    80104f6e <sys_close+0x4e>
80104f7f:	90                   	nop

80104f80 <sys_fstat>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	53                   	push   %ebx
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 bd fa ff ff       	call   80104a50 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 46                	js     80104fe0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 40                	ja     80104fe0 <sys_fstat+0x60>
80104fa0:	e8 eb e9 ff ff       	call   80103990 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fac:	85 f6                	test   %esi,%esi
80104fae:	74 30                	je     80104fe0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fb0:	83 ec 04             	sub    $0x4,%esp
80104fb3:	6a 14                	push   $0x14
80104fb5:	53                   	push   %ebx
80104fb6:	6a 01                	push   $0x1
80104fb8:	e8 e3 fa ff ff       	call   80104aa0 <argptr>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	78 1c                	js     80104fe0 <sys_fstat+0x60>
  return filestat(f, st);
80104fc4:	83 ec 08             	sub    $0x8,%esp
80104fc7:	ff 75 f4             	push   -0xc(%ebp)
80104fca:	56                   	push   %esi
80104fcb:	e8 10 c0 ff ff       	call   80100fe0 <filestat>
80104fd0:	83 c4 10             	add    $0x10,%esp
}
80104fd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd6:	5b                   	pop    %ebx
80104fd7:	5e                   	pop    %esi
80104fd8:	5d                   	pop    %ebp
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe5:	eb ec                	jmp    80104fd3 <sys_fstat+0x53>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <sys_link>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ff5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ff8:	53                   	push   %ebx
80104ff9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ffc:	50                   	push   %eax
80104ffd:	6a 00                	push   $0x0
80104fff:	e8 0c fb ff ff       	call   80104b10 <argstr>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	0f 88 fb 00 00 00    	js     8010510a <sys_link+0x11a>
8010500f:	83 ec 08             	sub    $0x8,%esp
80105012:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105015:	50                   	push   %eax
80105016:	6a 01                	push   $0x1
80105018:	e8 f3 fa ff ff       	call   80104b10 <argstr>
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	85 c0                	test   %eax,%eax
80105022:	0f 88 e2 00 00 00    	js     8010510a <sys_link+0x11a>
  begin_op();
80105028:	e8 43 dd ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	ff 75 d4             	push   -0x2c(%ebp)
80105033:	e8 78 d0 ff ff       	call   801020b0 <namei>
80105038:	83 c4 10             	add    $0x10,%esp
8010503b:	89 c3                	mov    %eax,%ebx
8010503d:	85 c0                	test   %eax,%eax
8010503f:	0f 84 e4 00 00 00    	je     80105129 <sys_link+0x139>
  ilock(ip);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	50                   	push   %eax
80105049:	e8 42 c7 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105056:	0f 84 b5 00 00 00    	je     80105111 <sys_link+0x121>
  iupdate(ip);
8010505c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010505f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105064:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105067:	53                   	push   %ebx
80105068:	e8 73 c6 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
8010506d:	89 1c 24             	mov    %ebx,(%esp)
80105070:	e8 fb c7 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105075:	58                   	pop    %eax
80105076:	5a                   	pop    %edx
80105077:	57                   	push   %edi
80105078:	ff 75 d0             	push   -0x30(%ebp)
8010507b:	e8 50 d0 ff ff       	call   801020d0 <nameiparent>
80105080:	83 c4 10             	add    $0x10,%esp
80105083:	89 c6                	mov    %eax,%esi
80105085:	85 c0                	test   %eax,%eax
80105087:	74 5b                	je     801050e4 <sys_link+0xf4>
  ilock(dp);
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	50                   	push   %eax
8010508d:	e8 fe c6 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105092:	8b 03                	mov    (%ebx),%eax
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	39 06                	cmp    %eax,(%esi)
80105099:	75 3d                	jne    801050d8 <sys_link+0xe8>
8010509b:	83 ec 04             	sub    $0x4,%esp
8010509e:	ff 73 04             	push   0x4(%ebx)
801050a1:	57                   	push   %edi
801050a2:	56                   	push   %esi
801050a3:	e8 48 cf ff ff       	call   80101ff0 <dirlink>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	85 c0                	test   %eax,%eax
801050ad:	78 29                	js     801050d8 <sys_link+0xe8>
  iunlockput(dp);
801050af:	83 ec 0c             	sub    $0xc,%esp
801050b2:	56                   	push   %esi
801050b3:	e8 68 c9 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801050b8:	89 1c 24             	mov    %ebx,(%esp)
801050bb:	e8 00 c8 ff ff       	call   801018c0 <iput>
  end_op();
801050c0:	e8 1b dd ff ff       	call   80102de0 <end_op>
  return 0;
801050c5:	83 c4 10             	add    $0x10,%esp
801050c8:	31 c0                	xor    %eax,%eax
}
801050ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cd:	5b                   	pop    %ebx
801050ce:	5e                   	pop    %esi
801050cf:	5f                   	pop    %edi
801050d0:	5d                   	pop    %ebp
801050d1:	c3                   	ret    
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	56                   	push   %esi
801050dc:	e8 3f c9 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801050e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	53                   	push   %ebx
801050e8:	e8 a3 c6 ff ff       	call   80101790 <ilock>
  ip->nlink--;
801050ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050f2:	89 1c 24             	mov    %ebx,(%esp)
801050f5:	e8 e6 c5 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
801050fa:	89 1c 24             	mov    %ebx,(%esp)
801050fd:	e8 1e c9 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105102:	e8 d9 dc ff ff       	call   80102de0 <end_op>
  return -1;
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510f:	eb b9                	jmp    801050ca <sys_link+0xda>
    iunlockput(ip);
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	53                   	push   %ebx
80105115:	e8 06 c9 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010511a:	e8 c1 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105127:	eb a1                	jmp    801050ca <sys_link+0xda>
    end_op();
80105129:	e8 b2 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010512e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105133:	eb 95                	jmp    801050ca <sys_link+0xda>
80105135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_unlink>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105145:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105148:	53                   	push   %ebx
80105149:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 bc f9 ff ff       	call   80104b10 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 7a 01 00 00    	js     801052d9 <sys_unlink+0x199>
  begin_op();
8010515f:	e8 0c dc ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105164:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105167:	83 ec 08             	sub    $0x8,%esp
8010516a:	53                   	push   %ebx
8010516b:	ff 75 c0             	push   -0x40(%ebp)
8010516e:	e8 5d cf ff ff       	call   801020d0 <nameiparent>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105179:	85 c0                	test   %eax,%eax
8010517b:	0f 84 62 01 00 00    	je     801052e3 <sys_unlink+0x1a3>
  ilock(dp);
80105181:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	57                   	push   %edi
80105188:	e8 03 c6 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010518d:	58                   	pop    %eax
8010518e:	5a                   	pop    %edx
8010518f:	68 00 7b 10 80       	push   $0x80107b00
80105194:	53                   	push   %ebx
80105195:	e8 36 cb ff ff       	call   80101cd0 <namecmp>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	0f 84 fb 00 00 00    	je     801052a0 <sys_unlink+0x160>
801051a5:	83 ec 08             	sub    $0x8,%esp
801051a8:	68 ff 7a 10 80       	push   $0x80107aff
801051ad:	53                   	push   %ebx
801051ae:	e8 1d cb ff ff       	call   80101cd0 <namecmp>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	0f 84 e2 00 00 00    	je     801052a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051be:	83 ec 04             	sub    $0x4,%esp
801051c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051c4:	50                   	push   %eax
801051c5:	53                   	push   %ebx
801051c6:	57                   	push   %edi
801051c7:	e8 24 cb ff ff       	call   80101cf0 <dirlookup>
801051cc:	83 c4 10             	add    $0x10,%esp
801051cf:	89 c3                	mov    %eax,%ebx
801051d1:	85 c0                	test   %eax,%eax
801051d3:	0f 84 c7 00 00 00    	je     801052a0 <sys_unlink+0x160>
  ilock(ip);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	50                   	push   %eax
801051dd:	e8 ae c5 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051ea:	0f 8e 1c 01 00 00    	jle    8010530c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051f8:	74 66                	je     80105260 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051fa:	83 ec 04             	sub    $0x4,%esp
801051fd:	6a 10                	push   $0x10
801051ff:	6a 00                	push   $0x0
80105201:	57                   	push   %edi
80105202:	e8 89 f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105207:	6a 10                	push   $0x10
80105209:	ff 75 c4             	push   -0x3c(%ebp)
8010520c:	57                   	push   %edi
8010520d:	ff 75 b4             	push   -0x4c(%ebp)
80105210:	e8 8b c9 ff ff       	call   80101ba0 <writei>
80105215:	83 c4 20             	add    $0x20,%esp
80105218:	83 f8 10             	cmp    $0x10,%eax
8010521b:	0f 85 de 00 00 00    	jne    801052ff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105221:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105226:	0f 84 94 00 00 00    	je     801052c0 <sys_unlink+0x180>
  iunlockput(dp);
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	ff 75 b4             	push   -0x4c(%ebp)
80105232:	e8 e9 c7 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105237:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010523c:	89 1c 24             	mov    %ebx,(%esp)
8010523f:	e8 9c c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105244:	89 1c 24             	mov    %ebx,(%esp)
80105247:	e8 d4 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010524c:	e8 8f db ff ff       	call   80102de0 <end_op>
  return 0;
80105251:	83 c4 10             	add    $0x10,%esp
80105254:	31 c0                	xor    %eax,%eax
}
80105256:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105259:	5b                   	pop    %ebx
8010525a:	5e                   	pop    %esi
8010525b:	5f                   	pop    %edi
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105260:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105264:	76 94                	jbe    801051fa <sys_unlink+0xba>
80105266:	be 20 00 00 00       	mov    $0x20,%esi
8010526b:	eb 0b                	jmp    80105278 <sys_unlink+0x138>
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c6 10             	add    $0x10,%esi
80105273:	3b 73 58             	cmp    0x58(%ebx),%esi
80105276:	73 82                	jae    801051fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105278:	6a 10                	push   $0x10
8010527a:	56                   	push   %esi
8010527b:	57                   	push   %edi
8010527c:	53                   	push   %ebx
8010527d:	e8 1e c8 ff ff       	call   80101aa0 <readi>
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	83 f8 10             	cmp    $0x10,%eax
80105288:	75 68                	jne    801052f2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010528a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010528f:	74 df                	je     80105270 <sys_unlink+0x130>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 86 c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	ff 75 b4             	push   -0x4c(%ebp)
801052a6:	e8 75 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
801052ab:	e8 30 db ff ff       	call   80102de0 <end_op>
  return -1;
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b8:	eb 9c                	jmp    80105256 <sys_unlink+0x116>
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801052c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801052c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052cb:	50                   	push   %eax
801052cc:	e8 0f c4 ff ff       	call   801016e0 <iupdate>
801052d1:	83 c4 10             	add    $0x10,%esp
801052d4:	e9 53 ff ff ff       	jmp    8010522c <sys_unlink+0xec>
    return -1;
801052d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052de:	e9 73 ff ff ff       	jmp    80105256 <sys_unlink+0x116>
    end_op();
801052e3:	e8 f8 da ff ff       	call   80102de0 <end_op>
    return -1;
801052e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ed:	e9 64 ff ff ff       	jmp    80105256 <sys_unlink+0x116>
      panic("isdirempty: readi");
801052f2:	83 ec 0c             	sub    $0xc,%esp
801052f5:	68 24 7b 10 80       	push   $0x80107b24
801052fa:	e8 81 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801052ff:	83 ec 0c             	sub    $0xc,%esp
80105302:	68 36 7b 10 80       	push   $0x80107b36
80105307:	e8 74 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	68 12 7b 10 80       	push   $0x80107b12
80105314:	e8 67 b0 ff ff       	call   80100380 <panic>
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_open>:

int
sys_open(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105325:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105328:	53                   	push   %ebx
80105329:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010532c:	50                   	push   %eax
8010532d:	6a 00                	push   $0x0
8010532f:	e8 dc f7 ff ff       	call   80104b10 <argstr>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	0f 88 8e 00 00 00    	js     801053cd <sys_open+0xad>
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105345:	50                   	push   %eax
80105346:	6a 01                	push   $0x1
80105348:	e8 03 f7 ff ff       	call   80104a50 <argint>
8010534d:	83 c4 10             	add    $0x10,%esp
80105350:	85 c0                	test   %eax,%eax
80105352:	78 79                	js     801053cd <sys_open+0xad>
    return -1;

  begin_op();
80105354:	e8 17 da ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105359:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010535d:	75 79                	jne    801053d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	ff 75 e0             	push   -0x20(%ebp)
80105365:	e8 46 cd ff ff       	call   801020b0 <namei>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	89 c6                	mov    %eax,%esi
8010536f:	85 c0                	test   %eax,%eax
80105371:	0f 84 7e 00 00 00    	je     801053f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105377:	83 ec 0c             	sub    $0xc,%esp
8010537a:	50                   	push   %eax
8010537b:	e8 10 c4 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105380:	83 c4 10             	add    $0x10,%esp
80105383:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105388:	0f 84 c2 00 00 00    	je     80105450 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010538e:	e8 ad ba ff ff       	call   80100e40 <filealloc>
80105393:	89 c7                	mov    %eax,%edi
80105395:	85 c0                	test   %eax,%eax
80105397:	74 23                	je     801053bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105399:	e8 f2 e5 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010539e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053a4:	85 d2                	test   %edx,%edx
801053a6:	74 60                	je     80105408 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801053a8:	83 c3 01             	add    $0x1,%ebx
801053ab:	83 fb 10             	cmp    $0x10,%ebx
801053ae:	75 f0                	jne    801053a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	57                   	push   %edi
801053b4:	e8 47 bb ff ff       	call   80100f00 <fileclose>
801053b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	56                   	push   %esi
801053c0:	e8 5b c6 ff ff       	call   80101a20 <iunlockput>
    end_op();
801053c5:	e8 16 da ff ff       	call   80102de0 <end_op>
    return -1;
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053d2:	eb 6d                	jmp    80105441 <sys_open+0x121>
801053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053d8:	83 ec 0c             	sub    $0xc,%esp
801053db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053de:	31 c9                	xor    %ecx,%ecx
801053e0:	ba 02 00 00 00       	mov    $0x2,%edx
801053e5:	6a 00                	push   $0x0
801053e7:	e8 14 f8 ff ff       	call   80104c00 <create>
    if(ip == 0){
801053ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053f1:	85 c0                	test   %eax,%eax
801053f3:	75 99                	jne    8010538e <sys_open+0x6e>
      end_op();
801053f5:	e8 e6 d9 ff ff       	call   80102de0 <end_op>
      return -1;
801053fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053ff:	eb 40                	jmp    80105441 <sys_open+0x121>
80105401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105408:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010540b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010540f:	56                   	push   %esi
80105410:	e8 5b c4 ff ff       	call   80101870 <iunlock>
  end_op();
80105415:	e8 c6 d9 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010541a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105420:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105423:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105426:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105429:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010542b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105432:	f7 d0                	not    %eax
80105434:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105437:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010543a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010543d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105444:	89 d8                	mov    %ebx,%eax
80105446:	5b                   	pop    %ebx
80105447:	5e                   	pop    %esi
80105448:	5f                   	pop    %edi
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    
8010544b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010544f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105450:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105453:	85 c9                	test   %ecx,%ecx
80105455:	0f 84 33 ff ff ff    	je     8010538e <sys_open+0x6e>
8010545b:	e9 5c ff ff ff       	jmp    801053bc <sys_open+0x9c>

80105460 <sys_mkdir>:

int
sys_mkdir(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105466:	e8 05 d9 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010546b:	83 ec 08             	sub    $0x8,%esp
8010546e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105471:	50                   	push   %eax
80105472:	6a 00                	push   $0x0
80105474:	e8 97 f6 ff ff       	call   80104b10 <argstr>
80105479:	83 c4 10             	add    $0x10,%esp
8010547c:	85 c0                	test   %eax,%eax
8010547e:	78 30                	js     801054b0 <sys_mkdir+0x50>
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105486:	31 c9                	xor    %ecx,%ecx
80105488:	ba 01 00 00 00       	mov    $0x1,%edx
8010548d:	6a 00                	push   $0x0
8010548f:	e8 6c f7 ff ff       	call   80104c00 <create>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	74 15                	je     801054b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010549b:	83 ec 0c             	sub    $0xc,%esp
8010549e:	50                   	push   %eax
8010549f:	e8 7c c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
801054a4:	e8 37 d9 ff ff       	call   80102de0 <end_op>
  return 0;
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	31 c0                	xor    %eax,%eax
}
801054ae:	c9                   	leave  
801054af:	c3                   	ret    
    end_op();
801054b0:	e8 2b d9 ff ff       	call   80102de0 <end_op>
    return -1;
801054b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ba:	c9                   	leave  
801054bb:	c3                   	ret    
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <sys_mknod>:

int
sys_mknod(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054c6:	e8 a5 d8 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054cb:	83 ec 08             	sub    $0x8,%esp
801054ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054d1:	50                   	push   %eax
801054d2:	6a 00                	push   $0x0
801054d4:	e8 37 f6 ff ff       	call   80104b10 <argstr>
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	85 c0                	test   %eax,%eax
801054de:	78 60                	js     80105540 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054e0:	83 ec 08             	sub    $0x8,%esp
801054e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e6:	50                   	push   %eax
801054e7:	6a 01                	push   $0x1
801054e9:	e8 62 f5 ff ff       	call   80104a50 <argint>
  if((argstr(0, &path)) < 0 ||
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	85 c0                	test   %eax,%eax
801054f3:	78 4b                	js     80105540 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054f5:	83 ec 08             	sub    $0x8,%esp
801054f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054fb:	50                   	push   %eax
801054fc:	6a 02                	push   $0x2
801054fe:	e8 4d f5 ff ff       	call   80104a50 <argint>
     argint(1, &major) < 0 ||
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	78 36                	js     80105540 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010550a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010550e:	83 ec 0c             	sub    $0xc,%esp
80105511:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105515:	ba 03 00 00 00       	mov    $0x3,%edx
8010551a:	50                   	push   %eax
8010551b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010551e:	e8 dd f6 ff ff       	call   80104c00 <create>
     argint(2, &minor) < 0 ||
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	74 16                	je     80105540 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	50                   	push   %eax
8010552e:	e8 ed c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105533:	e8 a8 d8 ff ff       	call   80102de0 <end_op>
  return 0;
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	31 c0                	xor    %eax,%eax
}
8010553d:	c9                   	leave  
8010553e:	c3                   	ret    
8010553f:	90                   	nop
    end_op();
80105540:	e8 9b d8 ff ff       	call   80102de0 <end_op>
    return -1;
80105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010554a:	c9                   	leave  
8010554b:	c3                   	ret    
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_chdir>:

int
sys_chdir(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
80105555:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105558:	e8 33 e4 ff ff       	call   80103990 <myproc>
8010555d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010555f:	e8 0c d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105564:	83 ec 08             	sub    $0x8,%esp
80105567:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556a:	50                   	push   %eax
8010556b:	6a 00                	push   $0x0
8010556d:	e8 9e f5 ff ff       	call   80104b10 <argstr>
80105572:	83 c4 10             	add    $0x10,%esp
80105575:	85 c0                	test   %eax,%eax
80105577:	78 77                	js     801055f0 <sys_chdir+0xa0>
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	ff 75 f4             	push   -0xc(%ebp)
8010557f:	e8 2c cb ff ff       	call   801020b0 <namei>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	89 c3                	mov    %eax,%ebx
80105589:	85 c0                	test   %eax,%eax
8010558b:	74 63                	je     801055f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	50                   	push   %eax
80105591:	e8 fa c1 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010559e:	75 30                	jne    801055d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	53                   	push   %ebx
801055a4:	e8 c7 c2 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801055a9:	58                   	pop    %eax
801055aa:	ff 76 68             	push   0x68(%esi)
801055ad:	e8 0e c3 ff ff       	call   801018c0 <iput>
  end_op();
801055b2:	e8 29 d8 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801055b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	31 c0                	xor    %eax,%eax
}
801055bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055c2:	5b                   	pop    %ebx
801055c3:	5e                   	pop    %esi
801055c4:	5d                   	pop    %ebp
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	53                   	push   %ebx
801055d4:	e8 47 c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
801055d9:	e8 02 d8 ff ff       	call   80102de0 <end_op>
    return -1;
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e6:	eb d7                	jmp    801055bf <sys_chdir+0x6f>
801055e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
    end_op();
801055f0:	e8 eb d7 ff ff       	call   80102de0 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fa:	eb c3                	jmp    801055bf <sys_chdir+0x6f>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_exec>:

int
sys_exec(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105605:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010560b:	53                   	push   %ebx
8010560c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105612:	50                   	push   %eax
80105613:	6a 00                	push   $0x0
80105615:	e8 f6 f4 ff ff       	call   80104b10 <argstr>
8010561a:	83 c4 10             	add    $0x10,%esp
8010561d:	85 c0                	test   %eax,%eax
8010561f:	0f 88 87 00 00 00    	js     801056ac <sys_exec+0xac>
80105625:	83 ec 08             	sub    $0x8,%esp
80105628:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010562e:	50                   	push   %eax
8010562f:	6a 01                	push   $0x1
80105631:	e8 1a f4 ff ff       	call   80104a50 <argint>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 6f                	js     801056ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010563d:	83 ec 04             	sub    $0x4,%esp
80105640:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105646:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105648:	68 80 00 00 00       	push   $0x80
8010564d:	6a 00                	push   $0x0
8010564f:	56                   	push   %esi
80105650:	e8 3b f1 ff ff       	call   80104790 <memset>
80105655:	83 c4 10             	add    $0x10,%esp
80105658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105669:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105670:	50                   	push   %eax
80105671:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105677:	01 f8                	add    %edi,%eax
80105679:	50                   	push   %eax
8010567a:	e8 41 f3 ff ff       	call   801049c0 <fetchint>
8010567f:	83 c4 10             	add    $0x10,%esp
80105682:	85 c0                	test   %eax,%eax
80105684:	78 26                	js     801056ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105686:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010568c:	85 c0                	test   %eax,%eax
8010568e:	74 30                	je     801056c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105690:	83 ec 08             	sub    $0x8,%esp
80105693:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105696:	52                   	push   %edx
80105697:	50                   	push   %eax
80105698:	e8 63 f3 ff ff       	call   80104a00 <fetchstr>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 08                	js     801056ac <sys_exec+0xac>
  for(i=0;; i++){
801056a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056a7:	83 fb 20             	cmp    $0x20,%ebx
801056aa:	75 b4                	jne    80105660 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801056c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056c7:	00 00 00 00 
  return exec(path, argv);
801056cb:	83 ec 08             	sub    $0x8,%esp
801056ce:	56                   	push   %esi
801056cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801056d5:	e8 d6 b3 ff ff       	call   80100ab0 <exec>
801056da:	83 c4 10             	add    $0x10,%esp
}
801056dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e0:	5b                   	pop    %ebx
801056e1:	5e                   	pop    %esi
801056e2:	5f                   	pop    %edi
801056e3:	5d                   	pop    %ebp
801056e4:	c3                   	ret    
801056e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_pipe>:

int
sys_pipe(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056f8:	53                   	push   %ebx
801056f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056fc:	6a 08                	push   $0x8
801056fe:	50                   	push   %eax
801056ff:	6a 00                	push   $0x0
80105701:	e8 9a f3 ff ff       	call   80104aa0 <argptr>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	78 4a                	js     80105757 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010570d:	83 ec 08             	sub    $0x8,%esp
80105710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105713:	50                   	push   %eax
80105714:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105717:	50                   	push   %eax
80105718:	e8 23 dd ff ff       	call   80103440 <pipealloc>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 33                	js     80105757 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105724:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105727:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105729:	e8 62 e2 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010572e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105730:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105734:	85 f6                	test   %esi,%esi
80105736:	74 28                	je     80105760 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105738:	83 c3 01             	add    $0x1,%ebx
8010573b:	83 fb 10             	cmp    $0x10,%ebx
8010573e:	75 f0                	jne    80105730 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	ff 75 e0             	push   -0x20(%ebp)
80105746:	e8 b5 b7 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010574b:	58                   	pop    %eax
8010574c:	ff 75 e4             	push   -0x1c(%ebp)
8010574f:	e8 ac b7 ff ff       	call   80100f00 <fileclose>
    return -1;
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575c:	eb 53                	jmp    801057b1 <sys_pipe+0xc1>
8010575e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105760:	8d 73 08             	lea    0x8(%ebx),%esi
80105763:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010576a:	e8 21 e2 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010576f:	31 d2                	xor    %edx,%edx
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105778:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010577c:	85 c9                	test   %ecx,%ecx
8010577e:	74 20                	je     801057a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105780:	83 c2 01             	add    $0x1,%edx
80105783:	83 fa 10             	cmp    $0x10,%edx
80105786:	75 f0                	jne    80105778 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105788:	e8 03 e2 ff ff       	call   80103990 <myproc>
8010578d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105794:	00 
80105795:	eb a9                	jmp    80105740 <sys_pipe+0x50>
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057af:	31 c0                	xor    %eax,%eax
}
801057b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	66 90                	xchg   %ax,%ax
801057bb:	66 90                	xchg   %ax,%ax
801057bd:	66 90                	xchg   %ax,%ax
801057bf:	90                   	nop

801057c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801057c0:	e9 6b e3 ff ff       	jmp    80103b30 <fork>
801057c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_exit>:
}

int
sys_exit(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057d6:	e8 d5 e5 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
801057db:	31 c0                	xor    %eax,%eax
801057dd:	c9                   	leave  
801057de:	c3                   	ret    
801057df:	90                   	nop

801057e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801057e0:	e9 fb e6 ff ff       	jmp    80103ee0 <wait>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_kill>:
}

int
sys_kill(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f9:	50                   	push   %eax
801057fa:	6a 00                	push   $0x0
801057fc:	e8 4f f2 ff ff       	call   80104a50 <argint>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	85 c0                	test   %eax,%eax
80105806:	78 18                	js     80105820 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	ff 75 f4             	push   -0xc(%ebp)
8010580e:	e8 6d e9 ff ff       	call   80104180 <kill>
80105813:	83 c4 10             	add    $0x10,%esp
}
80105816:	c9                   	leave  
80105817:	c3                   	ret    
80105818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
80105820:	c9                   	leave  
    return -1;
80105821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105826:	c3                   	ret    
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_getpid>:

int
sys_getpid(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105836:	e8 55 e1 ff ff       	call   80103990 <myproc>
8010583b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010583e:	c9                   	leave  
8010583f:	c3                   	ret    

80105840 <sys_sbrk>:

int
sys_sbrk(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105847:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010584a:	50                   	push   %eax
8010584b:	6a 00                	push   $0x0
8010584d:	e8 fe f1 ff ff       	call   80104a50 <argint>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	78 27                	js     80105880 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105859:	e8 32 e1 ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
8010585e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105861:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105863:	ff 75 f4             	push   -0xc(%ebp)
80105866:	e8 45 e2 ff ff       	call   80103ab0 <growproc>
8010586b:	83 c4 10             	add    $0x10,%esp
8010586e:	85 c0                	test   %eax,%eax
80105870:	78 0e                	js     80105880 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105872:	89 d8                	mov    %ebx,%eax
80105874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105877:	c9                   	leave  
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105880:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105885:	eb eb                	jmp    80105872 <sys_sbrk+0x32>
80105887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_sleep>:

int
sys_sleep(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105894:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105897:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 ae f1 ff ff       	call   80104a50 <argint>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	0f 88 8a 00 00 00    	js     80105937 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	68 80 3d 11 80       	push   $0x80113d80
801058b5:	e8 16 ee ff ff       	call   801046d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058bd:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  while(ticks - ticks0 < n){
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 d2                	test   %edx,%edx
801058c8:	75 27                	jne    801058f1 <sys_sleep+0x61>
801058ca:	eb 54                	jmp    80105920 <sys_sleep+0x90>
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	68 80 3d 11 80       	push   $0x80113d80
801058d8:	68 60 3d 11 80       	push   $0x80113d60
801058dd:	e8 7e e7 ff ff       	call   80104060 <sleep>
  while(ticks - ticks0 < n){
801058e2:	a1 60 3d 11 80       	mov    0x80113d60,%eax
801058e7:	83 c4 10             	add    $0x10,%esp
801058ea:	29 d8                	sub    %ebx,%eax
801058ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058ef:	73 2f                	jae    80105920 <sys_sleep+0x90>
    if(myproc()->killed){
801058f1:	e8 9a e0 ff ff       	call   80103990 <myproc>
801058f6:	8b 40 24             	mov    0x24(%eax),%eax
801058f9:	85 c0                	test   %eax,%eax
801058fb:	74 d3                	je     801058d0 <sys_sleep+0x40>
      release(&tickslock);
801058fd:	83 ec 0c             	sub    $0xc,%esp
80105900:	68 80 3d 11 80       	push   $0x80113d80
80105905:	e8 66 ed ff ff       	call   80104670 <release>
  }
  release(&tickslock);
  return 0;
}
8010590a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	68 80 3d 11 80       	push   $0x80113d80
80105928:	e8 43 ed ff ff       	call   80104670 <release>
  return 0;
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	31 c0                	xor    %eax,%eax
}
80105932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105935:	c9                   	leave  
80105936:	c3                   	ret    
    return -1;
80105937:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593c:	eb f4                	jmp    80105932 <sys_sleep+0xa2>
8010593e:	66 90                	xchg   %ax,%ax

80105940 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
80105944:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105947:	68 80 3d 11 80       	push   $0x80113d80
8010594c:	e8 7f ed ff ff       	call   801046d0 <acquire>
  xticks = ticks;
80105951:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  release(&tickslock);
80105957:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
8010595e:	e8 0d ed ff ff       	call   80104670 <release>
  return xticks;
}
80105963:	89 d8                	mov    %ebx,%eax
80105965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105968:	c9                   	leave  
80105969:	c3                   	ret    
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105970 <sys_getyear>:
sys_getyear(void)
{

  return 1975;

}
80105970:	b8 b7 07 00 00       	mov    $0x7b7,%eax
80105975:	c3                   	ret    
80105976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597d:	8d 76 00             	lea    0x0(%esi),%esi

80105980 <sys_cps>:
//Add this in the end of the sysproc.c file

int
sys_cps(void)
{
  return cps();
80105980:	e9 3b e9 ff ff       	jmp    801042c0 <cps>
80105985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_chpr>:
}

int
sys_chpr(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80105996:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	6a 00                	push   $0x0
8010599c:	e8 af f0 ff ff       	call   80104a50 <argint>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 28                	js     801059d0 <sys_chpr+0x40>
    return -1;
  if(argint(1, &pr) < 0)
801059a8:	83 ec 08             	sub    $0x8,%esp
801059ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ae:	50                   	push   %eax
801059af:	6a 01                	push   $0x1
801059b1:	e8 9a f0 ff ff       	call   80104a50 <argint>
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	85 c0                	test   %eax,%eax
801059bb:	78 13                	js     801059d0 <sys_chpr+0x40>
    return -1;

  return chpr(pid, pr);
801059bd:	83 ec 08             	sub    $0x8,%esp
801059c0:	ff 75 f4             	push   -0xc(%ebp)
801059c3:	ff 75 f0             	push   -0x10(%ebp)
801059c6:	e8 b5 e9 ff ff       	call   80104380 <chpr>
801059cb:	83 c4 10             	add    $0x10,%esp
}
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    
801059d0:	c9                   	leave  
    return -1;
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d6:	c3                   	ret    

801059d7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059d7:	1e                   	push   %ds
  pushl %es
801059d8:	06                   	push   %es
  pushl %fs
801059d9:	0f a0                	push   %fs
  pushl %gs
801059db:	0f a8                	push   %gs
  pushal
801059dd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801059de:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801059e2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801059e4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801059e6:	54                   	push   %esp
  call trap
801059e7:	e8 c4 00 00 00       	call   80105ab0 <trap>
  addl $4, %esp
801059ec:	83 c4 04             	add    $0x4,%esp

801059ef <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059ef:	61                   	popa   
  popl %gs
801059f0:	0f a9                	pop    %gs
  popl %fs
801059f2:	0f a1                	pop    %fs
  popl %es
801059f4:	07                   	pop    %es
  popl %ds
801059f5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059f6:	83 c4 08             	add    $0x8,%esp
  iret
801059f9:	cf                   	iret   
801059fa:	66 90                	xchg   %ax,%ax
801059fc:	66 90                	xchg   %ax,%ax
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a01:	31 c0                	xor    %eax,%eax
{
80105a03:	89 e5                	mov    %esp,%ebp
80105a05:	83 ec 08             	sub    $0x8,%esp
80105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a10:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a17:	c7 04 c5 c2 3d 11 80 	movl   $0x8e000008,-0x7feec23e(,%eax,8)
80105a1e:	08 00 00 8e 
80105a22:	66 89 14 c5 c0 3d 11 	mov    %dx,-0x7feec240(,%eax,8)
80105a29:	80 
80105a2a:	c1 ea 10             	shr    $0x10,%edx
80105a2d:	66 89 14 c5 c6 3d 11 	mov    %dx,-0x7feec23a(,%eax,8)
80105a34:	80 
  for(i = 0; i < 256; i++)
80105a35:	83 c0 01             	add    $0x1,%eax
80105a38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a3d:	75 d1                	jne    80105a10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a42:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a47:	c7 05 c2 3f 11 80 08 	movl   $0xef000008,0x80113fc2
80105a4e:	00 00 ef 
  initlock(&tickslock, "time");
80105a51:	68 45 7b 10 80       	push   $0x80107b45
80105a56:	68 80 3d 11 80       	push   $0x80113d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a5b:	66 a3 c0 3f 11 80    	mov    %ax,0x80113fc0
80105a61:	c1 e8 10             	shr    $0x10,%eax
80105a64:	66 a3 c6 3f 11 80    	mov    %ax,0x80113fc6
  initlock(&tickslock, "time");
80105a6a:	e8 91 ea ff ff       	call   80104500 <initlock>
}
80105a6f:	83 c4 10             	add    $0x10,%esp
80105a72:	c9                   	leave  
80105a73:	c3                   	ret    
80105a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop

80105a80 <idtinit>:

void
idtinit(void)
{
80105a80:	55                   	push   %ebp
  pd[0] = size-1;
80105a81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a86:	89 e5                	mov    %esp,%ebp
80105a88:	83 ec 10             	sub    $0x10,%esp
80105a8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a8f:	b8 c0 3d 11 80       	mov    $0x80113dc0,%eax
80105a94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a98:	c1 e8 10             	shr    $0x10,%eax
80105a9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105aa2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	83 ec 1c             	sub    $0x1c,%esp
80105ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105abc:	8b 43 30             	mov    0x30(%ebx),%eax
80105abf:	83 f8 40             	cmp    $0x40,%eax
80105ac2:	0f 84 68 01 00 00    	je     80105c30 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ac8:	83 e8 20             	sub    $0x20,%eax
80105acb:	83 f8 1f             	cmp    $0x1f,%eax
80105ace:	0f 87 8c 00 00 00    	ja     80105b60 <trap+0xb0>
80105ad4:	ff 24 85 ec 7b 10 80 	jmp    *-0x7fef8414(,%eax,4)
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ae0:	e8 6b c7 ff ff       	call   80102250 <ideintr>
    lapiceoi();
80105ae5:	e8 36 ce ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aea:	e8 a1 de ff ff       	call   80103990 <myproc>
80105aef:	85 c0                	test   %eax,%eax
80105af1:	74 1d                	je     80105b10 <trap+0x60>
80105af3:	e8 98 de ff ff       	call   80103990 <myproc>
80105af8:	8b 50 24             	mov    0x24(%eax),%edx
80105afb:	85 d2                	test   %edx,%edx
80105afd:	74 11                	je     80105b10 <trap+0x60>
80105aff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b03:	83 e0 03             	and    $0x3,%eax
80105b06:	66 83 f8 03          	cmp    $0x3,%ax
80105b0a:	0f 84 e8 01 00 00    	je     80105cf8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b10:	e8 7b de ff ff       	call   80103990 <myproc>
80105b15:	85 c0                	test   %eax,%eax
80105b17:	74 0f                	je     80105b28 <trap+0x78>
80105b19:	e8 72 de ff ff       	call   80103990 <myproc>
80105b1e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b22:	0f 84 b8 00 00 00    	je     80105be0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b28:	e8 63 de ff ff       	call   80103990 <myproc>
80105b2d:	85 c0                	test   %eax,%eax
80105b2f:	74 1d                	je     80105b4e <trap+0x9e>
80105b31:	e8 5a de ff ff       	call   80103990 <myproc>
80105b36:	8b 40 24             	mov    0x24(%eax),%eax
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	74 11                	je     80105b4e <trap+0x9e>
80105b3d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b41:	83 e0 03             	and    $0x3,%eax
80105b44:	66 83 f8 03          	cmp    $0x3,%ax
80105b48:	0f 84 0f 01 00 00    	je     80105c5d <trap+0x1ad>
    exit();
}
80105b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b51:	5b                   	pop    %ebx
80105b52:	5e                   	pop    %esi
80105b53:	5f                   	pop    %edi
80105b54:	5d                   	pop    %ebp
80105b55:	c3                   	ret    
80105b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b60:	e8 2b de ff ff       	call   80103990 <myproc>
80105b65:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b68:	85 c0                	test   %eax,%eax
80105b6a:	0f 84 a2 01 00 00    	je     80105d12 <trap+0x262>
80105b70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b74:	0f 84 98 01 00 00    	je     80105d12 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b7a:	0f 20 d1             	mov    %cr2,%ecx
80105b7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b80:	e8 eb dd ff ff       	call   80103970 <cpuid>
80105b85:	8b 73 30             	mov    0x30(%ebx),%esi
80105b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b8b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b91:	e8 fa dd ff ff       	call   80103990 <myproc>
80105b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b99:	e8 f2 dd ff ff       	call   80103990 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ba1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ba4:	51                   	push   %ecx
80105ba5:	57                   	push   %edi
80105ba6:	52                   	push   %edx
80105ba7:	ff 75 e4             	push   -0x1c(%ebp)
80105baa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bb1:	56                   	push   %esi
80105bb2:	ff 70 10             	push   0x10(%eax)
80105bb5:	68 a8 7b 10 80       	push   $0x80107ba8
80105bba:	e8 e1 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105bbf:	83 c4 20             	add    $0x20,%esp
80105bc2:	e8 c9 dd ff ff       	call   80103990 <myproc>
80105bc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bce:	e8 bd dd ff ff       	call   80103990 <myproc>
80105bd3:	85 c0                	test   %eax,%eax
80105bd5:	0f 85 18 ff ff ff    	jne    80105af3 <trap+0x43>
80105bdb:	e9 30 ff ff ff       	jmp    80105b10 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105be4:	0f 85 3e ff ff ff    	jne    80105b28 <trap+0x78>
    yield();
80105bea:	e8 21 e4 ff ff       	call   80104010 <yield>
80105bef:	e9 34 ff ff ff       	jmp    80105b28 <trap+0x78>
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bf8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bfb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bff:	e8 6c dd ff ff       	call   80103970 <cpuid>
80105c04:	57                   	push   %edi
80105c05:	56                   	push   %esi
80105c06:	50                   	push   %eax
80105c07:	68 50 7b 10 80       	push   $0x80107b50
80105c0c:	e8 8f aa ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105c11:	e8 0a cd ff ff       	call   80102920 <lapiceoi>
    break;
80105c16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c19:	e8 72 dd ff ff       	call   80103990 <myproc>
80105c1e:	85 c0                	test   %eax,%eax
80105c20:	0f 85 cd fe ff ff    	jne    80105af3 <trap+0x43>
80105c26:	e9 e5 fe ff ff       	jmp    80105b10 <trap+0x60>
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
    if(myproc()->killed)
80105c30:	e8 5b dd ff ff       	call   80103990 <myproc>
80105c35:	8b 70 24             	mov    0x24(%eax),%esi
80105c38:	85 f6                	test   %esi,%esi
80105c3a:	0f 85 c8 00 00 00    	jne    80105d08 <trap+0x258>
    myproc()->tf = tf;
80105c40:	e8 4b dd ff ff       	call   80103990 <myproc>
80105c45:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c48:	e8 43 ef ff ff       	call   80104b90 <syscall>
    if(myproc()->killed)
80105c4d:	e8 3e dd ff ff       	call   80103990 <myproc>
80105c52:	8b 48 24             	mov    0x24(%eax),%ecx
80105c55:	85 c9                	test   %ecx,%ecx
80105c57:	0f 84 f1 fe ff ff    	je     80105b4e <trap+0x9e>
}
80105c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c60:	5b                   	pop    %ebx
80105c61:	5e                   	pop    %esi
80105c62:	5f                   	pop    %edi
80105c63:	5d                   	pop    %ebp
      exit();
80105c64:	e9 47 e1 ff ff       	jmp    80103db0 <exit>
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c70:	e8 3b 02 00 00       	call   80105eb0 <uartintr>
    lapiceoi();
80105c75:	e8 a6 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7a:	e8 11 dd ff ff       	call   80103990 <myproc>
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	0f 85 6c fe ff ff    	jne    80105af3 <trap+0x43>
80105c87:	e9 84 fe ff ff       	jmp    80105b10 <trap+0x60>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c90:	e8 4b cb ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105c95:	e8 86 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 f1 dc ff ff       	call   80103990 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	0f 85 4c fe ff ff    	jne    80105af3 <trap+0x43>
80105ca7:	e9 64 fe ff ff       	jmp    80105b10 <trap+0x60>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105cb0:	e8 bb dc ff ff       	call   80103970 <cpuid>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 85 28 fe ff ff    	jne    80105ae5 <trap+0x35>
      acquire(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 80 3d 11 80       	push   $0x80113d80
80105cc5:	e8 06 ea ff ff       	call   801046d0 <acquire>
      wakeup(&ticks);
80105cca:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
      ticks++;
80105cd1:	83 05 60 3d 11 80 01 	addl   $0x1,0x80113d60
      wakeup(&ticks);
80105cd8:	e8 43 e4 ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80105cdd:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105ce4:	e8 87 e9 ff ff       	call   80104670 <release>
80105ce9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105cec:	e9 f4 fd ff ff       	jmp    80105ae5 <trap+0x35>
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105cf8:	e8 b3 e0 ff ff       	call   80103db0 <exit>
80105cfd:	e9 0e fe ff ff       	jmp    80105b10 <trap+0x60>
80105d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d08:	e8 a3 e0 ff ff       	call   80103db0 <exit>
80105d0d:	e9 2e ff ff ff       	jmp    80105c40 <trap+0x190>
80105d12:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d15:	e8 56 dc ff ff       	call   80103970 <cpuid>
80105d1a:	83 ec 0c             	sub    $0xc,%esp
80105d1d:	56                   	push   %esi
80105d1e:	57                   	push   %edi
80105d1f:	50                   	push   %eax
80105d20:	ff 73 30             	push   0x30(%ebx)
80105d23:	68 74 7b 10 80       	push   $0x80107b74
80105d28:	e8 73 a9 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105d2d:	83 c4 14             	add    $0x14,%esp
80105d30:	68 4a 7b 10 80       	push   $0x80107b4a
80105d35:	e8 46 a6 ff ff       	call   80100380 <panic>
80105d3a:	66 90                	xchg   %ax,%ax
80105d3c:	66 90                	xchg   %ax,%ax
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d40:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105d45:	85 c0                	test   %eax,%eax
80105d47:	74 17                	je     80105d60 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d49:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d4e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d4f:	a8 01                	test   $0x1,%al
80105d51:	74 0d                	je     80105d60 <uartgetc+0x20>
80105d53:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d58:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d59:	0f b6 c0             	movzbl %al,%eax
80105d5c:	c3                   	ret    
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d65:	c3                   	ret    
80105d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi

80105d70 <uartinit>:
{
80105d70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d71:	31 c9                	xor    %ecx,%ecx
80105d73:	89 c8                	mov    %ecx,%eax
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	57                   	push   %edi
80105d78:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d7d:	56                   	push   %esi
80105d7e:	89 fa                	mov    %edi,%edx
80105d80:	53                   	push   %ebx
80105d81:	83 ec 1c             	sub    $0x1c,%esp
80105d84:	ee                   	out    %al,(%dx)
80105d85:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d8f:	89 f2                	mov    %esi,%edx
80105d91:	ee                   	out    %al,(%dx)
80105d92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9c:	ee                   	out    %al,(%dx)
80105d9d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105da2:	89 c8                	mov    %ecx,%eax
80105da4:	89 da                	mov    %ebx,%edx
80105da6:	ee                   	out    %al,(%dx)
80105da7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dac:	89 f2                	mov    %esi,%edx
80105dae:	ee                   	out    %al,(%dx)
80105daf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105db4:	89 c8                	mov    %ecx,%eax
80105db6:	ee                   	out    %al,(%dx)
80105db7:	b8 01 00 00 00       	mov    $0x1,%eax
80105dbc:	89 da                	mov    %ebx,%edx
80105dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105dc5:	3c ff                	cmp    $0xff,%al
80105dc7:	74 78                	je     80105e41 <uartinit+0xd1>
  uart = 1;
80105dc9:	c7 05 c0 45 11 80 01 	movl   $0x1,0x801145c0
80105dd0:	00 00 00 
80105dd3:	89 fa                	mov    %edi,%edx
80105dd5:	ec                   	in     (%dx),%al
80105dd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ddb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ddc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ddf:	bf 6c 7c 10 80       	mov    $0x80107c6c,%edi
80105de4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105de9:	6a 00                	push   $0x0
80105deb:	6a 04                	push   $0x4
80105ded:	e8 9e c6 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105df2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105e00:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105e05:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e0a:	85 c0                	test   %eax,%eax
80105e0c:	75 14                	jne    80105e22 <uartinit+0xb2>
80105e0e:	eb 23                	jmp    80105e33 <uartinit+0xc3>
    microdelay(10);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	6a 0a                	push   $0xa
80105e15:	e8 26 cb ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	83 eb 01             	sub    $0x1,%ebx
80105e20:	74 07                	je     80105e29 <uartinit+0xb9>
80105e22:	89 f2                	mov    %esi,%edx
80105e24:	ec                   	in     (%dx),%al
80105e25:	a8 20                	test   $0x20,%al
80105e27:	74 e7                	je     80105e10 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e29:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e2d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e32:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e33:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e37:	83 c7 01             	add    $0x1,%edi
80105e3a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e3d:	84 c0                	test   %al,%al
80105e3f:	75 bf                	jne    80105e00 <uartinit+0x90>
}
80105e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e44:	5b                   	pop    %ebx
80105e45:	5e                   	pop    %esi
80105e46:	5f                   	pop    %edi
80105e47:	5d                   	pop    %ebp
80105e48:	c3                   	ret    
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e50 <uartputc>:
  if(!uart)
80105e50:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105e55:	85 c0                	test   %eax,%eax
80105e57:	74 47                	je     80105ea0 <uartputc+0x50>
{
80105e59:	55                   	push   %ebp
80105e5a:	89 e5                	mov    %esp,%ebp
80105e5c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e62:	53                   	push   %ebx
80105e63:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e68:	eb 18                	jmp    80105e82 <uartputc+0x32>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	6a 0a                	push   $0xa
80105e75:	e8 c6 ca ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	83 eb 01             	sub    $0x1,%ebx
80105e80:	74 07                	je     80105e89 <uartputc+0x39>
80105e82:	89 f2                	mov    %esi,%edx
80105e84:	ec                   	in     (%dx),%al
80105e85:	a8 20                	test   $0x20,%al
80105e87:	74 e7                	je     80105e70 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e89:	8b 45 08             	mov    0x8(%ebp),%eax
80105e8c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e91:	ee                   	out    %al,(%dx)
}
80105e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e95:	5b                   	pop    %ebx
80105e96:	5e                   	pop    %esi
80105e97:	5d                   	pop    %ebp
80105e98:	c3                   	ret    
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ea0:	c3                   	ret    
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop

80105eb0 <uartintr>:

void
uartintr(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105eb6:	68 40 5d 10 80       	push   $0x80105d40
80105ebb:	e8 c0 a9 ff ff       	call   80100880 <consoleintr>
}
80105ec0:	83 c4 10             	add    $0x10,%esp
80105ec3:	c9                   	leave  
80105ec4:	c3                   	ret    

80105ec5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ec5:	6a 00                	push   $0x0
  pushl $0
80105ec7:	6a 00                	push   $0x0
  jmp alltraps
80105ec9:	e9 09 fb ff ff       	jmp    801059d7 <alltraps>

80105ece <vector1>:
.globl vector1
vector1:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $1
80105ed0:	6a 01                	push   $0x1
  jmp alltraps
80105ed2:	e9 00 fb ff ff       	jmp    801059d7 <alltraps>

80105ed7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $2
80105ed9:	6a 02                	push   $0x2
  jmp alltraps
80105edb:	e9 f7 fa ff ff       	jmp    801059d7 <alltraps>

80105ee0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ee0:	6a 00                	push   $0x0
  pushl $3
80105ee2:	6a 03                	push   $0x3
  jmp alltraps
80105ee4:	e9 ee fa ff ff       	jmp    801059d7 <alltraps>

80105ee9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ee9:	6a 00                	push   $0x0
  pushl $4
80105eeb:	6a 04                	push   $0x4
  jmp alltraps
80105eed:	e9 e5 fa ff ff       	jmp    801059d7 <alltraps>

80105ef2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $5
80105ef4:	6a 05                	push   $0x5
  jmp alltraps
80105ef6:	e9 dc fa ff ff       	jmp    801059d7 <alltraps>

80105efb <vector6>:
.globl vector6
vector6:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $6
80105efd:	6a 06                	push   $0x6
  jmp alltraps
80105eff:	e9 d3 fa ff ff       	jmp    801059d7 <alltraps>

80105f04 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $7
80105f06:	6a 07                	push   $0x7
  jmp alltraps
80105f08:	e9 ca fa ff ff       	jmp    801059d7 <alltraps>

80105f0d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f0d:	6a 08                	push   $0x8
  jmp alltraps
80105f0f:	e9 c3 fa ff ff       	jmp    801059d7 <alltraps>

80105f14 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $9
80105f16:	6a 09                	push   $0x9
  jmp alltraps
80105f18:	e9 ba fa ff ff       	jmp    801059d7 <alltraps>

80105f1d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f1d:	6a 0a                	push   $0xa
  jmp alltraps
80105f1f:	e9 b3 fa ff ff       	jmp    801059d7 <alltraps>

80105f24 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f24:	6a 0b                	push   $0xb
  jmp alltraps
80105f26:	e9 ac fa ff ff       	jmp    801059d7 <alltraps>

80105f2b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f2b:	6a 0c                	push   $0xc
  jmp alltraps
80105f2d:	e9 a5 fa ff ff       	jmp    801059d7 <alltraps>

80105f32 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f32:	6a 0d                	push   $0xd
  jmp alltraps
80105f34:	e9 9e fa ff ff       	jmp    801059d7 <alltraps>

80105f39 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f39:	6a 0e                	push   $0xe
  jmp alltraps
80105f3b:	e9 97 fa ff ff       	jmp    801059d7 <alltraps>

80105f40 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $15
80105f42:	6a 0f                	push   $0xf
  jmp alltraps
80105f44:	e9 8e fa ff ff       	jmp    801059d7 <alltraps>

80105f49 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $16
80105f4b:	6a 10                	push   $0x10
  jmp alltraps
80105f4d:	e9 85 fa ff ff       	jmp    801059d7 <alltraps>

80105f52 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f52:	6a 11                	push   $0x11
  jmp alltraps
80105f54:	e9 7e fa ff ff       	jmp    801059d7 <alltraps>

80105f59 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $18
80105f5b:	6a 12                	push   $0x12
  jmp alltraps
80105f5d:	e9 75 fa ff ff       	jmp    801059d7 <alltraps>

80105f62 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $19
80105f64:	6a 13                	push   $0x13
  jmp alltraps
80105f66:	e9 6c fa ff ff       	jmp    801059d7 <alltraps>

80105f6b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $20
80105f6d:	6a 14                	push   $0x14
  jmp alltraps
80105f6f:	e9 63 fa ff ff       	jmp    801059d7 <alltraps>

80105f74 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $21
80105f76:	6a 15                	push   $0x15
  jmp alltraps
80105f78:	e9 5a fa ff ff       	jmp    801059d7 <alltraps>

80105f7d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $22
80105f7f:	6a 16                	push   $0x16
  jmp alltraps
80105f81:	e9 51 fa ff ff       	jmp    801059d7 <alltraps>

80105f86 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $23
80105f88:	6a 17                	push   $0x17
  jmp alltraps
80105f8a:	e9 48 fa ff ff       	jmp    801059d7 <alltraps>

80105f8f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $24
80105f91:	6a 18                	push   $0x18
  jmp alltraps
80105f93:	e9 3f fa ff ff       	jmp    801059d7 <alltraps>

80105f98 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $25
80105f9a:	6a 19                	push   $0x19
  jmp alltraps
80105f9c:	e9 36 fa ff ff       	jmp    801059d7 <alltraps>

80105fa1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $26
80105fa3:	6a 1a                	push   $0x1a
  jmp alltraps
80105fa5:	e9 2d fa ff ff       	jmp    801059d7 <alltraps>

80105faa <vector27>:
.globl vector27
vector27:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $27
80105fac:	6a 1b                	push   $0x1b
  jmp alltraps
80105fae:	e9 24 fa ff ff       	jmp    801059d7 <alltraps>

80105fb3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $28
80105fb5:	6a 1c                	push   $0x1c
  jmp alltraps
80105fb7:	e9 1b fa ff ff       	jmp    801059d7 <alltraps>

80105fbc <vector29>:
.globl vector29
vector29:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $29
80105fbe:	6a 1d                	push   $0x1d
  jmp alltraps
80105fc0:	e9 12 fa ff ff       	jmp    801059d7 <alltraps>

80105fc5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $30
80105fc7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fc9:	e9 09 fa ff ff       	jmp    801059d7 <alltraps>

80105fce <vector31>:
.globl vector31
vector31:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $31
80105fd0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fd2:	e9 00 fa ff ff       	jmp    801059d7 <alltraps>

80105fd7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $32
80105fd9:	6a 20                	push   $0x20
  jmp alltraps
80105fdb:	e9 f7 f9 ff ff       	jmp    801059d7 <alltraps>

80105fe0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $33
80105fe2:	6a 21                	push   $0x21
  jmp alltraps
80105fe4:	e9 ee f9 ff ff       	jmp    801059d7 <alltraps>

80105fe9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $34
80105feb:	6a 22                	push   $0x22
  jmp alltraps
80105fed:	e9 e5 f9 ff ff       	jmp    801059d7 <alltraps>

80105ff2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $35
80105ff4:	6a 23                	push   $0x23
  jmp alltraps
80105ff6:	e9 dc f9 ff ff       	jmp    801059d7 <alltraps>

80105ffb <vector36>:
.globl vector36
vector36:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $36
80105ffd:	6a 24                	push   $0x24
  jmp alltraps
80105fff:	e9 d3 f9 ff ff       	jmp    801059d7 <alltraps>

80106004 <vector37>:
.globl vector37
vector37:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $37
80106006:	6a 25                	push   $0x25
  jmp alltraps
80106008:	e9 ca f9 ff ff       	jmp    801059d7 <alltraps>

8010600d <vector38>:
.globl vector38
vector38:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $38
8010600f:	6a 26                	push   $0x26
  jmp alltraps
80106011:	e9 c1 f9 ff ff       	jmp    801059d7 <alltraps>

80106016 <vector39>:
.globl vector39
vector39:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $39
80106018:	6a 27                	push   $0x27
  jmp alltraps
8010601a:	e9 b8 f9 ff ff       	jmp    801059d7 <alltraps>

8010601f <vector40>:
.globl vector40
vector40:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $40
80106021:	6a 28                	push   $0x28
  jmp alltraps
80106023:	e9 af f9 ff ff       	jmp    801059d7 <alltraps>

80106028 <vector41>:
.globl vector41
vector41:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $41
8010602a:	6a 29                	push   $0x29
  jmp alltraps
8010602c:	e9 a6 f9 ff ff       	jmp    801059d7 <alltraps>

80106031 <vector42>:
.globl vector42
vector42:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $42
80106033:	6a 2a                	push   $0x2a
  jmp alltraps
80106035:	e9 9d f9 ff ff       	jmp    801059d7 <alltraps>

8010603a <vector43>:
.globl vector43
vector43:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $43
8010603c:	6a 2b                	push   $0x2b
  jmp alltraps
8010603e:	e9 94 f9 ff ff       	jmp    801059d7 <alltraps>

80106043 <vector44>:
.globl vector44
vector44:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $44
80106045:	6a 2c                	push   $0x2c
  jmp alltraps
80106047:	e9 8b f9 ff ff       	jmp    801059d7 <alltraps>

8010604c <vector45>:
.globl vector45
vector45:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $45
8010604e:	6a 2d                	push   $0x2d
  jmp alltraps
80106050:	e9 82 f9 ff ff       	jmp    801059d7 <alltraps>

80106055 <vector46>:
.globl vector46
vector46:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $46
80106057:	6a 2e                	push   $0x2e
  jmp alltraps
80106059:	e9 79 f9 ff ff       	jmp    801059d7 <alltraps>

8010605e <vector47>:
.globl vector47
vector47:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $47
80106060:	6a 2f                	push   $0x2f
  jmp alltraps
80106062:	e9 70 f9 ff ff       	jmp    801059d7 <alltraps>

80106067 <vector48>:
.globl vector48
vector48:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $48
80106069:	6a 30                	push   $0x30
  jmp alltraps
8010606b:	e9 67 f9 ff ff       	jmp    801059d7 <alltraps>

80106070 <vector49>:
.globl vector49
vector49:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $49
80106072:	6a 31                	push   $0x31
  jmp alltraps
80106074:	e9 5e f9 ff ff       	jmp    801059d7 <alltraps>

80106079 <vector50>:
.globl vector50
vector50:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $50
8010607b:	6a 32                	push   $0x32
  jmp alltraps
8010607d:	e9 55 f9 ff ff       	jmp    801059d7 <alltraps>

80106082 <vector51>:
.globl vector51
vector51:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $51
80106084:	6a 33                	push   $0x33
  jmp alltraps
80106086:	e9 4c f9 ff ff       	jmp    801059d7 <alltraps>

8010608b <vector52>:
.globl vector52
vector52:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $52
8010608d:	6a 34                	push   $0x34
  jmp alltraps
8010608f:	e9 43 f9 ff ff       	jmp    801059d7 <alltraps>

80106094 <vector53>:
.globl vector53
vector53:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $53
80106096:	6a 35                	push   $0x35
  jmp alltraps
80106098:	e9 3a f9 ff ff       	jmp    801059d7 <alltraps>

8010609d <vector54>:
.globl vector54
vector54:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $54
8010609f:	6a 36                	push   $0x36
  jmp alltraps
801060a1:	e9 31 f9 ff ff       	jmp    801059d7 <alltraps>

801060a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $55
801060a8:	6a 37                	push   $0x37
  jmp alltraps
801060aa:	e9 28 f9 ff ff       	jmp    801059d7 <alltraps>

801060af <vector56>:
.globl vector56
vector56:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $56
801060b1:	6a 38                	push   $0x38
  jmp alltraps
801060b3:	e9 1f f9 ff ff       	jmp    801059d7 <alltraps>

801060b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $57
801060ba:	6a 39                	push   $0x39
  jmp alltraps
801060bc:	e9 16 f9 ff ff       	jmp    801059d7 <alltraps>

801060c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $58
801060c3:	6a 3a                	push   $0x3a
  jmp alltraps
801060c5:	e9 0d f9 ff ff       	jmp    801059d7 <alltraps>

801060ca <vector59>:
.globl vector59
vector59:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $59
801060cc:	6a 3b                	push   $0x3b
  jmp alltraps
801060ce:	e9 04 f9 ff ff       	jmp    801059d7 <alltraps>

801060d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $60
801060d5:	6a 3c                	push   $0x3c
  jmp alltraps
801060d7:	e9 fb f8 ff ff       	jmp    801059d7 <alltraps>

801060dc <vector61>:
.globl vector61
vector61:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $61
801060de:	6a 3d                	push   $0x3d
  jmp alltraps
801060e0:	e9 f2 f8 ff ff       	jmp    801059d7 <alltraps>

801060e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $62
801060e7:	6a 3e                	push   $0x3e
  jmp alltraps
801060e9:	e9 e9 f8 ff ff       	jmp    801059d7 <alltraps>

801060ee <vector63>:
.globl vector63
vector63:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $63
801060f0:	6a 3f                	push   $0x3f
  jmp alltraps
801060f2:	e9 e0 f8 ff ff       	jmp    801059d7 <alltraps>

801060f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $64
801060f9:	6a 40                	push   $0x40
  jmp alltraps
801060fb:	e9 d7 f8 ff ff       	jmp    801059d7 <alltraps>

80106100 <vector65>:
.globl vector65
vector65:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $65
80106102:	6a 41                	push   $0x41
  jmp alltraps
80106104:	e9 ce f8 ff ff       	jmp    801059d7 <alltraps>

80106109 <vector66>:
.globl vector66
vector66:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $66
8010610b:	6a 42                	push   $0x42
  jmp alltraps
8010610d:	e9 c5 f8 ff ff       	jmp    801059d7 <alltraps>

80106112 <vector67>:
.globl vector67
vector67:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $67
80106114:	6a 43                	push   $0x43
  jmp alltraps
80106116:	e9 bc f8 ff ff       	jmp    801059d7 <alltraps>

8010611b <vector68>:
.globl vector68
vector68:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $68
8010611d:	6a 44                	push   $0x44
  jmp alltraps
8010611f:	e9 b3 f8 ff ff       	jmp    801059d7 <alltraps>

80106124 <vector69>:
.globl vector69
vector69:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $69
80106126:	6a 45                	push   $0x45
  jmp alltraps
80106128:	e9 aa f8 ff ff       	jmp    801059d7 <alltraps>

8010612d <vector70>:
.globl vector70
vector70:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $70
8010612f:	6a 46                	push   $0x46
  jmp alltraps
80106131:	e9 a1 f8 ff ff       	jmp    801059d7 <alltraps>

80106136 <vector71>:
.globl vector71
vector71:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $71
80106138:	6a 47                	push   $0x47
  jmp alltraps
8010613a:	e9 98 f8 ff ff       	jmp    801059d7 <alltraps>

8010613f <vector72>:
.globl vector72
vector72:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $72
80106141:	6a 48                	push   $0x48
  jmp alltraps
80106143:	e9 8f f8 ff ff       	jmp    801059d7 <alltraps>

80106148 <vector73>:
.globl vector73
vector73:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $73
8010614a:	6a 49                	push   $0x49
  jmp alltraps
8010614c:	e9 86 f8 ff ff       	jmp    801059d7 <alltraps>

80106151 <vector74>:
.globl vector74
vector74:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $74
80106153:	6a 4a                	push   $0x4a
  jmp alltraps
80106155:	e9 7d f8 ff ff       	jmp    801059d7 <alltraps>

8010615a <vector75>:
.globl vector75
vector75:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $75
8010615c:	6a 4b                	push   $0x4b
  jmp alltraps
8010615e:	e9 74 f8 ff ff       	jmp    801059d7 <alltraps>

80106163 <vector76>:
.globl vector76
vector76:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $76
80106165:	6a 4c                	push   $0x4c
  jmp alltraps
80106167:	e9 6b f8 ff ff       	jmp    801059d7 <alltraps>

8010616c <vector77>:
.globl vector77
vector77:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $77
8010616e:	6a 4d                	push   $0x4d
  jmp alltraps
80106170:	e9 62 f8 ff ff       	jmp    801059d7 <alltraps>

80106175 <vector78>:
.globl vector78
vector78:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $78
80106177:	6a 4e                	push   $0x4e
  jmp alltraps
80106179:	e9 59 f8 ff ff       	jmp    801059d7 <alltraps>

8010617e <vector79>:
.globl vector79
vector79:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $79
80106180:	6a 4f                	push   $0x4f
  jmp alltraps
80106182:	e9 50 f8 ff ff       	jmp    801059d7 <alltraps>

80106187 <vector80>:
.globl vector80
vector80:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $80
80106189:	6a 50                	push   $0x50
  jmp alltraps
8010618b:	e9 47 f8 ff ff       	jmp    801059d7 <alltraps>

80106190 <vector81>:
.globl vector81
vector81:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $81
80106192:	6a 51                	push   $0x51
  jmp alltraps
80106194:	e9 3e f8 ff ff       	jmp    801059d7 <alltraps>

80106199 <vector82>:
.globl vector82
vector82:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $82
8010619b:	6a 52                	push   $0x52
  jmp alltraps
8010619d:	e9 35 f8 ff ff       	jmp    801059d7 <alltraps>

801061a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $83
801061a4:	6a 53                	push   $0x53
  jmp alltraps
801061a6:	e9 2c f8 ff ff       	jmp    801059d7 <alltraps>

801061ab <vector84>:
.globl vector84
vector84:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $84
801061ad:	6a 54                	push   $0x54
  jmp alltraps
801061af:	e9 23 f8 ff ff       	jmp    801059d7 <alltraps>

801061b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $85
801061b6:	6a 55                	push   $0x55
  jmp alltraps
801061b8:	e9 1a f8 ff ff       	jmp    801059d7 <alltraps>

801061bd <vector86>:
.globl vector86
vector86:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $86
801061bf:	6a 56                	push   $0x56
  jmp alltraps
801061c1:	e9 11 f8 ff ff       	jmp    801059d7 <alltraps>

801061c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $87
801061c8:	6a 57                	push   $0x57
  jmp alltraps
801061ca:	e9 08 f8 ff ff       	jmp    801059d7 <alltraps>

801061cf <vector88>:
.globl vector88
vector88:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $88
801061d1:	6a 58                	push   $0x58
  jmp alltraps
801061d3:	e9 ff f7 ff ff       	jmp    801059d7 <alltraps>

801061d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $89
801061da:	6a 59                	push   $0x59
  jmp alltraps
801061dc:	e9 f6 f7 ff ff       	jmp    801059d7 <alltraps>

801061e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $90
801061e3:	6a 5a                	push   $0x5a
  jmp alltraps
801061e5:	e9 ed f7 ff ff       	jmp    801059d7 <alltraps>

801061ea <vector91>:
.globl vector91
vector91:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $91
801061ec:	6a 5b                	push   $0x5b
  jmp alltraps
801061ee:	e9 e4 f7 ff ff       	jmp    801059d7 <alltraps>

801061f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $92
801061f5:	6a 5c                	push   $0x5c
  jmp alltraps
801061f7:	e9 db f7 ff ff       	jmp    801059d7 <alltraps>

801061fc <vector93>:
.globl vector93
vector93:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $93
801061fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106200:	e9 d2 f7 ff ff       	jmp    801059d7 <alltraps>

80106205 <vector94>:
.globl vector94
vector94:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $94
80106207:	6a 5e                	push   $0x5e
  jmp alltraps
80106209:	e9 c9 f7 ff ff       	jmp    801059d7 <alltraps>

8010620e <vector95>:
.globl vector95
vector95:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $95
80106210:	6a 5f                	push   $0x5f
  jmp alltraps
80106212:	e9 c0 f7 ff ff       	jmp    801059d7 <alltraps>

80106217 <vector96>:
.globl vector96
vector96:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $96
80106219:	6a 60                	push   $0x60
  jmp alltraps
8010621b:	e9 b7 f7 ff ff       	jmp    801059d7 <alltraps>

80106220 <vector97>:
.globl vector97
vector97:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $97
80106222:	6a 61                	push   $0x61
  jmp alltraps
80106224:	e9 ae f7 ff ff       	jmp    801059d7 <alltraps>

80106229 <vector98>:
.globl vector98
vector98:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $98
8010622b:	6a 62                	push   $0x62
  jmp alltraps
8010622d:	e9 a5 f7 ff ff       	jmp    801059d7 <alltraps>

80106232 <vector99>:
.globl vector99
vector99:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $99
80106234:	6a 63                	push   $0x63
  jmp alltraps
80106236:	e9 9c f7 ff ff       	jmp    801059d7 <alltraps>

8010623b <vector100>:
.globl vector100
vector100:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $100
8010623d:	6a 64                	push   $0x64
  jmp alltraps
8010623f:	e9 93 f7 ff ff       	jmp    801059d7 <alltraps>

80106244 <vector101>:
.globl vector101
vector101:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $101
80106246:	6a 65                	push   $0x65
  jmp alltraps
80106248:	e9 8a f7 ff ff       	jmp    801059d7 <alltraps>

8010624d <vector102>:
.globl vector102
vector102:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $102
8010624f:	6a 66                	push   $0x66
  jmp alltraps
80106251:	e9 81 f7 ff ff       	jmp    801059d7 <alltraps>

80106256 <vector103>:
.globl vector103
vector103:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $103
80106258:	6a 67                	push   $0x67
  jmp alltraps
8010625a:	e9 78 f7 ff ff       	jmp    801059d7 <alltraps>

8010625f <vector104>:
.globl vector104
vector104:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $104
80106261:	6a 68                	push   $0x68
  jmp alltraps
80106263:	e9 6f f7 ff ff       	jmp    801059d7 <alltraps>

80106268 <vector105>:
.globl vector105
vector105:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $105
8010626a:	6a 69                	push   $0x69
  jmp alltraps
8010626c:	e9 66 f7 ff ff       	jmp    801059d7 <alltraps>

80106271 <vector106>:
.globl vector106
vector106:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $106
80106273:	6a 6a                	push   $0x6a
  jmp alltraps
80106275:	e9 5d f7 ff ff       	jmp    801059d7 <alltraps>

8010627a <vector107>:
.globl vector107
vector107:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $107
8010627c:	6a 6b                	push   $0x6b
  jmp alltraps
8010627e:	e9 54 f7 ff ff       	jmp    801059d7 <alltraps>

80106283 <vector108>:
.globl vector108
vector108:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $108
80106285:	6a 6c                	push   $0x6c
  jmp alltraps
80106287:	e9 4b f7 ff ff       	jmp    801059d7 <alltraps>

8010628c <vector109>:
.globl vector109
vector109:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $109
8010628e:	6a 6d                	push   $0x6d
  jmp alltraps
80106290:	e9 42 f7 ff ff       	jmp    801059d7 <alltraps>

80106295 <vector110>:
.globl vector110
vector110:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $110
80106297:	6a 6e                	push   $0x6e
  jmp alltraps
80106299:	e9 39 f7 ff ff       	jmp    801059d7 <alltraps>

8010629e <vector111>:
.globl vector111
vector111:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $111
801062a0:	6a 6f                	push   $0x6f
  jmp alltraps
801062a2:	e9 30 f7 ff ff       	jmp    801059d7 <alltraps>

801062a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $112
801062a9:	6a 70                	push   $0x70
  jmp alltraps
801062ab:	e9 27 f7 ff ff       	jmp    801059d7 <alltraps>

801062b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $113
801062b2:	6a 71                	push   $0x71
  jmp alltraps
801062b4:	e9 1e f7 ff ff       	jmp    801059d7 <alltraps>

801062b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $114
801062bb:	6a 72                	push   $0x72
  jmp alltraps
801062bd:	e9 15 f7 ff ff       	jmp    801059d7 <alltraps>

801062c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $115
801062c4:	6a 73                	push   $0x73
  jmp alltraps
801062c6:	e9 0c f7 ff ff       	jmp    801059d7 <alltraps>

801062cb <vector116>:
.globl vector116
vector116:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $116
801062cd:	6a 74                	push   $0x74
  jmp alltraps
801062cf:	e9 03 f7 ff ff       	jmp    801059d7 <alltraps>

801062d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $117
801062d6:	6a 75                	push   $0x75
  jmp alltraps
801062d8:	e9 fa f6 ff ff       	jmp    801059d7 <alltraps>

801062dd <vector118>:
.globl vector118
vector118:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $118
801062df:	6a 76                	push   $0x76
  jmp alltraps
801062e1:	e9 f1 f6 ff ff       	jmp    801059d7 <alltraps>

801062e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $119
801062e8:	6a 77                	push   $0x77
  jmp alltraps
801062ea:	e9 e8 f6 ff ff       	jmp    801059d7 <alltraps>

801062ef <vector120>:
.globl vector120
vector120:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $120
801062f1:	6a 78                	push   $0x78
  jmp alltraps
801062f3:	e9 df f6 ff ff       	jmp    801059d7 <alltraps>

801062f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $121
801062fa:	6a 79                	push   $0x79
  jmp alltraps
801062fc:	e9 d6 f6 ff ff       	jmp    801059d7 <alltraps>

80106301 <vector122>:
.globl vector122
vector122:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $122
80106303:	6a 7a                	push   $0x7a
  jmp alltraps
80106305:	e9 cd f6 ff ff       	jmp    801059d7 <alltraps>

8010630a <vector123>:
.globl vector123
vector123:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $123
8010630c:	6a 7b                	push   $0x7b
  jmp alltraps
8010630e:	e9 c4 f6 ff ff       	jmp    801059d7 <alltraps>

80106313 <vector124>:
.globl vector124
vector124:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $124
80106315:	6a 7c                	push   $0x7c
  jmp alltraps
80106317:	e9 bb f6 ff ff       	jmp    801059d7 <alltraps>

8010631c <vector125>:
.globl vector125
vector125:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $125
8010631e:	6a 7d                	push   $0x7d
  jmp alltraps
80106320:	e9 b2 f6 ff ff       	jmp    801059d7 <alltraps>

80106325 <vector126>:
.globl vector126
vector126:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $126
80106327:	6a 7e                	push   $0x7e
  jmp alltraps
80106329:	e9 a9 f6 ff ff       	jmp    801059d7 <alltraps>

8010632e <vector127>:
.globl vector127
vector127:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $127
80106330:	6a 7f                	push   $0x7f
  jmp alltraps
80106332:	e9 a0 f6 ff ff       	jmp    801059d7 <alltraps>

80106337 <vector128>:
.globl vector128
vector128:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $128
80106339:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010633e:	e9 94 f6 ff ff       	jmp    801059d7 <alltraps>

80106343 <vector129>:
.globl vector129
vector129:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $129
80106345:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010634a:	e9 88 f6 ff ff       	jmp    801059d7 <alltraps>

8010634f <vector130>:
.globl vector130
vector130:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $130
80106351:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106356:	e9 7c f6 ff ff       	jmp    801059d7 <alltraps>

8010635b <vector131>:
.globl vector131
vector131:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $131
8010635d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106362:	e9 70 f6 ff ff       	jmp    801059d7 <alltraps>

80106367 <vector132>:
.globl vector132
vector132:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $132
80106369:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010636e:	e9 64 f6 ff ff       	jmp    801059d7 <alltraps>

80106373 <vector133>:
.globl vector133
vector133:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $133
80106375:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010637a:	e9 58 f6 ff ff       	jmp    801059d7 <alltraps>

8010637f <vector134>:
.globl vector134
vector134:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $134
80106381:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106386:	e9 4c f6 ff ff       	jmp    801059d7 <alltraps>

8010638b <vector135>:
.globl vector135
vector135:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $135
8010638d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106392:	e9 40 f6 ff ff       	jmp    801059d7 <alltraps>

80106397 <vector136>:
.globl vector136
vector136:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $136
80106399:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010639e:	e9 34 f6 ff ff       	jmp    801059d7 <alltraps>

801063a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $137
801063a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063aa:	e9 28 f6 ff ff       	jmp    801059d7 <alltraps>

801063af <vector138>:
.globl vector138
vector138:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $138
801063b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063b6:	e9 1c f6 ff ff       	jmp    801059d7 <alltraps>

801063bb <vector139>:
.globl vector139
vector139:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $139
801063bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063c2:	e9 10 f6 ff ff       	jmp    801059d7 <alltraps>

801063c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $140
801063c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063ce:	e9 04 f6 ff ff       	jmp    801059d7 <alltraps>

801063d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $141
801063d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063da:	e9 f8 f5 ff ff       	jmp    801059d7 <alltraps>

801063df <vector142>:
.globl vector142
vector142:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $142
801063e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063e6:	e9 ec f5 ff ff       	jmp    801059d7 <alltraps>

801063eb <vector143>:
.globl vector143
vector143:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $143
801063ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063f2:	e9 e0 f5 ff ff       	jmp    801059d7 <alltraps>

801063f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $144
801063f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063fe:	e9 d4 f5 ff ff       	jmp    801059d7 <alltraps>

80106403 <vector145>:
.globl vector145
vector145:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $145
80106405:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010640a:	e9 c8 f5 ff ff       	jmp    801059d7 <alltraps>

8010640f <vector146>:
.globl vector146
vector146:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $146
80106411:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106416:	e9 bc f5 ff ff       	jmp    801059d7 <alltraps>

8010641b <vector147>:
.globl vector147
vector147:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $147
8010641d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106422:	e9 b0 f5 ff ff       	jmp    801059d7 <alltraps>

80106427 <vector148>:
.globl vector148
vector148:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $148
80106429:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010642e:	e9 a4 f5 ff ff       	jmp    801059d7 <alltraps>

80106433 <vector149>:
.globl vector149
vector149:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $149
80106435:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010643a:	e9 98 f5 ff ff       	jmp    801059d7 <alltraps>

8010643f <vector150>:
.globl vector150
vector150:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $150
80106441:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106446:	e9 8c f5 ff ff       	jmp    801059d7 <alltraps>

8010644b <vector151>:
.globl vector151
vector151:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $151
8010644d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106452:	e9 80 f5 ff ff       	jmp    801059d7 <alltraps>

80106457 <vector152>:
.globl vector152
vector152:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $152
80106459:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010645e:	e9 74 f5 ff ff       	jmp    801059d7 <alltraps>

80106463 <vector153>:
.globl vector153
vector153:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $153
80106465:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010646a:	e9 68 f5 ff ff       	jmp    801059d7 <alltraps>

8010646f <vector154>:
.globl vector154
vector154:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $154
80106471:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106476:	e9 5c f5 ff ff       	jmp    801059d7 <alltraps>

8010647b <vector155>:
.globl vector155
vector155:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $155
8010647d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106482:	e9 50 f5 ff ff       	jmp    801059d7 <alltraps>

80106487 <vector156>:
.globl vector156
vector156:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $156
80106489:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010648e:	e9 44 f5 ff ff       	jmp    801059d7 <alltraps>

80106493 <vector157>:
.globl vector157
vector157:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $157
80106495:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010649a:	e9 38 f5 ff ff       	jmp    801059d7 <alltraps>

8010649f <vector158>:
.globl vector158
vector158:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $158
801064a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064a6:	e9 2c f5 ff ff       	jmp    801059d7 <alltraps>

801064ab <vector159>:
.globl vector159
vector159:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $159
801064ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064b2:	e9 20 f5 ff ff       	jmp    801059d7 <alltraps>

801064b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $160
801064b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064be:	e9 14 f5 ff ff       	jmp    801059d7 <alltraps>

801064c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $161
801064c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064ca:	e9 08 f5 ff ff       	jmp    801059d7 <alltraps>

801064cf <vector162>:
.globl vector162
vector162:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $162
801064d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064d6:	e9 fc f4 ff ff       	jmp    801059d7 <alltraps>

801064db <vector163>:
.globl vector163
vector163:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $163
801064dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064e2:	e9 f0 f4 ff ff       	jmp    801059d7 <alltraps>

801064e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $164
801064e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064ee:	e9 e4 f4 ff ff       	jmp    801059d7 <alltraps>

801064f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $165
801064f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064fa:	e9 d8 f4 ff ff       	jmp    801059d7 <alltraps>

801064ff <vector166>:
.globl vector166
vector166:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $166
80106501:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106506:	e9 cc f4 ff ff       	jmp    801059d7 <alltraps>

8010650b <vector167>:
.globl vector167
vector167:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $167
8010650d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106512:	e9 c0 f4 ff ff       	jmp    801059d7 <alltraps>

80106517 <vector168>:
.globl vector168
vector168:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $168
80106519:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010651e:	e9 b4 f4 ff ff       	jmp    801059d7 <alltraps>

80106523 <vector169>:
.globl vector169
vector169:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $169
80106525:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010652a:	e9 a8 f4 ff ff       	jmp    801059d7 <alltraps>

8010652f <vector170>:
.globl vector170
vector170:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $170
80106531:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106536:	e9 9c f4 ff ff       	jmp    801059d7 <alltraps>

8010653b <vector171>:
.globl vector171
vector171:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $171
8010653d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106542:	e9 90 f4 ff ff       	jmp    801059d7 <alltraps>

80106547 <vector172>:
.globl vector172
vector172:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $172
80106549:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010654e:	e9 84 f4 ff ff       	jmp    801059d7 <alltraps>

80106553 <vector173>:
.globl vector173
vector173:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $173
80106555:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010655a:	e9 78 f4 ff ff       	jmp    801059d7 <alltraps>

8010655f <vector174>:
.globl vector174
vector174:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $174
80106561:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106566:	e9 6c f4 ff ff       	jmp    801059d7 <alltraps>

8010656b <vector175>:
.globl vector175
vector175:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $175
8010656d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106572:	e9 60 f4 ff ff       	jmp    801059d7 <alltraps>

80106577 <vector176>:
.globl vector176
vector176:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $176
80106579:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010657e:	e9 54 f4 ff ff       	jmp    801059d7 <alltraps>

80106583 <vector177>:
.globl vector177
vector177:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $177
80106585:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010658a:	e9 48 f4 ff ff       	jmp    801059d7 <alltraps>

8010658f <vector178>:
.globl vector178
vector178:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $178
80106591:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106596:	e9 3c f4 ff ff       	jmp    801059d7 <alltraps>

8010659b <vector179>:
.globl vector179
vector179:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $179
8010659d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065a2:	e9 30 f4 ff ff       	jmp    801059d7 <alltraps>

801065a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $180
801065a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065ae:	e9 24 f4 ff ff       	jmp    801059d7 <alltraps>

801065b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $181
801065b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065ba:	e9 18 f4 ff ff       	jmp    801059d7 <alltraps>

801065bf <vector182>:
.globl vector182
vector182:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $182
801065c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065c6:	e9 0c f4 ff ff       	jmp    801059d7 <alltraps>

801065cb <vector183>:
.globl vector183
vector183:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $183
801065cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065d2:	e9 00 f4 ff ff       	jmp    801059d7 <alltraps>

801065d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $184
801065d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065de:	e9 f4 f3 ff ff       	jmp    801059d7 <alltraps>

801065e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $185
801065e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065ea:	e9 e8 f3 ff ff       	jmp    801059d7 <alltraps>

801065ef <vector186>:
.globl vector186
vector186:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $186
801065f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065f6:	e9 dc f3 ff ff       	jmp    801059d7 <alltraps>

801065fb <vector187>:
.globl vector187
vector187:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $187
801065fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106602:	e9 d0 f3 ff ff       	jmp    801059d7 <alltraps>

80106607 <vector188>:
.globl vector188
vector188:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $188
80106609:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010660e:	e9 c4 f3 ff ff       	jmp    801059d7 <alltraps>

80106613 <vector189>:
.globl vector189
vector189:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $189
80106615:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010661a:	e9 b8 f3 ff ff       	jmp    801059d7 <alltraps>

8010661f <vector190>:
.globl vector190
vector190:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $190
80106621:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106626:	e9 ac f3 ff ff       	jmp    801059d7 <alltraps>

8010662b <vector191>:
.globl vector191
vector191:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $191
8010662d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106632:	e9 a0 f3 ff ff       	jmp    801059d7 <alltraps>

80106637 <vector192>:
.globl vector192
vector192:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $192
80106639:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010663e:	e9 94 f3 ff ff       	jmp    801059d7 <alltraps>

80106643 <vector193>:
.globl vector193
vector193:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $193
80106645:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010664a:	e9 88 f3 ff ff       	jmp    801059d7 <alltraps>

8010664f <vector194>:
.globl vector194
vector194:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $194
80106651:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106656:	e9 7c f3 ff ff       	jmp    801059d7 <alltraps>

8010665b <vector195>:
.globl vector195
vector195:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $195
8010665d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106662:	e9 70 f3 ff ff       	jmp    801059d7 <alltraps>

80106667 <vector196>:
.globl vector196
vector196:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $196
80106669:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010666e:	e9 64 f3 ff ff       	jmp    801059d7 <alltraps>

80106673 <vector197>:
.globl vector197
vector197:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $197
80106675:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010667a:	e9 58 f3 ff ff       	jmp    801059d7 <alltraps>

8010667f <vector198>:
.globl vector198
vector198:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $198
80106681:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106686:	e9 4c f3 ff ff       	jmp    801059d7 <alltraps>

8010668b <vector199>:
.globl vector199
vector199:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $199
8010668d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106692:	e9 40 f3 ff ff       	jmp    801059d7 <alltraps>

80106697 <vector200>:
.globl vector200
vector200:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $200
80106699:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010669e:	e9 34 f3 ff ff       	jmp    801059d7 <alltraps>

801066a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $201
801066a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066aa:	e9 28 f3 ff ff       	jmp    801059d7 <alltraps>

801066af <vector202>:
.globl vector202
vector202:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $202
801066b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066b6:	e9 1c f3 ff ff       	jmp    801059d7 <alltraps>

801066bb <vector203>:
.globl vector203
vector203:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $203
801066bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066c2:	e9 10 f3 ff ff       	jmp    801059d7 <alltraps>

801066c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $204
801066c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066ce:	e9 04 f3 ff ff       	jmp    801059d7 <alltraps>

801066d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $205
801066d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066da:	e9 f8 f2 ff ff       	jmp    801059d7 <alltraps>

801066df <vector206>:
.globl vector206
vector206:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $206
801066e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066e6:	e9 ec f2 ff ff       	jmp    801059d7 <alltraps>

801066eb <vector207>:
.globl vector207
vector207:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $207
801066ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066f2:	e9 e0 f2 ff ff       	jmp    801059d7 <alltraps>

801066f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $208
801066f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066fe:	e9 d4 f2 ff ff       	jmp    801059d7 <alltraps>

80106703 <vector209>:
.globl vector209
vector209:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $209
80106705:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010670a:	e9 c8 f2 ff ff       	jmp    801059d7 <alltraps>

8010670f <vector210>:
.globl vector210
vector210:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $210
80106711:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106716:	e9 bc f2 ff ff       	jmp    801059d7 <alltraps>

8010671b <vector211>:
.globl vector211
vector211:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $211
8010671d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106722:	e9 b0 f2 ff ff       	jmp    801059d7 <alltraps>

80106727 <vector212>:
.globl vector212
vector212:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $212
80106729:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010672e:	e9 a4 f2 ff ff       	jmp    801059d7 <alltraps>

80106733 <vector213>:
.globl vector213
vector213:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $213
80106735:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010673a:	e9 98 f2 ff ff       	jmp    801059d7 <alltraps>

8010673f <vector214>:
.globl vector214
vector214:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $214
80106741:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106746:	e9 8c f2 ff ff       	jmp    801059d7 <alltraps>

8010674b <vector215>:
.globl vector215
vector215:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $215
8010674d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106752:	e9 80 f2 ff ff       	jmp    801059d7 <alltraps>

80106757 <vector216>:
.globl vector216
vector216:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $216
80106759:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010675e:	e9 74 f2 ff ff       	jmp    801059d7 <alltraps>

80106763 <vector217>:
.globl vector217
vector217:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $217
80106765:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010676a:	e9 68 f2 ff ff       	jmp    801059d7 <alltraps>

8010676f <vector218>:
.globl vector218
vector218:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $218
80106771:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106776:	e9 5c f2 ff ff       	jmp    801059d7 <alltraps>

8010677b <vector219>:
.globl vector219
vector219:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $219
8010677d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106782:	e9 50 f2 ff ff       	jmp    801059d7 <alltraps>

80106787 <vector220>:
.globl vector220
vector220:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $220
80106789:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010678e:	e9 44 f2 ff ff       	jmp    801059d7 <alltraps>

80106793 <vector221>:
.globl vector221
vector221:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $221
80106795:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010679a:	e9 38 f2 ff ff       	jmp    801059d7 <alltraps>

8010679f <vector222>:
.globl vector222
vector222:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $222
801067a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067a6:	e9 2c f2 ff ff       	jmp    801059d7 <alltraps>

801067ab <vector223>:
.globl vector223
vector223:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $223
801067ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067b2:	e9 20 f2 ff ff       	jmp    801059d7 <alltraps>

801067b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $224
801067b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067be:	e9 14 f2 ff ff       	jmp    801059d7 <alltraps>

801067c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $225
801067c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067ca:	e9 08 f2 ff ff       	jmp    801059d7 <alltraps>

801067cf <vector226>:
.globl vector226
vector226:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $226
801067d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067d6:	e9 fc f1 ff ff       	jmp    801059d7 <alltraps>

801067db <vector227>:
.globl vector227
vector227:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $227
801067dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067e2:	e9 f0 f1 ff ff       	jmp    801059d7 <alltraps>

801067e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $228
801067e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067ee:	e9 e4 f1 ff ff       	jmp    801059d7 <alltraps>

801067f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $229
801067f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067fa:	e9 d8 f1 ff ff       	jmp    801059d7 <alltraps>

801067ff <vector230>:
.globl vector230
vector230:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $230
80106801:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106806:	e9 cc f1 ff ff       	jmp    801059d7 <alltraps>

8010680b <vector231>:
.globl vector231
vector231:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $231
8010680d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106812:	e9 c0 f1 ff ff       	jmp    801059d7 <alltraps>

80106817 <vector232>:
.globl vector232
vector232:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $232
80106819:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010681e:	e9 b4 f1 ff ff       	jmp    801059d7 <alltraps>

80106823 <vector233>:
.globl vector233
vector233:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $233
80106825:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010682a:	e9 a8 f1 ff ff       	jmp    801059d7 <alltraps>

8010682f <vector234>:
.globl vector234
vector234:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $234
80106831:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106836:	e9 9c f1 ff ff       	jmp    801059d7 <alltraps>

8010683b <vector235>:
.globl vector235
vector235:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $235
8010683d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106842:	e9 90 f1 ff ff       	jmp    801059d7 <alltraps>

80106847 <vector236>:
.globl vector236
vector236:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $236
80106849:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010684e:	e9 84 f1 ff ff       	jmp    801059d7 <alltraps>

80106853 <vector237>:
.globl vector237
vector237:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $237
80106855:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010685a:	e9 78 f1 ff ff       	jmp    801059d7 <alltraps>

8010685f <vector238>:
.globl vector238
vector238:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $238
80106861:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106866:	e9 6c f1 ff ff       	jmp    801059d7 <alltraps>

8010686b <vector239>:
.globl vector239
vector239:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $239
8010686d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106872:	e9 60 f1 ff ff       	jmp    801059d7 <alltraps>

80106877 <vector240>:
.globl vector240
vector240:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $240
80106879:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010687e:	e9 54 f1 ff ff       	jmp    801059d7 <alltraps>

80106883 <vector241>:
.globl vector241
vector241:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $241
80106885:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010688a:	e9 48 f1 ff ff       	jmp    801059d7 <alltraps>

8010688f <vector242>:
.globl vector242
vector242:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $242
80106891:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106896:	e9 3c f1 ff ff       	jmp    801059d7 <alltraps>

8010689b <vector243>:
.globl vector243
vector243:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $243
8010689d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068a2:	e9 30 f1 ff ff       	jmp    801059d7 <alltraps>

801068a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $244
801068a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068ae:	e9 24 f1 ff ff       	jmp    801059d7 <alltraps>

801068b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $245
801068b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068ba:	e9 18 f1 ff ff       	jmp    801059d7 <alltraps>

801068bf <vector246>:
.globl vector246
vector246:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $246
801068c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068c6:	e9 0c f1 ff ff       	jmp    801059d7 <alltraps>

801068cb <vector247>:
.globl vector247
vector247:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $247
801068cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068d2:	e9 00 f1 ff ff       	jmp    801059d7 <alltraps>

801068d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $248
801068d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068de:	e9 f4 f0 ff ff       	jmp    801059d7 <alltraps>

801068e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $249
801068e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068ea:	e9 e8 f0 ff ff       	jmp    801059d7 <alltraps>

801068ef <vector250>:
.globl vector250
vector250:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $250
801068f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068f6:	e9 dc f0 ff ff       	jmp    801059d7 <alltraps>

801068fb <vector251>:
.globl vector251
vector251:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $251
801068fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106902:	e9 d0 f0 ff ff       	jmp    801059d7 <alltraps>

80106907 <vector252>:
.globl vector252
vector252:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $252
80106909:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010690e:	e9 c4 f0 ff ff       	jmp    801059d7 <alltraps>

80106913 <vector253>:
.globl vector253
vector253:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $253
80106915:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010691a:	e9 b8 f0 ff ff       	jmp    801059d7 <alltraps>

8010691f <vector254>:
.globl vector254
vector254:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $254
80106921:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106926:	e9 ac f0 ff ff       	jmp    801059d7 <alltraps>

8010692b <vector255>:
.globl vector255
vector255:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $255
8010692d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106932:	e9 a0 f0 ff ff       	jmp    801059d7 <alltraps>
80106937:	66 90                	xchg   %ax,%ax
80106939:	66 90                	xchg   %ax,%ax
8010693b:	66 90                	xchg   %ax,%ax
8010693d:	66 90                	xchg   %ax,%ax
8010693f:	90                   	nop

80106940 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106946:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010694c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106952:	83 ec 1c             	sub    $0x1c,%esp
80106955:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106958:	39 d3                	cmp    %edx,%ebx
8010695a:	73 49                	jae    801069a5 <deallocuvm.part.0+0x65>
8010695c:	89 c7                	mov    %eax,%edi
8010695e:	eb 0c                	jmp    8010696c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106960:	83 c0 01             	add    $0x1,%eax
80106963:	c1 e0 16             	shl    $0x16,%eax
80106966:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106968:	39 da                	cmp    %ebx,%edx
8010696a:	76 39                	jbe    801069a5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010696c:	89 d8                	mov    %ebx,%eax
8010696e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106971:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106974:	f6 c1 01             	test   $0x1,%cl
80106977:	74 e7                	je     80106960 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106979:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010697b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106981:	c1 ee 0a             	shr    $0xa,%esi
80106984:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010698a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106991:	85 f6                	test   %esi,%esi
80106993:	74 cb                	je     80106960 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106995:	8b 06                	mov    (%esi),%eax
80106997:	a8 01                	test   $0x1,%al
80106999:	75 15                	jne    801069b0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010699b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069a1:	39 da                	cmp    %ebx,%edx
801069a3:	77 c7                	ja     8010696c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801069a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069ab:	5b                   	pop    %ebx
801069ac:	5e                   	pop    %esi
801069ad:	5f                   	pop    %edi
801069ae:	5d                   	pop    %ebp
801069af:	c3                   	ret    
      if(pa == 0)
801069b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069b5:	74 25                	je     801069dc <deallocuvm.part.0+0x9c>
      kfree(v);
801069b7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069ba:	05 00 00 00 80       	add    $0x80000000,%eax
801069bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801069c8:	50                   	push   %eax
801069c9:	e8 02 bb ff ff       	call   801024d0 <kfree>
      *pte = 0;
801069ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801069d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069d7:	83 c4 10             	add    $0x10,%esp
801069da:	eb 8c                	jmp    80106968 <deallocuvm.part.0+0x28>
        panic("kfree");
801069dc:	83 ec 0c             	sub    $0xc,%esp
801069df:	68 a6 75 10 80       	push   $0x801075a6
801069e4:	e8 97 99 ff ff       	call   80100380 <panic>
801069e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069f0 <mappages>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801069f6:	89 d3                	mov    %edx,%ebx
801069f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069fe:	83 ec 1c             	sub    $0x1c,%esp
80106a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a10:	8b 45 08             	mov    0x8(%ebp),%eax
80106a13:	29 d8                	sub    %ebx,%eax
80106a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a18:	eb 3d                	jmp    80106a57 <mappages+0x67>
80106a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a27:	c1 ea 0a             	shr    $0xa,%edx
80106a2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a37:	85 c0                	test   %eax,%eax
80106a39:	74 75                	je     80106ab0 <mappages+0xc0>
    if(*pte & PTE_P)
80106a3b:	f6 00 01             	testb  $0x1,(%eax)
80106a3e:	0f 85 86 00 00 00    	jne    80106aca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106a44:	0b 75 0c             	or     0xc(%ebp),%esi
80106a47:	83 ce 01             	or     $0x1,%esi
80106a4a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a4c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106a4f:	74 6f                	je     80106ac0 <mappages+0xd0>
    a += PGSIZE;
80106a51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106a5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a5d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106a60:	89 d8                	mov    %ebx,%eax
80106a62:	c1 e8 16             	shr    $0x16,%eax
80106a65:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106a68:	8b 07                	mov    (%edi),%eax
80106a6a:	a8 01                	test   $0x1,%al
80106a6c:	75 b2                	jne    80106a20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a6e:	e8 1d bc ff ff       	call   80102690 <kalloc>
80106a73:	85 c0                	test   %eax,%eax
80106a75:	74 39                	je     80106ab0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106a77:	83 ec 04             	sub    $0x4,%esp
80106a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106a7d:	68 00 10 00 00       	push   $0x1000
80106a82:	6a 00                	push   $0x0
80106a84:	50                   	push   %eax
80106a85:	e8 06 dd ff ff       	call   80104790 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106a8d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a90:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a96:	83 c8 07             	or     $0x7,%eax
80106a99:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a9b:	89 d8                	mov    %ebx,%eax
80106a9d:	c1 e8 0a             	shr    $0xa,%eax
80106aa0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106aa5:	01 d0                	add    %edx,%eax
80106aa7:	eb 92                	jmp    80106a3b <mappages+0x4b>
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab8:	5b                   	pop    %ebx
80106ab9:	5e                   	pop    %esi
80106aba:	5f                   	pop    %edi
80106abb:	5d                   	pop    %ebp
80106abc:	c3                   	ret    
80106abd:	8d 76 00             	lea    0x0(%esi),%esi
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ac3:	31 c0                	xor    %eax,%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
      panic("remap");
80106aca:	83 ec 0c             	sub    $0xc,%esp
80106acd:	68 74 7c 10 80       	push   $0x80107c74
80106ad2:	e8 a9 98 ff ff       	call   80100380 <panic>
80106ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ade:	66 90                	xchg   %ax,%ax

80106ae0 <seginit>:
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ae6:	e8 85 ce ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
80106aeb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106af0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106af6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106afa:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106b01:	ff 00 00 
80106b04:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106b0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b0e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106b15:	ff 00 00 
80106b18:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106b1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b22:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106b29:	ff 00 00 
80106b2c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106b33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b36:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106b3d:	ff 00 00 
80106b40:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106b47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b4a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106b4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b53:	c1 e8 10             	shr    $0x10,%eax
80106b56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b5d:	0f 01 10             	lgdtl  (%eax)
}
80106b60:	c9                   	leave  
80106b61:	c3                   	ret    
80106b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b70:	a1 c4 45 11 80       	mov    0x801145c4,%eax
80106b75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b7a:	0f 22 d8             	mov    %eax,%cr3
}
80106b7d:	c3                   	ret    
80106b7e:	66 90                	xchg   %ax,%ax

80106b80 <switchuvm>:
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 1c             	sub    $0x1c,%esp
80106b89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b8c:	85 f6                	test   %esi,%esi
80106b8e:	0f 84 cb 00 00 00    	je     80106c5f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b94:	8b 46 08             	mov    0x8(%esi),%eax
80106b97:	85 c0                	test   %eax,%eax
80106b99:	0f 84 da 00 00 00    	je     80106c79 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b9f:	8b 46 04             	mov    0x4(%esi),%eax
80106ba2:	85 c0                	test   %eax,%eax
80106ba4:	0f 84 c2 00 00 00    	je     80106c6c <switchuvm+0xec>
  pushcli();
80106baa:	e8 d1 d9 ff ff       	call   80104580 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106baf:	e8 5c cd ff ff       	call   80103910 <mycpu>
80106bb4:	89 c3                	mov    %eax,%ebx
80106bb6:	e8 55 cd ff ff       	call   80103910 <mycpu>
80106bbb:	89 c7                	mov    %eax,%edi
80106bbd:	e8 4e cd ff ff       	call   80103910 <mycpu>
80106bc2:	83 c7 08             	add    $0x8,%edi
80106bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bc8:	e8 43 cd ff ff       	call   80103910 <mycpu>
80106bcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bd0:	ba 67 00 00 00       	mov    $0x67,%edx
80106bd5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106bdc:	83 c0 08             	add    $0x8,%eax
80106bdf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106be6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106beb:	83 c1 08             	add    $0x8,%ecx
80106bee:	c1 e8 18             	shr    $0x18,%eax
80106bf1:	c1 e9 10             	shr    $0x10,%ecx
80106bf4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bfa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c00:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c05:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c11:	e8 fa cc ff ff       	call   80103910 <mycpu>
80106c16:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c1d:	e8 ee cc ff ff       	call   80103910 <mycpu>
80106c22:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c26:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c2f:	e8 dc cc ff ff       	call   80103910 <mycpu>
80106c34:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c37:	e8 d4 cc ff ff       	call   80103910 <mycpu>
80106c3c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c40:	b8 28 00 00 00       	mov    $0x28,%eax
80106c45:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c48:	8b 46 04             	mov    0x4(%esi),%eax
80106c4b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c50:	0f 22 d8             	mov    %eax,%cr3
}
80106c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c56:	5b                   	pop    %ebx
80106c57:	5e                   	pop    %esi
80106c58:	5f                   	pop    %edi
80106c59:	5d                   	pop    %ebp
  popcli();
80106c5a:	e9 71 d9 ff ff       	jmp    801045d0 <popcli>
    panic("switchuvm: no process");
80106c5f:	83 ec 0c             	sub    $0xc,%esp
80106c62:	68 7a 7c 10 80       	push   $0x80107c7a
80106c67:	e8 14 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	68 a5 7c 10 80       	push   $0x80107ca5
80106c74:	e8 07 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c79:	83 ec 0c             	sub    $0xc,%esp
80106c7c:	68 90 7c 10 80       	push   $0x80107c90
80106c81:	e8 fa 96 ff ff       	call   80100380 <panic>
80106c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi

80106c90 <inituvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c9c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c9f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ca5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106cab:	77 4b                	ja     80106cf8 <inituvm+0x68>
  mem = kalloc();
80106cad:	e8 de b9 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80106cb2:	83 ec 04             	sub    $0x4,%esp
80106cb5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106cba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cbc:	6a 00                	push   $0x0
80106cbe:	50                   	push   %eax
80106cbf:	e8 cc da ff ff       	call   80104790 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cc4:	58                   	pop    %eax
80106cc5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ccb:	5a                   	pop    %edx
80106ccc:	6a 06                	push   $0x6
80106cce:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cd3:	31 d2                	xor    %edx,%edx
80106cd5:	50                   	push   %eax
80106cd6:	89 f8                	mov    %edi,%eax
80106cd8:	e8 13 fd ff ff       	call   801069f0 <mappages>
  memmove(mem, init, sz);
80106cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce0:	89 75 10             	mov    %esi,0x10(%ebp)
80106ce3:	83 c4 10             	add    $0x10,%esp
80106ce6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ce9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cef:	5b                   	pop    %ebx
80106cf0:	5e                   	pop    %esi
80106cf1:	5f                   	pop    %edi
80106cf2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106cf3:	e9 38 db ff ff       	jmp    80104830 <memmove>
    panic("inituvm: more than a page");
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	68 b9 7c 10 80       	push   $0x80107cb9
80106d00:	e8 7b 96 ff ff       	call   80100380 <panic>
80106d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d10 <loaduvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d1c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106d1f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106d24:	0f 85 bb 00 00 00    	jne    80106de5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106d2a:	01 f0                	add    %esi,%eax
80106d2c:	89 f3                	mov    %esi,%ebx
80106d2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d31:	8b 45 14             	mov    0x14(%ebp),%eax
80106d34:	01 f0                	add    %esi,%eax
80106d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106d39:	85 f6                	test   %esi,%esi
80106d3b:	0f 84 87 00 00 00    	je     80106dc8 <loaduvm+0xb8>
80106d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106d4e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106d50:	89 c2                	mov    %eax,%edx
80106d52:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d55:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106d58:	f6 c2 01             	test   $0x1,%dl
80106d5b:	75 13                	jne    80106d70 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106d5d:	83 ec 0c             	sub    $0xc,%esp
80106d60:	68 d3 7c 10 80       	push   $0x80107cd3
80106d65:	e8 16 96 ff ff       	call   80100380 <panic>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d70:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d73:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106d79:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d7e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d85:	85 c0                	test   %eax,%eax
80106d87:	74 d4                	je     80106d5d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106d89:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106d8e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d98:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d9e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106da1:	29 d9                	sub    %ebx,%ecx
80106da3:	05 00 00 00 80       	add    $0x80000000,%eax
80106da8:	57                   	push   %edi
80106da9:	51                   	push   %ecx
80106daa:	50                   	push   %eax
80106dab:	ff 75 10             	push   0x10(%ebp)
80106dae:	e8 ed ac ff ff       	call   80101aa0 <readi>
80106db3:	83 c4 10             	add    $0x10,%esp
80106db6:	39 f8                	cmp    %edi,%eax
80106db8:	75 1e                	jne    80106dd8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106dba:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106dc0:	89 f0                	mov    %esi,%eax
80106dc2:	29 d8                	sub    %ebx,%eax
80106dc4:	39 c6                	cmp    %eax,%esi
80106dc6:	77 80                	ja     80106d48 <loaduvm+0x38>
}
80106dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dcb:	31 c0                	xor    %eax,%eax
}
80106dcd:	5b                   	pop    %ebx
80106dce:	5e                   	pop    %esi
80106dcf:	5f                   	pop    %edi
80106dd0:	5d                   	pop    %ebp
80106dd1:	c3                   	ret    
80106dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ddb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de0:	5b                   	pop    %ebx
80106de1:	5e                   	pop    %esi
80106de2:	5f                   	pop    %edi
80106de3:	5d                   	pop    %ebp
80106de4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106de5:	83 ec 0c             	sub    $0xc,%esp
80106de8:	68 74 7d 10 80       	push   $0x80107d74
80106ded:	e8 8e 95 ff ff       	call   80100380 <panic>
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e00 <allocuvm>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e09:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106e0c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106e0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e12:	85 c0                	test   %eax,%eax
80106e14:	0f 88 b6 00 00 00    	js     80106ed0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106e1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e20:	0f 82 9a 00 00 00    	jb     80106ec0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e26:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106e2c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106e32:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e35:	77 44                	ja     80106e7b <allocuvm+0x7b>
80106e37:	e9 87 00 00 00       	jmp    80106ec3 <allocuvm+0xc3>
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	68 00 10 00 00       	push   $0x1000
80106e48:	6a 00                	push   $0x0
80106e4a:	50                   	push   %eax
80106e4b:	e8 40 d9 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e50:	58                   	pop    %eax
80106e51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e57:	5a                   	pop    %edx
80106e58:	6a 06                	push   $0x6
80106e5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e5f:	89 f2                	mov    %esi,%edx
80106e61:	50                   	push   %eax
80106e62:	89 f8                	mov    %edi,%eax
80106e64:	e8 87 fb ff ff       	call   801069f0 <mappages>
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	85 c0                	test   %eax,%eax
80106e6e:	78 78                	js     80106ee8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106e70:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e76:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e79:	76 48                	jbe    80106ec3 <allocuvm+0xc3>
    mem = kalloc();
80106e7b:	e8 10 b8 ff ff       	call   80102690 <kalloc>
80106e80:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e82:	85 c0                	test   %eax,%eax
80106e84:	75 ba                	jne    80106e40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	68 f1 7c 10 80       	push   $0x80107cf1
80106e8e:	e8 0d 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e96:	83 c4 10             	add    $0x10,%esp
80106e99:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e9c:	74 32                	je     80106ed0 <allocuvm+0xd0>
80106e9e:	8b 55 10             	mov    0x10(%ebp),%edx
80106ea1:	89 c1                	mov    %eax,%ecx
80106ea3:	89 f8                	mov    %edi,%eax
80106ea5:	e8 96 fa ff ff       	call   80106940 <deallocuvm.part.0>
      return 0;
80106eaa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb7:	5b                   	pop    %ebx
80106eb8:	5e                   	pop    %esi
80106eb9:	5f                   	pop    %edi
80106eba:	5d                   	pop    %ebp
80106ebb:	c3                   	ret    
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec9:	5b                   	pop    %ebx
80106eca:	5e                   	pop    %esi
80106ecb:	5f                   	pop    %edi
80106ecc:	5d                   	pop    %ebp
80106ecd:	c3                   	ret    
80106ece:	66 90                	xchg   %ax,%ax
    return 0;
80106ed0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106edd:	5b                   	pop    %ebx
80106ede:	5e                   	pop    %esi
80106edf:	5f                   	pop    %edi
80106ee0:	5d                   	pop    %ebp
80106ee1:	c3                   	ret    
80106ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ee8:	83 ec 0c             	sub    $0xc,%esp
80106eeb:	68 09 7d 10 80       	push   $0x80107d09
80106ef0:	e8 ab 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ef8:	83 c4 10             	add    $0x10,%esp
80106efb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106efe:	74 0c                	je     80106f0c <allocuvm+0x10c>
80106f00:	8b 55 10             	mov    0x10(%ebp),%edx
80106f03:	89 c1                	mov    %eax,%ecx
80106f05:	89 f8                	mov    %edi,%eax
80106f07:	e8 34 fa ff ff       	call   80106940 <deallocuvm.part.0>
      kfree(mem);
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	53                   	push   %ebx
80106f10:	e8 bb b5 ff ff       	call   801024d0 <kfree>
      return 0;
80106f15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f1c:	83 c4 10             	add    $0x10,%esp
}
80106f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f25:	5b                   	pop    %ebx
80106f26:	5e                   	pop    %esi
80106f27:	5f                   	pop    %edi
80106f28:	5d                   	pop    %ebp
80106f29:	c3                   	ret    
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f30 <deallocuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f3c:	39 d1                	cmp    %edx,%ecx
80106f3e:	73 10                	jae    80106f50 <deallocuvm+0x20>
}
80106f40:	5d                   	pop    %ebp
80106f41:	e9 fa f9 ff ff       	jmp    80106940 <deallocuvm.part.0>
80106f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi
80106f50:	89 d0                	mov    %edx,%eax
80106f52:	5d                   	pop    %ebp
80106f53:	c3                   	ret    
80106f54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f5f:	90                   	nop

80106f60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f6c:	85 f6                	test   %esi,%esi
80106f6e:	74 59                	je     80106fc9 <freevm+0x69>
  if(newsz >= oldsz)
80106f70:	31 c9                	xor    %ecx,%ecx
80106f72:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f77:	89 f0                	mov    %esi,%eax
80106f79:	89 f3                	mov    %esi,%ebx
80106f7b:	e8 c0 f9 ff ff       	call   80106940 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f80:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f86:	eb 0f                	jmp    80106f97 <freevm+0x37>
80106f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8f:	90                   	nop
80106f90:	83 c3 04             	add    $0x4,%ebx
80106f93:	39 df                	cmp    %ebx,%edi
80106f95:	74 23                	je     80106fba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f97:	8b 03                	mov    (%ebx),%eax
80106f99:	a8 01                	test   $0x1,%al
80106f9b:	74 f3                	je     80106f90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106fa2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fa5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fa8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fad:	50                   	push   %eax
80106fae:	e8 1d b5 ff ff       	call   801024d0 <kfree>
80106fb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fb6:	39 df                	cmp    %ebx,%edi
80106fb8:	75 dd                	jne    80106f97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106fba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc0:	5b                   	pop    %ebx
80106fc1:	5e                   	pop    %esi
80106fc2:	5f                   	pop    %edi
80106fc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106fc4:	e9 07 b5 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80106fc9:	83 ec 0c             	sub    $0xc,%esp
80106fcc:	68 25 7d 10 80       	push   $0x80107d25
80106fd1:	e8 aa 93 ff ff       	call   80100380 <panic>
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi

80106fe0 <setupkvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	56                   	push   %esi
80106fe4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106fe5:	e8 a6 b6 ff ff       	call   80102690 <kalloc>
80106fea:	89 c6                	mov    %eax,%esi
80106fec:	85 c0                	test   %eax,%eax
80106fee:	74 42                	je     80107032 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ff3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ff8:	68 00 10 00 00       	push   $0x1000
80106ffd:	6a 00                	push   $0x0
80106fff:	50                   	push   %eax
80107000:	e8 8b d7 ff ff       	call   80104790 <memset>
80107005:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107008:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010700b:	83 ec 08             	sub    $0x8,%esp
8010700e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107011:	ff 73 0c             	push   0xc(%ebx)
80107014:	8b 13                	mov    (%ebx),%edx
80107016:	50                   	push   %eax
80107017:	29 c1                	sub    %eax,%ecx
80107019:	89 f0                	mov    %esi,%eax
8010701b:	e8 d0 f9 ff ff       	call   801069f0 <mappages>
80107020:	83 c4 10             	add    $0x10,%esp
80107023:	85 c0                	test   %eax,%eax
80107025:	78 19                	js     80107040 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107027:	83 c3 10             	add    $0x10,%ebx
8010702a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107030:	75 d6                	jne    80107008 <setupkvm+0x28>
}
80107032:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107035:	89 f0                	mov    %esi,%eax
80107037:	5b                   	pop    %ebx
80107038:	5e                   	pop    %esi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
8010703b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop
      freevm(pgdir);
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	56                   	push   %esi
      return 0;
80107044:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107046:	e8 15 ff ff ff       	call   80106f60 <freevm>
      return 0;
8010704b:	83 c4 10             	add    $0x10,%esp
}
8010704e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107051:	89 f0                	mov    %esi,%eax
80107053:	5b                   	pop    %ebx
80107054:	5e                   	pop    %esi
80107055:	5d                   	pop    %ebp
80107056:	c3                   	ret    
80107057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705e:	66 90                	xchg   %ax,%ax

80107060 <kvmalloc>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107066:	e8 75 ff ff ff       	call   80106fe0 <setupkvm>
8010706b:	a3 c4 45 11 80       	mov    %eax,0x801145c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107070:	05 00 00 00 80       	add    $0x80000000,%eax
80107075:	0f 22 d8             	mov    %eax,%cr3
}
80107078:	c9                   	leave  
80107079:	c3                   	ret    
8010707a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107080 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	83 ec 08             	sub    $0x8,%esp
80107086:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107089:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010708c:	89 c1                	mov    %eax,%ecx
8010708e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107091:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107094:	f6 c2 01             	test   $0x1,%dl
80107097:	75 17                	jne    801070b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107099:	83 ec 0c             	sub    $0xc,%esp
8010709c:	68 36 7d 10 80       	push   $0x80107d36
801070a1:	e8 da 92 ff ff       	call   80100380 <panic>
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801070c5:	85 c0                	test   %eax,%eax
801070c7:	74 d0                	je     80107099 <clearpteu+0x19>
  *pte &= ~PTE_U;
801070c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070cc:	c9                   	leave  
801070cd:	c3                   	ret    
801070ce:	66 90                	xchg   %ax,%ax

801070d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070d9:	e8 02 ff ff ff       	call   80106fe0 <setupkvm>
801070de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070e1:	85 c0                	test   %eax,%eax
801070e3:	0f 84 bd 00 00 00    	je     801071a6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070ec:	85 c9                	test   %ecx,%ecx
801070ee:	0f 84 b2 00 00 00    	je     801071a6 <copyuvm+0xd6>
801070f4:	31 f6                	xor    %esi,%esi
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107103:	89 f0                	mov    %esi,%eax
80107105:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107108:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010710b:	a8 01                	test   $0x1,%al
8010710d:	75 11                	jne    80107120 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010710f:	83 ec 0c             	sub    $0xc,%esp
80107112:	68 40 7d 10 80       	push   $0x80107d40
80107117:	e8 64 92 ff ff       	call   80100380 <panic>
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107120:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107127:	c1 ea 0a             	shr    $0xa,%edx
8010712a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107130:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107137:	85 c0                	test   %eax,%eax
80107139:	74 d4                	je     8010710f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010713b:	8b 00                	mov    (%eax),%eax
8010713d:	a8 01                	test   $0x1,%al
8010713f:	0f 84 9f 00 00 00    	je     801071e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107145:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107147:	25 ff 0f 00 00       	and    $0xfff,%eax
8010714c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010714f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107155:	e8 36 b5 ff ff       	call   80102690 <kalloc>
8010715a:	89 c3                	mov    %eax,%ebx
8010715c:	85 c0                	test   %eax,%eax
8010715e:	74 64                	je     801071c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
80107163:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107169:	68 00 10 00 00       	push   $0x1000
8010716e:	57                   	push   %edi
8010716f:	50                   	push   %eax
80107170:	e8 bb d6 ff ff       	call   80104830 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107175:	58                   	pop    %eax
80107176:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010717c:	5a                   	pop    %edx
8010717d:	ff 75 e4             	push   -0x1c(%ebp)
80107180:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107185:	89 f2                	mov    %esi,%edx
80107187:	50                   	push   %eax
80107188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718b:	e8 60 f8 ff ff       	call   801069f0 <mappages>
80107190:	83 c4 10             	add    $0x10,%esp
80107193:	85 c0                	test   %eax,%eax
80107195:	78 21                	js     801071b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107197:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010719d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801071a0:	0f 87 5a ff ff ff    	ja     80107100 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801071a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ac:	5b                   	pop    %ebx
801071ad:	5e                   	pop    %esi
801071ae:	5f                   	pop    %edi
801071af:	5d                   	pop    %ebp
801071b0:	c3                   	ret    
801071b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801071b8:	83 ec 0c             	sub    $0xc,%esp
801071bb:	53                   	push   %ebx
801071bc:	e8 0f b3 ff ff       	call   801024d0 <kfree>
      goto bad;
801071c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801071c4:	83 ec 0c             	sub    $0xc,%esp
801071c7:	ff 75 e0             	push   -0x20(%ebp)
801071ca:	e8 91 fd ff ff       	call   80106f60 <freevm>
  return 0;
801071cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801071d6:	83 c4 10             	add    $0x10,%esp
}
801071d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071df:	5b                   	pop    %ebx
801071e0:	5e                   	pop    %esi
801071e1:	5f                   	pop    %edi
801071e2:	5d                   	pop    %ebp
801071e3:	c3                   	ret    
      panic("copyuvm: page not present");
801071e4:	83 ec 0c             	sub    $0xc,%esp
801071e7:	68 5a 7d 10 80       	push   $0x80107d5a
801071ec:	e8 8f 91 ff ff       	call   80100380 <panic>
801071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop

80107200 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107206:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107209:	89 c1                	mov    %eax,%ecx
8010720b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010720e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107211:	f6 c2 01             	test   $0x1,%dl
80107214:	0f 84 00 01 00 00    	je     8010731a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010721a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010721d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107223:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107224:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107229:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107230:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107232:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107237:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010723a:	05 00 00 00 80       	add    $0x80000000,%eax
8010723f:	83 fa 05             	cmp    $0x5,%edx
80107242:	ba 00 00 00 00       	mov    $0x0,%edx
80107247:	0f 45 c2             	cmovne %edx,%eax
}
8010724a:	c3                   	ret    
8010724b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010724f:	90                   	nop

80107250 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	8b 75 14             	mov    0x14(%ebp),%esi
8010725c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010725f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107262:	85 f6                	test   %esi,%esi
80107264:	75 51                	jne    801072b7 <copyout+0x67>
80107266:	e9 a5 00 00 00       	jmp    80107310 <copyout+0xc0>
8010726b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010726f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107270:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107276:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010727c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107282:	74 75                	je     801072f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107284:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107286:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107289:	29 c3                	sub    %eax,%ebx
8010728b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107291:	39 f3                	cmp    %esi,%ebx
80107293:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107296:	29 f8                	sub    %edi,%eax
80107298:	83 ec 04             	sub    $0x4,%esp
8010729b:	01 c1                	add    %eax,%ecx
8010729d:	53                   	push   %ebx
8010729e:	52                   	push   %edx
8010729f:	51                   	push   %ecx
801072a0:	e8 8b d5 ff ff       	call   80104830 <memmove>
    len -= n;
    buf += n;
801072a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801072a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801072ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801072b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801072b3:	29 de                	sub    %ebx,%esi
801072b5:	74 59                	je     80107310 <copyout+0xc0>
  if(*pde & PTE_P){
801072b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801072ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801072bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801072be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801072c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801072c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801072ca:	f6 c1 01             	test   $0x1,%cl
801072cd:	0f 84 4e 00 00 00    	je     80107321 <copyout.cold>
  return &pgtab[PTX(va)];
801072d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801072db:	c1 eb 0c             	shr    $0xc,%ebx
801072de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801072e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801072eb:	89 d9                	mov    %ebx,%ecx
801072ed:	83 e1 05             	and    $0x5,%ecx
801072f0:	83 f9 05             	cmp    $0x5,%ecx
801072f3:	0f 84 77 ff ff ff    	je     80107270 <copyout+0x20>
  }
  return 0;
}
801072f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107301:	5b                   	pop    %ebx
80107302:	5e                   	pop    %esi
80107303:	5f                   	pop    %edi
80107304:	5d                   	pop    %ebp
80107305:	c3                   	ret    
80107306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107313:	31 c0                	xor    %eax,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    

8010731a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010731a:	a1 00 00 00 00       	mov    0x0,%eax
8010731f:	0f 0b                	ud2    

80107321 <copyout.cold>:
80107321:	a1 00 00 00 00       	mov    0x0,%eax
80107326:	0f 0b                	ud2    
