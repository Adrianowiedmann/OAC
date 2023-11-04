#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include <stdbool.h>
#include"globals.h"
#include"instructions.h"

int32_t mem[MEM_SIZE];
int32_t reg[32];
uint32_t pc;
uint32_t ri;
uint32_t sp;
uint32_t gp;
uint32_t opcode;	
uint32_t rs1;	
uint32_t rs2;			
uint32_t rd;					
uint32_t shamt;					
uint32_t funct3;					
uint32_t funct7;					
int32_t	imm12_i;
int32_t	imm12_s;
int32_t	imm13;
int32_t	imm20_u;
int32_t	imm21;

int finish = 0;

void start(){
    pc = 0;
    ri = 0x00000000;
    reg[SP] = 0x00003ffc;
    reg[GP] = 0x00001800;
}

// Ler arquivo
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

int32_t lbu(uint32_t address, int32_t kte){
    int pos = (address+kte)/4;
    uint8_t *byte = (uint8_t *)&mem[pos];
    byte += kte;
	return *byte;
}

int32_t lb(uint32_t address, int32_t kte){
    int pos = (address+kte)/4;
    int8_t *byte = (int8_t *)&mem[pos];
    byte += kte;
	return *byte;	
}

void sb(uint32_t address, int32_t kte, int8_t dado){
    int pos = (address+kte)/4;
    int8_t *byte = (int8_t *)&mem[pos];
    byte += kte;
    *byte = dado;
    byte = *byte;
}

void sw(uint32_t address, int32_t kte, int32_t dado){
    int pos = (address+kte)/4;
    mem[pos] = dado;
}

void fetch(){
    ri = lw(pc, 0);
    pc += 4;
}

void decode(){
    opcode = ri & 0x7F;
    rs1 = (ri >> 15) & 0x1F;
    rs2 = (ri >> 20) & 0x1F;
    rd = (ri >> 7) & 0x1F;
    shamt = (ri >> 20) & 0x1F;
    funct3 = (ri >> 12) & 0x7;
    funct7 = (ri >> 25) & 0x7F;
    geraImm();
}

void geraImm(){
    int32_t imm10_5;
    int32_t imm4_1;
    int32_t imm10_1;
    int32_t imm12;
    int32_t imm11;
    int32_t imm12_11, value;
    int32_t imm19_12;
    int32_t imm20;
    switch(opcode){
        case JALR:
        case ILType:
        case ILAType:
        case ECALL:
            imm12_i = (ri >> 20) & 0xFFF;
            if (sign()){                        //Caso seja negativo, expande
                imm12_i = imm12_i | 0xFFFFF000;
            }
            break;

        case BType:
            imm10_5 = (ri & 0x7E000000) >> 13;  // bits 10:5 e shift até 4:1
            imm4_1 = (ri & 0xF00);              // bits 4:1
            imm10_1 = imm10_5 | imm4_1;         // OR para juntar 10:5 e 4:1
            imm12 = (ri &  0x80000000) >> 12;   // bit 12 e posiciona 12 bits à direita
            imm11 = (ri & 0x80) << 11;          // bit 11 e posiciona 11 bits à esquerda
            imm12_11 = imm12 | imm11;           // OR para juntar bit 12 e 11
            imm13 = (imm10_1 | imm12_11) >> 7;  // OR para juntar todos os bits, mantendo bit 0 como 0
            if (sign()){
                imm13 = imm13 | 0xFFFFE000;
            }
            break;

        case JAL:
            imm10_1 = (ri & 0x7FE00000) >> 20;  // bits 10:1 e desloca 19 bits mantendo bit 0 como 0 
            imm11 = (ri & 0x100000) >> 9;       // bit 11 e desloca 11 bits
            imm19_12 = (ri & 0xFF000);          // bits 19:12
            imm20 = (ri & 0x80000000) >> 11;    // bit 20 e desloca 11 bits
            imm21 = imm20 | imm19_12 | imm11 | imm10_1;
            if (sign()){
                imm21 = imm21 | 0xFFE00000;
            }
            break;

        case AUIPC:
        case LUI:
            imm20_u = (ri & 0xFFFFF000) >> 12;
            if (sign()){
                imm20_u = imm20_u | 0xFFF00000;
            }
            break;

        case StoreType:
            imm12_s = ((ri & 0xFE000000) >> 20) | ((ri & 0xF80) >> 7);
            if (sign()){
                imm12_s = imm12_s | 0xFFFFF000;
            }
            break;
    }

}

void execute(){

    reg[0] = 0;

    char *letter;           // Ponteiro para imprimir strings quando utilizado ECALL

    switch(opcode){

        case LUI:
            reg[rd] = imm20_u << 12;
            break;

        case AUIPC:
            reg[rd] = (pc-4) + (imm20_u << 12);
            break;

        case JAL:
            reg[rd] = (pc-4) + 4;
            pc = pc-4 + imm21;
            break;

        case JALR:
            pc = (reg[rs1]+imm12_i)&~1;
            reg[rd] = pc+4;
            break;

        case BType:
            switch(funct3){
            case BEQ3:
                if (reg[rs1] == reg[rs2]) pc += imm13-4;
                break;
            case BGE3:
                if (reg[rs1] >= reg[rs2]) pc += imm13-4;
                break;
            case BGEU3:
                if (((uint32_t)reg[rs1]) >= ((uint32_t)reg[rs2])) pc += imm13-4;
                break;
            case BLT3:
                if (reg[rs1] < reg[rs2]) pc += imm13-4;
                break;
            case BLTU3:
                if (((uint32_t)reg[rs1]) < ((uint32_t)reg[rs2])) pc += imm13-4;
                break;
            case BNE3:
                if (reg[rs1] != reg[rs2]) pc += imm13-4;
                break;
            default:
                break;
            }
            break;

        case ILType:
            switch (funct3){
            case LB3:
                reg[rd] = lb(reg[rs1], imm12_i);
                break;
            case LBU3:
                reg[rd] = lbu(reg[rs1], imm12_i);
                break;
            case LW3:
                reg[rd] = lw(reg[rs1], imm12_i);
                break;
            default:
                break;
            }
            break;

        case ILAType:
            switch (funct3){
            case ADDI3:
                reg[rd] = reg[rs1] + imm12_i;
                break;
            case ORI3:
                reg[rd] = reg[rs1] | imm12_i;
                break;
            case ANDI3:
                reg[rd] = reg[rs1] & imm12_i;
                break;
            case SLLI3:
                reg[rd] = reg[rs1] << shamt;
                break;
            case SRI3:
                switch (funct7){
                case SRLI7:
                    reg[rd] = (uint32_t)reg[rs1] >> shamt;
                    break;
                case SRAI7:
                    reg[rd] = (int32_t)reg[rs1] >> shamt;
                    break;
                default:
                    break;
                }
                break;
            default:
                break;
            }
            break;

        case RegType:
            switch (funct3){
            case ADDSUB3:
                switch (funct7){
                case ADD7:
                    reg[rd] = reg[rs1] + reg[rs2];
                    break;
                case SUB7:
                    reg[rd] = reg[rs1] - reg[rs2];
                    break;
                default:
                    break;
                }
                break;
            case SLT3:
                if (reg[rs1] < reg[rs2]){
                    reg[rd] = 1;
                }
                else{
                    reg[rd] = 0;
                }
                break;
            case SLTU3:
                if (((uint32_t)reg[rs1]) < ((uint32_t)reg[rs2])){
                    reg[rd] = 1;
                }
                else{
                    reg[rd] = 0;
                }
                break;
            case XOR3:
                reg[rd] = reg[rs1] ^ reg[rs2];
                break;
            case OR3:
                reg[rd] = reg[rs1] | reg[rs2];
                break;
            case AND3:
                reg[rd] = reg[rs1] & reg[rs2];
                break;
            default:
                break;
            }
            break;
        case StoreType:
            switch (funct3){
            case SB3:
                sb(reg[rs1], imm12_s, reg[rs2]);
                break;
            case SW3:
                sw(reg[rs1], imm12_s, reg[rs2]);
                break;
            default:
                break;
            }
            break;
        case ECALL:
            switch (reg[A7])
            {
            case 1:
                printf("%d", reg[A0]);
                break;
            case 4:     // loop para imprimir mais de um caractere
                letter = (char *)mem+reg[10];
                    while (*letter != '\0'){
                        printf("%c", *letter);
                        letter += 1;
                    }
                break;
            case 10:        // finaliza programa
                printf("\nprogram is finished running (0)\n");
                exit(0);
                break;
            default:
                break;
            }
            break;
        default:
            break;   
    }
}

// funcao para verificar se é negativo ou nao
bool sign(){
    if ((ri & 0x80000000) == 0x80000000){
        return true;
    }
    return false;
}

void step(){
    fetch();
    decode();
    execute();
}

void run(){
    while(pc <= MEM_SIZE){
        step();
    }
    return 0;
}