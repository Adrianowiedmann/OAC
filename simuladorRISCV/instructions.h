#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>

void start();

void startMemory();

void startRegister();

int load_mem(const char *binaryFile, int start);

int32_t lb(uint32_t address, int32_t kte);

int32_t lw(uint32_t address, int32_t kte); 

int32_t lbu(uint32_t address, int32_t kte);

void sb(uint32_t address, int32_t kte, int8_t dado);

void sw(uint32_t address, int32_t kte, int32_t dado);

void fetch();