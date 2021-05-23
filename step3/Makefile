TARGET = encode.bin

.PHONY: all clean dump

all: $(TARGET)

clean:
	$(RM) $(TARGET)

dump: $(TARGET)
	hexdump -C $<

$(TARGET): encode.asm
	nasm $< -f bin -o $@
