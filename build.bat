@echo off

:: Build Stage 1
nasm -f bin -o install/stage1.bin boot/Stage1/stage1.asm

:: Build Stage 2
nasm -f bin -o install/stage2.bin boot/Stage2/stage2.asm

:: Build the File
tool\MochaFSTool\MochaFSTool\bin\debug\MochaFSTool.exe install

:: run the system
qemu-system-i386 disk.img
