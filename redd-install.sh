#!/bin/bash
set -e

INSTALL_DIR="/usr/local/bin"
ICON_DIR="/usr/share/icons/reddust"
MIME_DIR="/usr/share/mime/packages"
GITHUB_RAW="https://raw.githubusercontent.com/SynthX7/reddust/main"

echo "[INFO] Iniciando instalação do RedDust..."

# 1. Verifica se Python 3 está instalado
if ! command -v python3 &> /dev/null; then
    echo "[INFO] Python3 não encontrado. Instalando..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update && sudo apt-get install -y python3
    elif [ -f /etc/arch-release ]; then
        sudo pacman -Sy --noconfirm python
    else
        echo "[ERRO] Não foi possível detectar a distribuição. Instale Python 3 manualmente."
        exit 1
    fi
else
    echo "[INFO] Python3 já está instalado."
fi

# 2. Instala interpretador
echo "[INFO] Instalando interpretador RedDust..."
sudo curl -fsSL "$GITHUB_RAW/reddust" -o "$INSTALL_DIR/reddust"
sudo chmod +x "$INSTALL_DIR/reddust"

# 3. Ícone
echo "[INFO] Instalando ícone..."
sudo mkdir -p "$ICON_DIR"
sudo curl -fsSL "$GITHUB_RAW/icon/reddust.png" -o "$ICON_DIR/icon.png"

# 4. Configuração MIME
echo "[INFO] Configurando MIME..."
sudo tee "$MIME_DIR/reddust.xml" > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="text/reddust">
    <comment>RedDust Source Code</comment>
    <glob pattern="*.redd"/>
    <icon name="reddust"/>
  </mime-type>
</mime-info>
EOF
sudo update-mime-database /usr/share/mime
if command -v gtk-update-icon-cache &> /dev/null; then
    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor
fi

# 5. VSCode Syntax (somente se VSCode estiver instalado)
echo "[INFO] Verificando VSCode..."
if [ -d "$HOME/.vscode/extensions" ]; then
    echo "[INFO] Instalando suporte para VSCode..."
    EXT_DIR="$HOME/.vscode/extensions/reddust-syntax"
    mkdir -p "$EXT_DIR"
    curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/package.json" -o "$EXT_DIR/package.json"
    curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/reddust.tmLanguage.json" -o "$EXT_DIR/reddust.tmLanguage.json"
    curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/language-configuration.json" -o "$EXT_DIR/language-configuration.json"
    curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/icon.png" -o "$EXT_DIR/icon.png"
else
    echo "[AVISO] VSCode não encontrado (pasta ~/.vscode/extensions ausente). Pulei a instalação."
fi

# 6. Geany Syntax
echo "[INFO] Verificando Geany..."
if [ -d "$HOME/.config/geany/filedefs" ]; then
    echo "[INFO] Instalando suporte para Geany..."
    curl -fsSL "$GITHUB_RAW/highlighting/geany-reddust/filetypes.reddust.conf" -o "$HOME/.config/geany/filedefs/filetypes.reddust.conf"
else
    echo "[AVISO] Geany não encontrado (pasta ~/.config/geany/filedefs ausente). Pulei a instalação."
fi

# 7. Vim Syntax
echo "[INFO] Verificando Vim..."
if [ -d "$HOME/.vim" ]; then
    mkdir -p "$HOME/.vim/syntax"
    curl -fsSL "$GITHUB_RAW/highlighting/vim-reddust/reddust.vim" -o "$HOME/.vim/syntax/reddust.vim"
    if [ -f "$HOME/.vimrc" ]; then
        grep -qxF 'au BufNewFile,BufRead *.redd set filetype=reddust' "$HOME/.vimrc" || echo 'au BufNewFile,BufRead *.redd set filetype=reddust' >> "$HOME/.vimrc"
    else
        echo "[AVISO] ~/.vimrc não encontrado. Pulei configuração automática do Vim."
    fi
else
    echo "[AVISO] Vim não encontrado (pasta ~/.vim ausente). Pulei a instalação."
fi

# 8. Nano Syntax
if [ -f "$HOME/.nanorc" ]; then
    mkdir -p "$HOME/.nano"
    grep -qxF 'include ~/.nano/reddust.nanorc' "$HOME/.nanorc" || echo 'include ~/.nano/reddust.nanorc' >> "$HOME/.nanorc"
    curl -fsSL "$GITHUB_RAW/highlighting/nano-reddust/reddust.nanorc" -o "$HOME/.nano/reddust.nanorc"
else
    echo "[AVISO] ~/.nanorc não encontrado. Pulei suporte ao Nano."
fi

echo "[INFO] Instalação concluída! É recomendável reiniciar o sistema ou a sessão atual."
echo "✅ Use com: reddust arquivo.redd"
