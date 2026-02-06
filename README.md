# Calculadora em Assembly x86-64 (NASM)

Calculadora desenvolvida em Assembly (arquitetura AMD/Intel x86-64, sintaxe Intel) que lê dois operandos em ponto flutuante de precisão simples e um operador aritmético em uma única linha, executa o cálculo e registra o resultado em um arquivo cumulativo.

O programa utiliza funções externas da linguagem C para entrada/saída e manipulação de arquivo (scanf, printf, fopen, fclose, fprintf), conforme a especificação da atividade. O arquivo de saída é mantido entre execuções, sempre adicionando a nova linha ao final.

## Entrada

Formato esperado (uma linha):
<op1> <operador> <op2>


Leitura realizada com:
scanf("%f %c %f")


Onde:
- op1 e op2 são floats (precisão simples, sinalizados)
- operador é um caractere indicando a operação

## Operações suportadas

Operadores de entrada e respectivos operadores de saída no arquivo:

- a  -> +
- s  -> -
- m  -> *
- d  -> /
- e  -> ^

Divisão por zero e exponenciação com expoente negativo resultam em "funcionalidade não disponível", como descrito na atividade. 

## Saída

O programa grava o resultado em um arquivo cumulativo chamado:

- resultados.txt

Formato de saída:

Execução correta:
%lf %c %lf = %lf


Execução incorreta:
%lf %c %lf = funcionalidade não disponível


Observação: para escrever no arquivo é usado double (%lf), portanto os valores são convertidos de float (single) para double antes da chamada do fprintf. 

## Como compilar e executar

Montar:

nasm -f elf64 calc.asm -o calc.o


Linkar:

gcc -m64 -no-pie calc.o -o calc.x


Executar:

./calc.x


Arquivos
calc.asm: código-fonte em Assembly NASM (x86-64)


Implementação 
A função main define o stack frame, abre/cria o arquivo de saída em modo de append e realiza a leitura da expressão.

O operador informado é comparado e direciona para a operação correspondente.

As operações aritméticas são executadas com instruções SSE em registradores XMM.

A exponenciação é feita por multiplicações sucessivas, truncando o expoente para inteiro (conversão com truncamento).

Ao final, o programa decide entre registrar a saída correta ou a mensagem de funcionalidade não disponível e fecha o arquivo. 

