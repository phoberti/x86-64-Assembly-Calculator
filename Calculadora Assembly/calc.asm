;nasm -f elf64 calc.asm
;gcc -m64 -no-pie calc.o -o calc.x  
;./calc.x

;Chamada das funções externas do 'C' para o assembly
;'extern' indica que as funções são definidas em outros módulos ou bibliotecas e 
;serão vinculadas durante o processo de ligação do programa final.
extern printf  ;escrita stdout
extern scanf   ;leitura stdin
extern fopen   ;abertura e/ou criacao de arquivo
extern fclose  ;fechamento do arquivo
extern fprintf ;escrita no arquivo

;Definições básicas do algoritmo
;Dados estáticos utilizados no programa.
;Estrutura necessária para a lógica de entrada 
;e saída do programa e para a interação com arquivos.
section .data

	;Definições das entradas no programa, sendo o scanf() e seus
	;printf() para caso o arquivo funcione e se caso não funcione
	
	;Define uma string "Equação: " que será impressa na tela como uma solicitação de entrada do usuário. 
	;A diretiva db é usada para definir uma sequência de bytes, 
	;e o 0 no final da string indica o caractere nulo de terminação.
	entrada_print     : db "Equação: ", 0

	;Define uma constante usando a diretiva equ, que representa o tamanho da string 
	;calculado subtraindo o endereço inicial da string ($) pelo endereço final.
	entrada_print_l   : equ $ - entrada_print

	;Define uma string de formato para a função scanf. 
    entradas  	  	  : db "%f %c %f", 0								 
    
	;Definem duas strings de formato para a função fprintf.
	saida_good    	  : db "%.2f %c %.2f = %.2f", 10, 0			
	saida_bad     	  : db "%.2f %c %.2f = funcionalidade não disponivel", 10, 0
	
	;Definições de arquivos: nome do arquivo e sua permissão.
	;Caso o arquivo não exista, ele fará a criação e escrevera no final dele.
	;a+ -> gravação e leitura
	nome_arquivo      : db "resultados.txt", 0
	permissao_escrita : db "a+", 0	
	
	;Auxiliares usados no programa
	aux_0 : dq 1
	aux_1 : db 0
	
;Variáveis não inicializadas
section .bss
	;Indentificador de arquivo para o programa.
	;Verificar se o arquivo foi aberto com sucesso e para fechá-lo adequadamente.
	;Passar o identificador do arquivo para as funções de manipulação de arquivo.
	indentifica_arquivo : resq 10

;Código principal do programa é definido.
section .text
	;Inicio do programa global()
    global main
;Funções básicas do programa:
;Função de soma de dois valores em float, dado pela entrada 'a'
funcao_soma:
	;Configuram o frame da pilha para a função funcao_soma. 
	;O ponteiro de base do registro (rbp) é salvo na pilha, 
	;e o rbp é movido para o topo da pilha. 
	;Isso estabelece um novo frame da pilha para a função.
	push rbp
	mov rbp, rsp

	;Movendo em single scaler os floats para operação
	;A instrução movss é usada para mover um valor de ponto flutuante 
	;de precisão simples (32 bits) de um registrador xmm para a memória.
	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	;Move o valor do primeiro operando da memória (no endereço [rbp-4]) 
	;de volta para o registrador xmm0. 
	;Isso é feito para carregar o valor em um registrador xmm 
	;antes de realizar a operação de adição.
	movss xmm0, DWORD [rbp-4]

	;Operação de adição dos floats
	addss xmm0, DWORD [rbp-8]

	;Movem o resultado da operação de adição de volta para a memória, 
	;o endereço [rbp-4], e em seguida, de volta para o registrador xmm0. 
	;Isso é feito para garantir que o resultado esteja na memória 
	;para ser usado posteriormente e que seja carregado em xmm0 para retornar o valor correto da função.
	movss DWORD [rbp-4], xmm0
	movss xmm0, DWORD  [rbp-4]

	;Restauram o ponteiro de base do registro (rbp) a partir da pilha 
	;e retornam para o ponto de retorno da função com ret. 
	;Isso encerra a execução da função e retorna ao ponto de chamada.
	pop rbp
	;Realiza a operação de soma de dois valores 
	;em ponto flutuante de precisão simples e retorna o resultado.
	;Usa registradores xmm para manipular os valores de ponto flutuante 
	;e armazena o resultado na memória antes de retornar.
	ret

;Função de subtração de dois valores em float, dado pela entrada 's'
funcao_subtracao:
	;Essa função realiza a operação de subtração de 
	;dois valores em ponto flutuante de precisão simples e retorna o resultado. 
	;Ela usa registradores xmm para manipular os valores de ponto flutuante 
	;e armazena o resultado na memória antes de retornar.
	push rbp
	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD  [rbp-4]

	;Operação de subtração dos floats
	subss xmm0, DWORD  [rbp-8]

	movss DWORD  [rbp-4], xmm0
	movss xmm0, DWORD  [rbp-4]

	pop rbp
	ret

;Função de multiplicação de dois valores em float, dado pela entrada 'm'
funcao_multiplicacao:
	;Essa função realiza a operação de multiplicação de dois valores 
	;em ponto flutuante de precisão simples e retorna o resultado. 
	;Ela usa registradores xmm para manipular os valores de ponto flutuante 
	;e armazena o resultado na memória antes de retornar.
	push rbp
	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD [rbp-4]

	;Operação de multiplicação dos floats
	mulss xmm0, DWORD [rbp-8]

	movss DWORD [rbp-4], xmm0
	movss xmm0, DWORD [rbp-4]

	pop rbp
	ret

;Função de multiplicação de dois valores em float, dado pela entrada 'd'
funcao_divisao:
	;Essa função realiza a operação de divisão de dois valores 
	;em ponto flutuante de precisão simples e retorna o resultado. 
	;Ela usa registradores xmm para manipular os valores de ponto flutuante 
	;e armazena o resultado na memória antes de retornar.
	push rbp
	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD [rbp-4]

	;Operação de divisão dos floats
	divss xmm0, DWORD [rbp-8]

	movss DWORD [rbp-4], xmm0
	movss xmm0, DWORD [rbp-4]

	pop rbp
	ret

;Função de exponenciação de dois valores em float, dado pela entrada 'e'
funcao_exponenciacao:
    push rbp
    mov rbp, rsp

	;Move o valor de xmm0 (o primeiro operando) para xmm2.
    movss xmm2, xmm0
	;Converte o valor de xmm1 (o segundo operando) 
	;de ponto flutuante de precisão simples (float) para um inteiro de 64 bits, armazenado em rdi. 
	;A instrução cvttss2si é usada para converter um valor de ponto flutuante de precisão simples 
	;em um valor inteiro com truncamento.
	cvttss2si rdi, xmm1

	;Comparam o valor de rdi com 0. 
	;Se for igual a 0 (je igual_zero), significa que o expoente é 0 e o resultado será 1. 
	;Se for menor que 0 (jl igual_um), significa que o expoente é negativo e o código pula para a label igual_um.
	cmp rdi, 0
    je igual_zero
	jl igual_um

	;Comparam o valor de rdi com 1. 
	;Se for igual a 1 (je menor_zero), significa que o expoente é 1 e o código pula para a label menor_zero. 
	;Caso contrário, o código pula para a label laco_expoente.
    cmp rdi, 1
    je menor_zero
    jmp laco_expoente

;Função comparadora com o expoente sendo que qualquer número elevado a 0 é 1
;chamando o auxiliar_0 e assim convertendo de inteiro para float
igual_zero:
	;Converte o valor inteiro armazenado no endereço de memória [aux_0] 
	;para um valor de ponto flutuante de precisão simples (float) e armazena-o no registrador xmm0. 
	;A instrução cvtsi2ss é usada para converter um valor inteiro de 32 bits 
	;em um valor de ponto flutuante de precisão simples.
    cvtsi2ss xmm0,[aux_0]

menor_zero:
	;Essas linhas desfazem o frame da pilha da função funcao_exponenciacao. 
	;O registrador rsp é restaurado com o valor de rbp (mov rsp, rbp), e o rbp é desempilhado (pop rbp). 
	;Em seguida, a instrução ret é usada para retornar ao ponto de chamada da função.
    mov rsp, rbp
    pop rbp
	ret

;Função que multiplica um pelo outro na exponenciação, enquanto o valor
;não for igual a 1, o laço não para
laco_expoente:
	;Essa linha multiplica o valor em xmm0 pelo valor em xmm2, 
	;atualizando xmm0 com o resultado da multiplicação. 
	;A instrução mulss é usada para multiplicar dois valores de ponto flutuante de precisão simples (float).
    mulss xmm0, xmm2

	;Essa linha decrementa o valor do registrador rdi, que representa o expoente, em 1. 
	;É usado para controlar o loop, pois o loop deve continuar até que o expoente seja igual a 1.
    dec rdi

	;Essas linhas comparam o valor de rdi com 1. 
	;Se o valor de rdi for diferente de 1 (jne laco_expoente), 
	;o código pula de volta para a label laco_expoente, continuando o loop. 
	;Caso contrário, o loop é interrompido e a execução continua após o loop.
    cmp rdi, 1
    jne laco_expoente
	
	mov rsp, rbp
    pop rbp	
    ret
	jmp main

;Usada para lidar com o caso em que o expoente é igual a 1. 
;Nesse caso, o código armazena o valor 1 em [aux_1] para indicar que o expoente é 1.
igual_um:
	xor r15b, r15b
	mov r15b, 1
	mov [aux_1], r15b
	
	mov rsp, rbp
    pop rbp	
    ret





main:
	;O ponteiro de base do registro (rbp) é salvo na pilha com push rbp. 
	push rbp
	;rbp é movido para o topo da pilha com mov rbp, rsp. 
	;Isso estabelece um novo frame da pilha para a função main.
	mov rbp, rsp
	
	;Subtrai 32 bytes (0x20 em hexadecimal) do registro rsp, 
	;alocando espaço na pilha para variáveis locais ou 
	;outras informações necessárias durante a execução da função.
	sub rsp, 0x20
	
	;Carregam os endereços das strings nome_arquivo e permissao_escrita 
	;nos registradores rdi e rsi, respectivamente. 
	;Em seguida, a função fopen é chamada usando call fopen, 
	;o que abrirá o arquivo com o nome e a permissão especificados.
	;Salva o nome do arquivo e sua permissão.
	lea rdi, [nome_arquivo]
	lea rsi, [permissao_escrita] 
	;Abre o arquivo
	call fopen 

	;Move o valor retornado pela função fopen para a variável indentifica_arquivo, 
	;armazenando assim o identificador do arquivo aberto.
	;Verifica o arquivo
	mov [indentifica_arquivo], rax

	;Função write do sistema operacional para 
	;exibir a string definida em entrada_print na saída padrão (stdout). 
	;O valor 1 é colocado no registrador rax para indicar que a função write será chamada. 
	;O valor 1 é movido para o registrador rdi para indicar que a saída padrão será usada. 
	;O endereço da string entrada_print é carregado no registrador rsi, 
	;e o tamanho da string entrada_print_l é movido para o registrador edx. 
	;A syscall é feita para chamar a função write.
	mov rax, 1
	mov rdi, 1
	lea rsi, [entrada_print]
	mov edx, entrada_print_l
	syscall

	;Carregam os endereços de memória onde os valores de entrada 
	;serão armazenados nos registradores rcx, rdx e rax. 
	lea rcx, [rbp-16]
	lea rdx, [rbp-17]
	lea rax, [rbp-12]

	;Os registradores são movidos para os registradores apropriados 
	;para serem passados como argumentos para a função scanf. 
	mov rsi, rax
	mov edi, entradas
	mov eax, 0
	;A função scanf é chamada para realizar a leitura dos valores de entrada fornecidos pelo usuário.
	;Chama a função para a entrada dos valores
	call scanf

	;Carregam o valor do caractere de operação, 
	;que foi lido pela função scanf, do endereço de memória [rbp-17] para o registrador al. 
	;O valor é estendido para o registrador eax, preservando o sinal do byte original. 
	;Isso é necessário para realizar comparações corretas posteriormente.
	movzx eax, BYTE [rbp-17]
	movsx eax, al

	;Comparação para a adição -> a
	cmp eax, 0x61
	je adicao

	;Comparação para a subtração -> s
	cmp eax, 0x73
	je subtracao

	;Comparação para a multiplição -> m
	cmp eax, 0x6d
	je multiplicacao

	;Comparação para a divisão -> d
	cmp eax, 0x64
	je divisao

	;Comparação para a exponenciação -> e
	cmp eax, 0x65
	je exponenciacao

	;Se nenhuma das comparações anteriores for verdadeira, 
	;o salto incondicional jmp é tomado para a label operacao_final. 
	;Isso permite que o programa execute a operação final, 
	;independentemente do caractere de operação lido.
	jmp operacao_final

;Função de adição, com a definição dos parametros, sendo acessada
;pela comparação feita acima pela letra de entrada
adicao:
	;Move o valor do segundo operando (que está localizado em [rbp-16]) para o registrador xmm0. 
	;O prefixo movss é usado para mover um valor de ponto flutuante 
	;de precisão simples (32 bits) de memória para um registrador xmm.
	movss xmm0, DWORD [rbp-16]

	;Move o valor do primeiro operando (localizado em [rbp-12]) para o registrador eax. 
	;Esse operando é um valor inteiro de 32 bits.
	mov eax, DWORD [rbp-12]

	;A instrução movaps é usada para mover um valor de ponto flutuante 
	;de precisão simples entre registradores xmm. 
	;A instrução movd é usada para mover um valor inteiro 
	;de 32 bits para um registrador xmm.
	movaps xmm1, xmm0
	movd xmm0, eax

	;Chama a função funcao_soma, que implementa a operação de adição. 
	;Os valores dos registradores xmm0 e xmm1 são passados como argumentos para a função.
	call funcao_soma

	;Movem o resultado da operação de adição, que está no registrador xmm0, 
	;de volta para o registrador eax e, em seguida, 
	;armazenam o valor resultante na memória, no endereço [rbp-4]. 
	;O resultado é armazenado como um valor inteiro de 32 bits.
	movd eax, xmm0
	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 0x2b ;'+' -> 0x2b ASCII

	jmp operacao_final

;Função de subtração, com a definição dos parametros, sendo acessada
;pela comparação feita acima pela letra de entrada
subtracao:
	;Implementa a operação de subtração, 
	;movendo os operandos para registradores xmm, chamando a função funcao_subtracao 
	;e armazenando o resultado na memória. Além disso, armazena o caractere de operação 
	;correspondente à subtração para uso posterior. 
	;O salto incondicional é feito para continuar com a execução do programa.
	
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call funcao_subtracao

	movd eax, xmm0
	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 0x2d ;'-' -> 0x2d ASCII
	
	jmp operacao_final

;Função de multiplicação, com a definição dos parametros, sendo acessada
;pela comparação feita acima pela letra de entrada
multiplicacao:
	;Essas instruções implementam a operação de multiplicação, 
	;movendo os operandos para registradores xmm, 
	;chamando a função funcao_multiplicacao e armazenando o resultado na memória. 
	;Armazena o caractere de operação correspondente à multiplicação para uso posterior. 
	;O salto incondicional é feito para continuar com a execução do programa.
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call funcao_multiplicacao

	movd eax, xmm0
	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 0x2a ;'*' -> 0x2a ASCII
	
	jmp operacao_final

;Função de divisão, com a definição dos parametros, sendo acessada
;pela comparação feita acima pela letra de entrada
divisao:
	;Essas instruções implementam a operação de divisão, 
	;movendo os operandos para registradores xmm, 
	;chamando a função funcao_divisao e armazenando o resultado na memória. 
	;Além disso, armazena o caractere de operação correspondente à divisão para uso posterior. 
	;O salto incondicional é feito para continuar com a execução do programa.
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call funcao_divisao

	movd eax, xmm0
	mov DWORD  [rbp-4], eax
	mov BYTE  [rbp-5], 0x2f	;'/' -> 0x2f ASCII
	
	;Verifica divisao por zero
	cmp DWORD [rbp-16], 0
	je flagzero
	
	jmp operacao_final

;Aciona flag que indica divisao por zero
flagzero:
	mov r8, 1
	jmp operacao_final
	
;Função de exponenciação, com a definição dos parametros, sendo acessada
;pela comparação feita acima pela letra de entrada
exponenciacao:
	;Essas instruções implementam a operação de exponenciação, 
	;movendo os operandos para registradores xmm, chamando a função funcao_exponenciacao 
	;e armazenando o resultado na memória. Além disso, armazena o caractere de operação correspondente 
	;à exponenciação para uso posterior.
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call funcao_exponenciacao

	movd eax, xmm0

	mov DWORD  [rbp-4], eax
	mov BYTE  [rbp-5], 0x5e	;'^' -> 0x5e ASCII
	
	;Instrução "no operation" (sem operação), não faz nada,
	;usada para fins de preenchimento/alinhamento de código.
	jmp operacao_final

;Função dos dados, caso nenhuma comparação seja feita e os dados estejam
;na pilha, por meio das instruções, ocorre uma conversão para ponto-flutuante
operacao_final:
	;Inicializa xmm1 como zero usando a instrução pxor. 
	pxor xmm1, xmm1
	;Converte o valor de ponto flutuante de precisão simples (float) armazenado em [rbp-4] 
	;para um valor de ponto flutuante de precisão dupla (double).  
	;Essa conversão permite que o valor seja usado em cálculos de precisão dupla.
	cvtss2sd xmm1, DWORD [rbp-4]

	;Convertem o valor de ponto flutuante de precisão simples (float) armazenado em [rbp-16] 
	;para um valor de ponto flutuante de precisão dupla (double), 
	;atualizando xmm0 com o valor convertido.
	movss xmm0, DWORD [rbp-16]
	cvtss2sd xmm0, xmm0

	;Estendem o valor do byte em [rbp-5] para um inteiro de 32 bits, armazenando-o em edx. 
	movsx edx, BYTE [rbp-5]
	;O valor de ponto flutuante de precisão simples (float) em [rbp-12] é movido para xmm2.
	movss xmm2, DWORD [rbp-12]

	;Inicializam xmm3 como zero usando a instrução pxor.
	pxor xmm3, xmm3
	;Convertem o valor de ponto flutuante de precisão simples (float) em xmm2 
	;para um valor de ponto flutuante de precisão dupla (double).
	cvtss2sd xmm3, xmm2

	;Move o valor de xmm3 para o registrador rax. 
	;Isso é feito para preservar o valor de xmm3, pois ele será usado posteriormente.
	movq rax, xmm3

	;Movem os valores de xmm1 e xmm0 para xmm2 e xmm1, respectivamente. 
	;Isso é feito para preservar os valores de xmm1 e xmm0, pois eles serão usados posteriormente.
	movapd xmm2, xmm1
	movapd xmm1, xmm0

	;Essa linha move o valor de edx para esi, 
	;para usá-lo como argumento em alguma chamada de função posterior.
	mov esi, edx

	;Essa linha move o valor de rax para xmm0. 
	;Isso é feito para restaurar o valor original de xmm0, 
	;que foi salvo em rax anteriormente.
	movq xmm0, rax
	
	;Essas linhas realizam uma verificação condicional. 
	;O valor em [aux_1] é movido para o registrador r15b. 
	;Em seguida, o código compara r15b com zero. 
	;Se for diferente de zero, o código pula para a label erro_escrever, indicando um erro na escrita. 
	;Essa verificaçãocestá relacionada à funcionalidade do arquivo de saída.
	xor r15b, r15b
	mov r15b, [aux_1]
	cmp r15b, 0
	jne erro_escrever

	;Flag para divisao por 0
	cmp r8, 1
	je erro_escrever

;Caso o arquivo esteja certo, sua escritura será feita a partir do
;fprintf() com sua indentificação 'a+'
escrever:
	;Preparam os argumentos para a chamada da função fprintf, que é usada para escrever no arquivo. 
	;O primeiro argumento é o identificador do arquivo armazenado em [indentifica_arquivo], 
	;que é movido para o registrador rdi. 
	;O segundo argumento é a string de formato para a saída correta [saida_good], que é carregada em rsi. 
	;O terceiro argumento é o modo de escrita, 
	;representado pelo valor hexadecimal 0x03, que é movido para o registrador rax.
	mov rdi, [indentifica_arquivo]
	lea rsi, [saida_good]
	mov rax, 0x03
	
	;Faz a chamada para a função fprintf com os argumentos preparados. 
	;Isso escreverá os resultados no arquivo.
	call fprintf
	
	;Definem o valor de retorno da função main como 0, 
	;indicando que a execução do programa foi concluída com sucesso.
	;O código pula para a label fecha, que é usada para fechar o arquivo.
	mov eax, 0
	jmp fecha

;Caso o arquivo não esteja certo, não será feito a escritura do
;resultado mas sim de uma mensagem de 'ERRO' passado para dentro
;do arquivo
erro_escrever:
	;Preparam os argumentos para a chamada da função fprintf para escrever a mensagem de erro no arquivo. 
	;O primeiro argumento é o identificador do arquivo armazenado em [indentifica_arquivo], 
	;que é movido para o registrador rdi. 
	;O segundo argumento é a string de formato para a mensagem de erro [saida_bad], que é carregada em rsi. 
	;O terceiro argumento é o modo de escrita, representado pelo valor hexadecimal 0x04, 
	;que é movido para o registrador rax.
	mov rdi, [indentifica_arquivo]
	lea rsi, [saida_bad]
	mov rax, 0x04
	
	;Faz a chamada para a função fprintf com os argumentos preparados. 
	;Isso escreverá a mensagem de erro no arquivo.
	call fprintf
	mov eax, 0

;Fecha o arquivo chamando o fclose() com base do extern
fecha:
	mov rdi, [indentifica_arquivo]
	call fclose
	
	;Essas instruções são usadas para realizar a limpeza da pilha e retornar da função main. 
	;A instrução leave é uma forma abreviada de mov rsp, rbp seguida por pop rbp, 
	;que restaura o valor do registrador de base da pilha (rbp) e 
	;ajusta o ponteiro de pilha (rsp) para o estado anterior à função main. 
	;A instrução ret retorna da função main.
	leave
	ret

;Finalização classica do algoritmo
fim:
	;Essas linhas são responsáveis pela finalização do algoritmo. 
	;A instrução mov rsp, rbp seguida por pop rbp realiza a limpeza da pilha e 
	;restaura o estado original do registrador de base da pilha. 
    mov rsp, rbp
    pop rbp

	;Em seguida, as instruções mov rax, 60, mov rdi, 0 e syscall são usadas para encerrar o programa, 
	;com o valor de retorno 0 indicando que a execução foi concluída com sucesso.
    mov rax, 60
    mov rdi, 0
    syscall
