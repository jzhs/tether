

SECTIONS
{
    . = 0x00000;
    .init : { *(.init)}
    .text : { *(.text)}
    .data : { *(.data)}   
}

