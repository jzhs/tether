

SECTIONS
{
    . = 0x80000;
    .init : { *(.init)}
    .text : { *(.text)}
    .data : { *(.data)}   
}

