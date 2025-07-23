#!/bin/bash
set -e

echo "[INFO] Removendo RedDust..."

# Interpretador
sudo rm -f /usr/local/bin/reddust

# Ícone e MIME
sudo rm -rf /usr/share/icons/reddust
sudo rm -f /usr/share/mime/packages/reddust.xml
sudo update-mime-database /usr/share/mime

# VSCode
rm -rf ~/.vscode/extensions/reddust-syntax

# Geany
rm -f ~/.config/geany/filedefs/filetypes.reddust.conf

# Vim
rm -f ~/.vim/syntax/reddust.vim
sed -i '/reddust/d' ~/.vimrc

# Nano
sed -i '/reddust.nanorc/d' ~/.nanorc
rm -f ~/.nano/reddust.nanorc

echo "[INFO] RedDust removido com sucesso!"
