MEMORY
{
   BRAM (RWX) : ORIGIN = 0x00000000, LENGTH = 0x00001FFF
}
SECTIONS
{
    everything :
    {
	. = ALIGN(4);
	code.o (.text)
        *(.*)
    } >BRAM
}
/* https://zipcpu.com/zipcpu/2018/12/22/autofpga-ld.html */
/* https://stackoverflow.com/questions/77892754/linker-script-for-riscv-cpu-on-fpga-stack-is-not-where-i-expect-it-to-be */