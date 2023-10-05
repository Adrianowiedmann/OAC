.data

#vetores de 2 bytes
blk_in:
  .half 0	#Primeiro elemento (16 bits)
  .half 1	#Segundo elemento (16 bits)
  .half 2	#Terceiro elemento (16 bits) 
  .half 3	#Quarto elemento (16 bits)
  
blk_out:
  .half 0
  .half 0
  .half 0
  .half 0
  
keys:
  .half 1
  .half 2
  .half 3
  .half 4
  .half 5
  .half 6
 
array_length: .half 4    
    
.text

#main do programa
main:
    # Pula para função ideia_round
    jal ra, ideia_round
    
    # Carrega o endereço do vetor em a1
    la a1, blk_out
    
    lh a5, array_length
    
    # loop para imprimir os valores do vetor blk_out
    loop:
    # número inteiro a imprimir em a0
    lh a0, 0(a1)

    # Limpe o bit de sinal, se necessário
    li a4, 0xffff
    and a0, a0, a4
    
    # Chamada de sistema para imprimir o número inteiro
    li a7, 1
    ecall
    
    # Imprimir uma quebra de linha
    li a0, '\n'
    li a7, 11
    ecall
    
    # Avança para o próximo elemento do vetor
    addi a1, a1, 2
    
    # Verifica se já imprimiu todos os elementos do vetor
    addi a5, a5, -1
    bnez a5, loop

    # Encerrar o programa
    li a7, 10
    ecall
    
#função ideia_round    
ideia_round:
    #Carrega os endereços dos vetores
    la a0, blk_in
    la a5, keys
    la a6, blk_out
    
    #Carrega os valores do vetor blk_in (blk_in_ptr)
    lhu t1, 0(a0)	#word1
    lhu t2, 2(a0)	#word2
    lhu t3, 4(a0)	#word3
    lhu t4, 6(a0)	#word4
    
    #Carrega os valores do vetor keys (key_ptr)
    lhu s1, 0(a5)
    lhu s2, 2(a5)
    lhu s3, 4(a5)
    lhu s4, 6(a5)
    lhu s5, 8(a5)
    lhu s6, 10(a5)

    #Salvar o endereço de retorno para main na pilha
    addi sp, sp, -4 	#Subtrair 4 da pilha
    sw ra, 0(sp)	#Salvar o valor atual de RA na pilha

    #Pula para função func_mul
    mv a1, t1
    mv a2, s1
    jal ra, func_mul
    mv t1, a1
    
    #LSW16(word2 + *key_ptr++); 
    add a1, t2, s2
    jal ra, lsw16
    mv t2, a1
    
    #LSW16(word3 + *key_ptr++); 
    add a1, t3, s3
    jal ra, lsw16
    mv t3, a1
    
    #Pula para função func_mul
    mv a1, t4
    mv a2, s4
    jal ra, func_mul
    mv t4, a1    
    
    xor t5, t1, t3	#t2 = word1 ^ word3;  (t5 = t2)
    mv a1, t5
    mv a2, s5
    jal ra, func_mul
    mv t5, a1 
    
    #t1 = LSW16(t2 + (word2 ^ word4)); t2 = t5 e t6 = t1
    xor a1, t2, t4
    add a1, t5, a1 
    jal ra, lsw16
    mv t6, a1
    
    #Pula para função func_mul
    mv a1, t6
    mv a2, s6
    jal ra, func_mul
    mv t6, a1
    
    #LSW16(t1 + t2);
    add a1, t6, t5
    jal ra, lsw16
    mv t5, a1
    
    xor t1, t1, t6
    xor t4, t4, t5
    
    xor t5, t5, t2
    xor t2, t3, t6
    mv t3, t5
    
    #store no vetor blk_out
    sh t1, 0(a6)
    sh t2, 2(a6)
    sh t3, 4(a6)
    sh t4, 6(a6)
    
    #Recuperar endereço de retorno da pilha e retorna função
    lw ra, 0(sp)        
    addi sp, sp, 4
    ret
    
func_mul:      
    #p = a3; x = a1; y = a2
    #p = x*y
    mul a3, a1, a2
    
    #se a3 diferente de zero, vai para else
    bne a3, x0, else
    #if (p == 0)
    if:
    	#x = 65537-x-y;
    	li a4, 65537
    	sub a4, a4, a1	#65537-x
    	sub a1, a4, a2	#(65537-x)-y
    	
    	#verifica se a1 é maior que 65535(maior valor para 16 bits)
    	li a4, 65535
    	bltu a4, a1, shiftleft16
    	 
    	ret
    else:
    	li a4, 16	#x = p >> 16;
    	srl a1, a3, a4	#operação de deslocamento à direita (right shift)
    	mv a2, a3
    	sub a1, a2, a1
    	
    	# se x < y (a2 < a1) vai para função increment
    	bltu a2, a1, increment
    	
    	ret

# x += 65537;
increment:
    li a4, 65537
    add a1, a1, a4

#Função que desloca 16 bits para esquerda
shiftleft16:
    li a4, 16		#Quantidade de bits a serem deslocados (16 bits)
    sll a1, a1, a4
    ret

#operação de máscaramento       
lsw16:
    li a2, 0x0000ffff
    and a1, a1, a2
    ret
