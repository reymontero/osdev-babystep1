TARGET = boot.bin

.PHONY: all clean run

all: $(TARGET)

clean:
	$(RM) $(TARGET)

run: $(TARGET)
	qemu-system-i386 -fda $<

$(TARGET): boot.asm
	nasm $< -f bin -o $@
