# tether (WIP, don't expect much)

I'll try to demonstrate an alternative to bootloaders which may be
useful to some baremetal projects.

On the target (say a Raspberry Pi) you install a tiny interpeter that
just sits and listens to a serial port for commands to execute. In the
basic version there are only three commands: Load-byte, Store-byte,
and Call.

On the host you use a scripting language (Python, Lisp, Forth, Perl,
etc) to send these commands to the target. 

For example, in Python you might write write:
> >> import tether
> >> tether.Load-byte(0x80007)
> 0x91

and you get the value stored in that byte. Then you can change that byte

> >> tether.Store-byte(0x800007, 17)
> >> tether.Load-byte(0x80007)
> 17

Naturally you won't be using these byte-by-byte commands very often.
Instead you'll write host programs that send these commands to the target.

This is, of course, not a new idea. See the article "A 3-INSTRUCTION
FORTH FOR EMBEDDED SYSTEMS WORK" by Frank Sergeant. Also see "A Z8
TALKER AND HOST" by Brad Rodriguez. In The Computer Journal, Issue 51,
July/August 1991. While those articles are a bit Forth-centric,
the ideas apply to any reasonable scripting language on your host.


The point is that these programs reside on the host. The loader might
send thousands of Store-byte commands to the target. 


Today I have just one target: Raspberry Pi 3B+ running in 64-bit
mode. I have an Arduino UNO, an RPi 4 and a Beaglebone and a few
others so I may do those next.

As far as host scripting languages: I have tried Racket (a kind of
Lisp) and that works well. Python works but I don't know Python so
we'll see. I have not tried Perl. I tried Bash but that is a problem.
Probably it can be made to work. But it seems bad to create a process
and launch a program everytime you want to move a byte.

So ... anyone who knows a scripting language and wants to write three
functions, feel free to chime in.


Using them you may be able to blink a memory-mapped led. Then