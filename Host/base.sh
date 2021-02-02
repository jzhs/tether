
stty --file=/dev/ttyUSB1 115200 raw -echo cs8 cread clocal

Fetch(){
    printf '\x01' > /dev/ttyUSB1
    printf $1 > /dev/ttyUSB1
    dd ibs=1 count=1 if=/dev/ttyUSB1 2>/dev/null | xxd -p
}

Store(){
    printf '\x02' > /dev/ttyUSB1
    printf $1 > /dev/ttyUSB1
    printf $2 > /dev/ttyUSB1
}

Call(){
    printf '\x03' > /dev/ttyUSB1
    printf $1 > /dev/ttyUSB1
}

