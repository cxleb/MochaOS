OUTPUT_FORMAT(binary)

ENTRY(Entry)
STARTUP(kernel/bin/kernel.o)

SECTIONS
{
	. = 1M;
	.text :
	{
		*(.text)
	}

	.rodata ALIGN (4K) : {
		*(.rodata)
	}

	.data ALIGN (4K) :
	{
		*(.data)
	}

	.bss :
	{
		*(.bss)
	}
}
