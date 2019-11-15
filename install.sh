#!/bin/bash
set -e
export url=https://go.microsoft.com/fwlink/?LinkID=620884
export file=/tmp/vscode.tar.gz
export sh_file=~/Desktop/code.desktop
export executable=~/VSCode-linux-x64/code

echo Fazendo download
curl -L $url -o $file
echo
echo Extraindo
tar -xzf $file -C ~

echo Instalando extensoes
export PATH=~/code;$PATH
while read extensions.txt; do
	code --install-extension ext
done

echo Criando atalho
echo "[Desktop Entry]" > $sh_file
echo "Name=Visual Studio Code" >> $sh_file
echo "Comment=Code Editing. Redefined." >> $sh_file
echo "GenericName=Text Editor" >> $sh_file
echo "Exec=$executable --unity-launch %F" >> $sh_file
echo "Icon=$executable" >> $sh_file
echo "Type=Application" >> $sh_file
echo "StartupNotify=true" >> $sh_file
echo "StartupWMClass=Code" >> $sh_file
echo "Categories=Utility;TextEditor;Development;IDE;" >> $sh_file
echo "MimeType=text/plain;inode/directory;" >> $sh_file
echo "Actions=new-empty-window;" >> $sh_file
echo "Keywords=vscode;" >> $sh_file
echo "" >> $sh_file
echo "[Desktop Action new-empty-window]" >> $sh_file
echo "Name=New Empty Window" >> $sh_file
echo "Exec=/usr/share/code/code --new-window %F" >> $sh_file
echo "Icon=code" >> $sh_file

