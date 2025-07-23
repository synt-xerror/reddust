#!/bin/bash
set -e

INSTALL_DIR="/usr/local/bin"
ICON_DIR="/usr/share/icons/reddust"
MIME_DIR="/usr/share/mime/packages"
VSCODE_EXT_DIR="$HOME/.vscode/extensions/reddust-syntax"
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
sudo update-icon-caches /usr/share/icons/*

# 5. VSCode Syntax
echo "[INFO] Instalando suporte para VSCode..."
mkdir -p "$VSCODE_EXT_DIR"
curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/package.json" -o "$VSCODE_EXT_DIR/package.json"
curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/reddust.tmLanguage.json" -o "$VSCODE_EXT_DIR/reddust.tmLanguage.json"
curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/language-configuration.json" -o "$VSCODE_EXT_DIR/language-configuration.json"
curl -fsSL "$GITHUB_RAW/highlighting/vscode-reddust/icon.png" -o "$VSCODE_EXT_DIR/icon.png"

# 6. Geany Syntax
echo "[INFO] Instalando suporte para Geany..."
mkdir -p ~/.config/geany/filedefs
curl -fsSL "$GITHUB_RAW/highlighting/geany-reddust/filetypes.reddust.conf" -o ~/.config/geany/filedefs/filetypes.reddust.conf

# 7. Vim Syntax
echo "[INFO] Instalando suporte para Vim..."
mkdir -p ~/.vim/syntax
curl -fsSL "$GITHUB_RAW/highlighting/vim-reddust/reddust.vim" -o ~/.vim/syntax/reddust.vim
grep -qxF 'au BufNewFile,BufRead *.redd set filetype=reddust' ~/.vimrc || echo 'au BufNewFile,BufRead *.redd set filetype=reddust' >> ~/.vimrc

# Nano (opcional)
mkdir -p ~/.nano
grep -qxF 'include ~/.nano/reddust.nanorc' ~/.nanorc || echo '# Syntax RedDust\ninclude ~/.nano/reddust.nanorc' >> ~/.nanorc

echo "[INFO] Instalação concluída! É recomendável reiniciar o sistema ou a sessão atual."
echo "✅ Use com: reddust arquivo.redd"
