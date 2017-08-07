@echo off

:: Build Stage 1
nasm -f bin -o install/stage1.bin boot/Stage1/stage1.asm

:: Build Stage 2
nasm -f bin -o install/stage2.bin boot/Stage2/stage2.asm

:: Build Kernel
cd kernel
make
cd ..
xcopy /y kernel\krnl32.sys install\install\sys\krnl32.sys

:: Build the File
tool\MochaFSTool\MochaFSTool\bin\debug\MochaFSTool.exe buildimg.txt

:: run the system
qemu-system-i386 disk.img -m 32
