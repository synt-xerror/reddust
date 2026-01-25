#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// --- Definições Globais ---

// Memória da máquina, igual à versão em Python
int memory[256] = {0};

typedef enum {
    TOKEN_NUMBER,
    TOKEN_IDENTIFIER
} TokenType;

typedef struct {
    TokenType type;
    union {
        int number;
        char letter;
    } value;

    int line;
    int column;
} Token;

// Estrutura para uma única instrução (4 tokens)
typedef struct {
    int tokens[4];
    int line;
} Instruction;

// --- Funções Auxiliares ---

// Converte um inteiro para uma string hexadecimal (para debug)
// Em C, precisamos gerenciar o buffer de string manualmente.
void to_hex_string(int val, char *hex_str, size_t size) {
    snprintf(hex_str, size, "%X", val);
}

// Analisa uma linha de código .redd e a converte em 4 inteiros.
// Retorna 1 em caso de sucesso, 0 em caso de falha.
int parse_line(char *line, int *instr_tokens) {
    // Remove comentários que começam com "//"
    char *comment = strstr(line, "//");
    if (comment != NULL) {
        *comment = '\0'; // Termina a string no início do comentário
    }

    // Usa strtok para dividir a string pelo delimitador ";"
    // strtok é "destrutivo", ele modifica a string original.
    char *token = strtok(line, ";");
    int i = 0;
    while (token != NULL && i < 4) {
        // strtol converte string para long, aqui usado para hex (base 16)
        instr_tokens[i] = (int)strtol(token, NULL, 16);
        token = strtok(NULL, ";");
        i++;
    }

    // Se não tivermos exatamente 4 tokens, a linha é inválida
    if (i != 4) {
        // Ignora linhas vazias ou com erro de formatação
        if (i > 0) printf("[ERRO] Linha inválida (esperado 4 valores): %s\n", line);
        return 0; // Falha
    }
    return 1; // Sucesso
}


// --- Lógica de Execução ---

void run_program(Instruction *program, int num_instructions, int debug) {
    int pc = 0; // Program Counter (Contador de Programa)

    while (pc < num_instructions) {
        Instruction instr = program[pc];
        int cmd = instr.tokens[0];

        if (debug) {
            char hex_instr[50];
            char mem_preview[100];
            
            // Monta a string de debug para a instrução
            snprintf(hex_instr, sizeof(hex_instr), "%X;%X;%X;%X", instr.tokens[0], instr.tokens[1], instr.tokens[2], instr.tokens[3]);
            
            // Monta a string de debug para a memória
            mem_preview[0] = '\0';
            for(int i = 0; i < 16; i++) {
                char hex_val[4];
                to_hex_string(memory[i], hex_val, sizeof(hex_val));
                strcat(mem_preview, hex_val);
                strcat(mem_preview, " ");
            }
            printf("[DEBUG] PC=%02X, CMD=%s, MEM[0..F]=%s\n", pc + 1, hex_instr, mem_preview);
        }

        // Usa um switch-case, que é mais eficiente e idiomático em C do que if-else if.
        switch (cmd) {
	    case 0: // HALT
                printf("[INFO] Programa finalizado.\n");
                return;

            case 1: { // INPUT
                int a = instr.tokens[1];
                int b = instr.tokens[2];
                if (b != 0) {
                    memory[a] = b;
                } else {
                    printf("[INFO] Waiting for input...\n");
                    char value_str[10];
                    printf("Digite valor HEX para mem[%X]: ", a);
                    scanf("%s", value_str);
                    memory[a] = (int)strtol(value_str, NULL, 16);
                }
                break;
            }

            case 2: // OUTPUT
                printf("%X\n", memory[instr.tokens[1]]);
                break;

            case 3: // ADD
                memory[instr.tokens[3]] = memory[instr.tokens[1]] + memory[instr.tokens[2]];
                break;

            case 4: // SUB
                memory[instr.tokens[3]] = memory[instr.tokens[1]] - memory[instr.tokens[2]];
                break;

            case 5: // DIV
                if (memory[instr.tokens[2]] != 0) {
                    memory[instr.tokens[3]] = memory[instr.tokens[1]] / memory[instr.tokens[2]];
                } else {
                    memory[instr.tokens[3]] = 0;
                }
                break;

            case 6: // MUL
                memory[instr.tokens[3]] = memory[instr.tokens[1]] * memory[instr.tokens[2]];
                break;

            case 7: // COND JUMP
                if (memory[instr.tokens[1]] == instr.tokens[2]) {
                    pc = instr.tokens[3] - 1; // -1 para compensar o pc++ no final do loop
                    continue;
                }
                break;

            case 8: // JUMP
                pc = instr.tokens[1] - 1; // -1 para compensar o pc++
                continue;

            case 9: // CLEAR
                memory[instr.tokens[1]] = 0;
                break;

            case 0xA: // RANDOM
                srand(time(NULL)); // Semente para o gerador de números aleatórios
                memory[instr.tokens[1]] = rand() % 16;
                break;

            case 0xB: // CMP GREATER
                memory[instr.tokens[3]] = (memory[instr.tokens[1]] > memory[instr.tokens[2]]) ? 1 : 0;
                break;

            case 0xC: // CMP LESS
                memory[instr.tokens[3]] = (memory[instr.tokens[1]] < memory[instr.tokens[2]]) ? 1 : 0;
                break;

            case 0xD: // MOVE
                memory[instr.tokens[2]] = memory[instr.tokens[1]];
                break;

            case 0xE: // INC/DEC
                if (instr.tokens[2] == 1) memory[instr.tokens[1]]++;
                else if (instr.tokens[2] == 0) memory[instr.tokens[1]]--;
                else printf("[ERROR]: Invalid flag: %X\n", instr.tokens[2]);
                break;
            
            case 0xF: // WAIT
		printf("[INFO]: Waiting %d seconds...\n", instr.tokens[1]);
		sleep(instr.tokens[1]); // Em C, sleep está em <unistd.h> (geralmente)
                break;

            default:
	        printf(
	            "CommandNotFoundError: opcode %X not found\n"
	            " --> line %d\n",
	            cmd,
	            instr.line
	        );
	        return;
	}
        pc++;
    }
}


// --- Função Principal ---

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s <arquivo.redd> [--debug]\n", argv[0]);
        return 1;
    }
    
    // Checa por argumentos, como --version ou --debug
    if (strcmp(argv[1], "--version") == 0) {
        printf("RedDust Interpreter v3.1 (C-Version)\n");
        return 0;
    }

    int debug = 0;
    if (argc > 2 && strcmp(argv[2], "--debug") == 0) {
        debug = 1;
    }

    // --- Leitura do Arquivo ---
    char *filename = argv[1];
    if (!strstr(filename, ".redd")) {
        printf("[ERRO] Arquivo deve ter extensão .redd\n");
        return 1;
    }

    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("[ERRO] Arquivo '%s' não encontrado.\n", filename);
        return 1;
    }

    // Aloca memória para o programa. Começamos com espaço para 100 instruções.
    // Em C, precisamos gerenciar o tamanho do array dinamicamente se não soubermos o tamanho.
    int max_instr = 100;
    Instruction *program = malloc(max_instr * sizeof(Instruction));
    if (program == NULL) {
        printf("[ERRO] Falha ao alocar memória para o programa.\n");
        return 1;
    }
    
    char line[100];
    int num_instructions = 0;
    int line_number = 1;
    
    while (fgets(line, sizeof(line), file)) {
        if (num_instructions >= max_instr) {
            max_instr *= 2;
            Instruction *new_program = realloc(program, max_instr * sizeof(Instruction));
            if (new_program == NULL) {
                printf("[ERRO] Falha ao realocar memória para o programa.\n");
                free(program);
                return 1;
            }
            program = new_program;
        }
    
        if (parse_line(line, program[num_instructions].tokens)) {
            program[num_instructions].line = line_number;
            num_instructions++;
        }
    
        line_number++;
    };
    fclose(file);

    // --- Execução ---
    run_program(program, num_instructions, debug);

    // Libera a memória que foi alocada dinamicamente
    free(program);

    return 0;
}
