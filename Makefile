ARCH=riscv64-unknown-elf-
AS=$(ARCH)as
OBJCOPY=$(ARCH)objcopy
hex: example_code.asm
	$(AS) $^ -o example_code.out
	$(OBJCOPY) -O ihex example_code.out example_code.hex

