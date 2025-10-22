# **RedDust Language**  
![Status](https://img.shields.io/badge/status-active-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Python](https://img.shields.io/badge/python-3-yellow)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

<img width="400" height="200" alt="reddust" src="https://github.com/user-attachments/assets/4927d3b0-8a93-4edf-b9b5-eedd22718957" />


**RedDust** é uma linguagem minimalista projetada para simular lógica em um computador construído com Redstone no *Minecraft*, especificamente o 7SPM.  
Este repositório contém o interpretador, suporte para sintaxe em múltiplos editores e scripts para instalação global.

Confira a [documentação](DOCS.md)

---

## **📌 Funcionalidades**
✔ Interpretador `reddust` disponível globalmente  
✔ `--help`, `--version`, `--debug` adicionados  
✔ Ícone e associação de arquivos `.redd` no sistema  
✔ Syntax Highlight para:
- [x] **VSCode**
- [x] **Geany**
- [x] **Vim**
- [ ] Nano (em breve)  

---

## **🚀 Instalação Rápida**
Execute:

```bash
curl -fsSL https://raw.githubusercontent.com/synt-xerror/RedDust/main/redd-install.sh | bash
```

✅ Após a instalação:

```bash
reddust --help
```

---

## **🗑️ Desinstalação**
```bash
curl -fsSL https://raw.githubusercontent.com/synt-xerror/RedDust/main/redd-uninstall.sh | bash
```

---

## **📦 Requisitos**
- Linux (Debian/Ubuntu, Arch testado)
- **Python 3** (instalado automaticamente se não existir)
- Curl (`sudo apt-get install curl` ou `sudo pacman -S curl`)

---

## **📖 Como usar**
### **Modo arquivo**
```bash
reddust programa.redd
```

### **Modo interativo (REPL)**
```bash
reddust
```

### **Opções adicionais**
```
--help        Mostra ajuda
--version     Exibe versão do interpretador
--debug       Executa mostrando estado da memória
```

---

## **📂 Estrutura do Projeto**
```
RedDust/
├── highlighting
│   ├── geany-reddust
│   │   └── filetypes.reddust.conf
│   ├── vim-reddust
│   │   └── reddust.vim
│   └── vscode-reddust
│       ├── icon.png
│       ├── language-configuration.json
│       ├── package.json
│       ├── reddust-1.0.0.vsix
│       └── reddust.tmLanguage.json
├── icon
│   └── reddust.png
├── redd-install.sh
├── redd-uninstall.sh
└── reddust
```

---

## **🖌 Suporte para editores**
✔ **VSCode:** instalado automaticamente pelo script  
✔ **Geany:** syntax highlight básico  
✔ **Vim:** syntax highlight com grupos (Keywords, Numbers, Comments)  

---

## **📜 Exemplo de programa (`hello.redd`)**
```
// Solicita valor do usuário e exibe
1;1;0;0   // INPUT → mem[1]
2;1;0;0   // OUTPUT mem[1]
0;0;0;0   // HALT
```

Execute:
```bash
reddust hello.redd
```

---

## **🔢 Tabela de Instruções**
| Código | Instrução         | Descrição                              |
|--------|-------------------|----------------------------------------|
| 0      | HALT              | Finaliza execução                      |
| 1      | INPUT             | Lê valor do usuário (ou imediato)      |
| 2      | OUTPUT            | Exibe valor de um endereço             |
| 3      | ADD               | Soma (A+B → C)                         |
| 4      | SUB               | Subtração (A-B → C)                    |
| 5      | DIV               | Divisão inteira                        |
| 6      | MUL               | Multiplicação                          |
| 7      | COND JUMP         | Salta se valor = esperado              |
| 8      | JUMP              | Salto incondicional                    |
| 9      | CLEAR             | Zera memória no endereço               |
| A      | RANDOM            | Aleatório (0-15) em endereço           |
| B      | CMP GREATER       | 1 se A>B, senão 0                      |
| C      | CMP EQUAL         | 1 se A=B, senão 0                      |
| D      | MOVE              | Copia valor entre endereços            |
| E      | INC/DEC           | Incrementa ou decrementa (flag)        |
| F      | WAIT              | Pausa em segundos                      |

---

## **👨‍💻 Autor**
**Syntax**  
[GitHub](https://github.com/SynthX7)
