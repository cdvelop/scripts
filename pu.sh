#!/bin/bash
source functions.sh

# Este script genera una etiqueta con un número correlativo cambiando solo el último
# dígito del tag ej v5.4.2 el siguiente será v5.4.3

current_folder=$(basename "$(pwd)")

# Concatena los parámetros en una sola cadena
commit_message="$*"

# Comprueba si el archivo "changes.txt" existe
if [ -f "changes.txt" ] && [ -s "changes.txt" ]; then
    # Lee el contenido del archivo
    changes_content=$(cat changes.txt)
    if [ -n "$commit_message" ]; then
        # Concatena los contenidos del archivo y los parámetros
        commit_message="$commit_message $changes_content"
    else
        commit_message=$changes_content
    fi   
fi

# Si commit_message está vacío, asigna un valor predeterminado
if [ -z "$commit_message" ]; then
    commit_message="auto update package"
fi

# Agrega cambios al índice
execute "git add ." "Error al añadir cambios a Git $current_folder." "cambios $current_folder añadidos"

# Realiza el commit solo si hay cambios
if git diff-index --quiet HEAD --; then
    echo "No hay cambios que commitear."
else
    execute "git commit -m '$commit_message'" "Error al crear el nuevo commit $current_folder."
fi

# Obtén la última etiqueta
latest_tag=$(git describe --abbrev=0 --tags 2>/dev/null)

if [ -z "$latest_tag" ]; then
    # Si no existe ninguna etiqueta, establece la etiqueta inicial en v0.0.1
    new_tag="v0.0.1"
else
    # Extrae el número de la etiqueta
    last_number=$(echo "$latest_tag" | grep -oE '[0-9]+$')

    # Incrementa el número en uno
    next_number=$((last_number + 1))

    # Construye la nueva etiqueta
    new_tag=$(echo "$latest_tag" | sed "s/$last_number$/$next_number/")
fi

execute "git tag $new_tag" "Error al crear la nueva etiqueta $current_folder." "nueva etiqueta $new_tag"

# Verifica si la rama tiene upstream configurado
branch=$(git symbolic-ref --short HEAD)
upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{u} 2>/dev/null)

if [ -z "$upstream" ]; then
    # Si no hay upstream, configura el upstream y haz push
    execute "git push --set-upstream origin $branch && git push origin $new_tag" \
    "Error al empujar los cambios y la nueva etiqueta a remoto $current_folder." \
    "Commit y Push $current_folder..."
else
    # Si ya tiene upstream, simplemente haz push
    execute "git push && git push origin $new_tag" \
    "Error al empujar los cambios y la nueva etiqueta a remoto $current_folder." \
    "Commit y Push $current_folder..."
fi

# Imprimir los mensajes acumulados
successMessages
deleteChangesFileContent
exit 0
