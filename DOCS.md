# 📚 Documentação da Linguagem RedDust

**RedDust** é uma linguagem minimalista projetada para ser executada em uma máquina virtual ou em um computador físico construído com redstone (7SPM - Seven Segment Programmable Machine).

---

## ✅ **Formato das Instruções**
Cada linha do programa deve conter **4 valores em hexadecimal**, separados por ponto e vírgula (`;`), conforme:

```
CMD;A;B;C
```

- **CMD** → Código da instrução (0 a F)
- **A, B, C** → Operandos (endereços de memória ou valores imediatos)
- Cada instrução ocupa **4 dígitos obrigatórios** para manter compatibilidade com a arquitetura 7SPM.
- Valores em hexadecimal de **1 digito**, e em letra maiúscula.

Exemplo:
```
1;1;A;0   // INPUT → Salva valor imediato A (10) no registrador 1
```

---

## 🔢 **Tabela de Instruções**
| Código | Comando       | Descrição                                                                                             | Exemplo                                                                                   |
|--------|--------------|-----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| **0**  | **HALT**     | Finaliza a execução do programa.                                                                    | `0;0;0;0 // encerra o programa`                                                         |
| **1**  | **INPUT**    | Lê um número do usuário (se B=0) ou usa valor imediato (B≠0) e salva em A.                           | `1;1;5;0 // salva 5 no R1`                                                              |
| **2**  | **OUTPUT**   | Exibe o valor armazenado no endereço A.                                                              | `2;1;0;0 // mostra valor de R1`                                                         |
| **3**  | **ADD**      | Soma (mem[A] + mem[B]) e salva em C.                                                                 | `3;1;2;3 // R3 = R1 + R2`                                                               |
| **4**  | **SUB**      | Subtrai (mem[A] - mem[B]) e salva em C.                                                              | `4;1;2;3 // R3 = R1 - R2`                                                               |
| **5**  | **DIV**      | Divide (mem[A] ÷ mem[B]) e salva em C (divisão inteira).                                             | `5;1;2;3 // R3 = R1 / R2`                                                               |
| **6**  | **MUL**      | Multiplica (mem[A] × mem[B]) e salva em C.                                                           | `6;1;2;3 // R3 = R1 * R2`                                                               |
| **7**  | **COND JUMP**| Pula para a linha C se mem[A] == B.                                                                   | `7;1;3;8 // Se R1 == 3 → pula para linha 8`                                             |
| **8**  | **JUMP**     | Pula incondicionalmente para a linha A.                                                              | `8;A;0;0 // Pula para linha A (10)`                                                     |
| **9**  | **CLEAR**    | Zera mem[A].                                                                                          | `9;1;0;0 // R1 = 0`                                                                      |
| **A**  | **RANDOM**   | Salva em A um número aleatório entre B e C.                                | `A;A;B;1 // R1 = valor aleatório (A-B)`                                                 |
| **B**  | **CMP GREATER**| Compara mem[A] > mem[B]; salva 1 (sim) ou 0 (não) em C.                                             | `B;1;2;3 // Se R1 > R2 → R3 = 1, senão 0`                                               |
| **C**  | **CMP EQUAL**| Verifica se mem[A] == mem[B], salva 1 (sim) ou 0 (não) em C.                                    | `C;1;2;0 // troca R1 com R2`                                                            |
| **D**  | **MOVE**     | Copia mem[A] para mem[B].                                                                             | `D;1;2;0 // R2 = R1`                                                                     |
| **E**  | **INC/DEC**  | Incrementa (flag=1) ou decrementa (flag=0) mem[A].                                                    | `E;1;1;0 // R1++` \| `E;1;0;0 // R1--`                                                  |
| **F**  | **WAIT**     | Pausa por A segundos (HEX → decimal).                                                                 | `F;A;0;0 // Espera 10 segundos`                                                         |

---

## ✅ **Exemplo de Programa**
**Objetivo:** Solicitar 2 números, somar e exibir o resultado.

```
1;1;0;0   // INPUT → mem[1]
1;2;0;0   // INPUT → mem[2]
3;1;2;3   // ADD → mem[3] = mem[1] + mem[2]
2;3;0;0   // OUTPUT → mem[3]
0;0;0;0   // HALT
```

---

## ⚠ Observações
- Todos os valores são **HEX (0-F)**.
- Cada linha deve ter **4 parâmetros obrigatórios** para compatibilidade com o **7SPM**.
- Comentários iniciam com `//`.

