#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"instructions.c"

int main() {
    start();
    load_mem("code.bin", 0);
    load_mem("data.bin", 0x2000);
    run();
    return 0;
}
