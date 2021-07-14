all:
	mkdir out || true
	nasm boot.asm -o out/boot.bin
	nasm main.asm -o out/main.bin
	dd if=/dev/zero of=total.bin bs=512 count=2880
	dd if=out/boot.bin of=total.bin conv=notrunc
	dd if=out/main.bin of=total.bin bs=512 seek=1 conv=notrunc
	qemu-system-x86_64 total.bin
