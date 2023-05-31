#!/bin/bash

source functions.sh

# este script genera una etiqueta con un numero correlativo cambiando solo el ultimo
# dígito del tag ej v5.4.2 el siguiente sera v5.4.3 

current_folder=$(basename "$(pwd)")

# Concatena los parámetros en una sola cadena
commit_message="$*"

# commit_message no está vacío.
if [ -n "$commit_message" ]; then

  execute "git add ." "Error al añadir cambios a Git $current_folder." "cambios $current_folder añadidos"
  execute "git commit -m '$commit_message'" "al crear el nuevo commit $current_folder."

  # Obtén la última etiqueta
  latest_tag=$(git describe --abbrev=0 --tags)

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

  execute "git tag $new_tag" "al crear la nueva etiqueta $current_folder." "nueva etiqueta $new_tag"
  execute "git push && git push origin $new_tag" "al empujar los cambios y la nueva etiqueta a remoto $current_folder." "Commit y Push $current_folder Ok..."

else
  error "Mensaje commit vacío. Push $current_folder no ejecutado."
  exit 1
fi

# Imprimir los mensajes acumulados
successMessages
exit 0
