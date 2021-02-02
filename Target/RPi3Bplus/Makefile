
TFTPDIR = ~/tftpboot
TOOLSDIR = ~/aarch64-elf-bin

PREFIX = $(TOOLSDIR)/aarch64-elf-

AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump


sources = *.S
objects = interp.o uart.o

%.o: %.S
	$(AS) -a -o $@ $< > $*.lis


%.bin : $(objects)
	$(LD) --print-map -T link.ld -o $(subst .bin,.elf,$@) $^  > $*.map
	$(OBJCOPY) -O binary $(subst .bin,.elf,$@) $@
	$(OBJDUMP) -D $(subst .bin,.elf,$@) > $*.dmp


# Default target. First cleanup from last make, the build program, then copy for tftp transfer
all: clean kernel8.bin cpy2tftp

cpy2tftp:
	cp kernel8.bin $(TFTPDIR)/kernel8.img


# The >/dev/null 2>/dev/null || true prevents error messages if files don't exist
clean:
	rm *.elf *.bin *.lis *.o >/dev/null 2>/dev/null || true
