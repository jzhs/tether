# tether (WIP, don't expect much)

I'll try to demonstrate an alternative to bootloaders which may be
useful to some baremetal projects. 

On the target you install a "kernel" that just sits and waits for
commands from the host. In the basic version there are three
commands. Load, Store, Call.

On the host you use a scripting language (Python, Lisp, Forth, Perl,
etc) to send these commands to the target.

For example, in Python you write things like:
> >> tether.Load("00080007")
> 91
and you get the hex value stored in that byte.

> >> tether.Store("00800007", "17")

> >> tether.Load("00080007")

17

Using these you may be able to blink leds. Using a loop you can likely
transfer binary files to the target and dump memory from the target.

Using Call you should be able to invoke the procedures in the file you
transfered.

This is, of course, not a new idea. See the article "A 3-INSTRUCTION
FORTH FOR EMBEDDED SYSTEMS WORK" by Frank Sergeant. While that article
is Forth-centric the ideas apply to any reasonable scripting language
on your host.

Today there is just one target: Raspberry Pi 3B+ running in 64-bit
mode. I have a Rpi 4 and a Beaglebone so I may do those next.

As far as host scripting languages: I have tried Racket (a kind of
Lisp) and that works well. Python works but I don't know Python so
we'll see. I have not tried Perl. I tried Bash but that is a problem.
Probably it can be made to work. But it seems bad to create a process
and launch a program everytime you want to move a byte.

So ... anyone who knows a scripting language and wants to write three
functions, feel free to chime in.
