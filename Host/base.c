#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>



void main(){
  
  system("stty --file=/dev/ttyUSB1 115200 raw -echo cs8 cread clocal");

  int dev = open("/dev/ttyUSB1", O_RDWR);
  
  char cmd[] = {0x01, 0x00, 0x08, 0x00, 0x07};
  //char* cmd = "\1\0\10\0\7";
  write(dev, cmd, 5);

  char resp[] = {0x00};
  read(dev, resp, 1);
  
  printf("0x%X\n", resp[0] & 0xff);

  close(dev);
  
  
}
