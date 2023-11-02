#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"globals.h"
#include"instructions.h"

int32_t mem[MEM_SIZE];
int32_t reg[32];
uint32_t pc;
uint32_t ri;

void start(){
    pc = 0;
    ri = 0x00000000;
    reg[SP] = 0x00003ffc;
    reg[GP] = 0x00001800;
}

void startMemory(){
    for (int i = 0; i < MEM_SIZE; i++){
        mem[i]=0;
    }
}

void startRegister(){
    for (int i = 0; i < MEM_SIZE; i++){
        mem[i]=0;
    }
}

int load_mem(const char *binaryFile, int start){
    FILE *arquivo;
    int *buffer = mem + (start >> 2);

    //Abrir o arquivo binario para leitura
    arquivo = fopen(binaryFile, "rb");

    if (arquivo == NULL) {
        perror("Erro ao abrir o arquivo");  // Trata erros na abertura do arquivo
        return 1;
    }
    else{
        while (!feof(arquivo)) {
            fread(buffer, 4, 1, arquivo);
            buffer++;
            size++;
        }
    }
    
    fclose(arquivo);

    return 0;

}

int32_t lw(uint32_t address, int32_t kte){
    int pos = (address+kte)/4;
    int32_t word = mem[pos];
    return word;
}

/*
int32_t lbu(uint32_t address, int32_t kte){
    return 0;
}

int32_t lb(uint32_t address, int32_t kte){
	int8_t *byte = (int8_t *)&mem[address];
	byte += kte;
    return *byte;
}

void sb(uint32_t address, int32_t kte, int8_t dado){

}

void sw(uint32_t address, int32_t kte, int32_t dado){

}*/

void fetch(){
    ri = lw(pc, 0);
    pc += 4;
}