#!/bin/bash

# Colores
COLOR_GREEN='\033[0;32m'
COLOR_CYAN='\033[0;36m'
COLOR_RESET='\033[0m'

# Obtén el nombre de la carpeta actual
folder_name=$(basename "$(pwd)")

# Verifica si el directorio ya está inicializado con Git
if [ -d ".git" ]; then
    echo -e "${COLOR_CYAN}El directorio ya está inicializado con Git.${COLOR_RESET}"
    exit 1
fi

echo "# $folder_name" >> README.md

# Verifica si existe el archivo go.mod
if [ -f "go.mod" ]; then
    echo -e "${COLOR_CYAN}El archivo go.mod ya existe en el directorio.${COLOR_RESET}"
else
    # Inicializa el módulo Go con el nombre del repositorio
    go mod init "github.com/cdvelop/$folder_name"
    echo -e "${COLOR_GREEN}Se ha inicializado el módulo Go con el nombre 'github.com/cdvelop/$folder_name'.${COLOR_RESET}"
fi

# Inicializa el repositorio Git
git init

# Agrega todos los archivos al repositorio
git add .

# Realiza el primer commit
git commit -m "Primer commit"

# estableser rama principal
git branch -M main

# Agrega el repositorio remoto en GitHub
git remote add origin "https://github.com/cdvelop/$folder_name.git"

# Envía los cambios al repositorio remoto
git push -u origin main

# Crea una etiqueta de versión
tag_name="v0.0.1"
git tag "$tag_name"

# Envía la etiqueta al repositorio remoto
git push origin "$tag_name"

echo -e "${COLOR_GREEN}El proyecto ha sido configurado, el repositorio remoto ha sido agregado en GitHub y se ha creado la etiqueta de versión $tag_name.${COLOR_RESET}"
