
TFTPDIR = ~/tftpboot
TOOLSDIR = ~/aarch64-elf-bin

PREFIX = $(TOOLSDIR)/aarch64-elf-

AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump


#sources = *.S
#objects = 

%.o: %.S
	$(AS) -a -o $@ $< > $*.lis

%.bin: %.o
	$(LD) --print-map -T link.ld --just-symbols ../Target/RPi3Bplus/kernel8.elf -o $(subst .bin,.elf,$@) $^  > $*.map
	$(OBJCOPY) -O binary $(subst .bin,.elf,$@) $@

%.dmp: %.elf
	$(OBJDUMP) -D $(subst .dmp,.elf,$@) > $@

%.sym: %.dmp
	$(OBJDUMP) --syms $(subst .sym,.elf,$@) | grep ' g ' | grep 'text' |  awk '{ print  $$5,  $$1 }' > $*.sym


# Default target. First cleanup from last make, the build program, then copy for tftp transfer
all: stuff.bin stuff.dmp stuff.sym


# The '>/dev/null 2>/dev/null || true' prevents error messages if files don't exist
clean:
	rm *.elf *.bin *.lis *.o *.dmp *.sym >/dev/null 2>/dev/null || true
