#!/bin/bash

source functions.sh

# Obtén el nombre de la carpeta actual
current_folder=$(basename "$(pwd)")

# Verifica si el directorio ya está inicializado con Git
if [ -d ".git" ]; then
   warning "El directorio: $current_folder ya está inicializado con Git"
    exit 1
fi

execute "echo '# $current_folder' >> README.md" 'al crear readme'

execute "git init" "git init" "repositorio git inicializado"

execute "git branch -M main" "branch"

execute "git add ." "al añadir cambios a Git."

execute "git commit -m 'Primer commit'" 'commit'

execute "git remote add origin https://$repository/$current_folder.git" "remote add origin" "repositorio remoto agregado"

execute "git push -u origin main" "push"

# Crea una etiqueta de versión
tag_name="v0.0.1"

execute "git tag $tag_name" "etiqueta" "etiqueta creada: $tag_name"

execute "git push origin $tag_name" "push origin" "Proyecto git configurado, repositorio $current_folder agregado a GitHub"

successMessages

exit 0