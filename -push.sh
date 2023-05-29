#!/bin/bash

source funtion.sh

# Concatena los parámetros en una sola cadena
commit_message="$*"


# commit_message no está vacío.
if [ -n "$commit_message" ]; then

  execute "git add ." "Error al añadir cambios a Git." "-cambios añadidos."
  execute "git commit -m \"$commit_message\"" "Error al crear el nuevo commit." "-commit: $commit_message"

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

  execute "git tag $new_tag" "Error al crear la nueva etiqueta." "-etiqueta $new_tag agregada"
  execute "git push && git push origin $new_tag" "Error al empujar los cambios y la nueva etiqueta a remoto." "Commit y Push Ok."

else
  error "Mensaje commit vacío. Push no ejecutado."
  exit 1
fi

# Imprimir los mensajes acumulados en success_message
success "$success_message"

exit 0
