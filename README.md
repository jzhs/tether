# tether (WIP, don't expect much)

I'll try to demonstrate an alternative to bootloaders which may be
useful to some baremetal projects.

On the target (say a Raspberry Pi) you install a tiny interpeter that
just sits and listens to a serial port for commands to execute. In the
basic version there are only three commands: Load-byte, Store-byte,
and Call.

On the host you use a scripting language (Python, Lisp, Forth, Perl,
etc) to send these commands to the target. I have host examples
written in Python and in Racket.

For example, in Python you might write write:

    >> import tether
    >> tether.Load-byte(0x80007)
    0x91

and you get the value stored in that byte. Then you can change that byte

    >> tether.Store-byte(0x80007, 17)
    >> tether.Load-byte(0x80007)
    17

Naturally you won't be using these byte-by-byte commands very often.
Instead you'll write host procedures that send sequences of these
commands to the target.

# Examples of what you can do.

`Dump-mem` - a host procedure that displays target memory. It sends many
load-byte commands to the target to get the data onto the host where
it can be processed easily. 

`Load-file` - a host procedure that copies a file to the target by sending
a store-byte for each byte of the file. 

In both example the point is that almost all the logic lives on the
host. The target doesn't know anything about, say, object file
formats. Load-file might know alot about object files but it just
tells the target "put this byte here, that byte there."

This is, of course, not a new idea. See the article "A 3-INSTRUCTION
FORTH FOR EMBEDDED SYSTEMS WORK" by Frank Sergeant. Also see "A Z8
TALKER AND HOST" by Brad Rodriguez. In The Computer Journal, Issue 51,
July/August 1991. While those articles are a bit Forth-centric,
the ideas apply to any reasonable scripting language on your host.


# Next up ...

This little program doesn't do everything you'd like:

1. It doesn't handle exceptions. Every time do something wrong you
have to reboot the target.

2. Surely we can automate labeling addresses to Call more friendly.

3. Today I have just one target: Raspberry Pi 3B+ running in 64-bit
mode. I have an Arduino UNO, an RPi 4 and a Beaglebone and a few
others so I may do those next.


In the next project, 'monitor', I will add some useful extensions.