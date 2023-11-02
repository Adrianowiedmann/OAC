#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"instructions.c"

int main() {

    startMemory();
    startRegister();
    start();
    load_mem("code.bin", 0);
    load_mem("data.bin", 0x2000);
    //fetch();
    return 0;
}
