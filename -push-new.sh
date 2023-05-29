#!/bin/bash

# Concatena los parámetros en una sola cadena
commit_message="$*"

# Variable para almacenar los mensajes de éxito
success_message=""

# Función para mostrar un mensaje de error
print_error() {
  echo -e "\033[0;31mError: $1\n\033[0m" #color rojo
  echo -e "\033[0;31m$2\n\033[0m" #color rojo
}

# Función para mostrar un mensaje de éxito
print_success() {
  echo -e "\033[0;32m$1\033[0m" # color verde
}

# Función para realizar una acción y mostrar un mensaje de error en caso de fallo
perform_action() {
 output=$(eval "$1" 2>&1)

  if [ $? -ne 0 ]; then
    print_error "$2" $output
    exit 1
  else
    success_message+=" $3"  # Concatenar el mensaje de éxito a la variable success_message
  fi
}

# commit_message no está vacío.
if [ -n "$commit_message" ]; then

  perform_action "git add ." "Error al añadir cambios a Git." "Cambios añadidos."
  perform_action "git commit -m \"$commit_message\"" "Error al crear el nuevo commit." "Commit creado."

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

  perform_action "git tag $new_tag" "Error al crear la nueva etiqueta." "Etiqueta agregada."
  perform_action "git push && git push origin $new_tag" "Error al empujar los cambios y la nueva etiqueta a remoto." "Cambios y etiqueta $new_tag enviados a remoto."

else
  print_error "Mensaje commit vacío. Push no ejecutado."
  exit 1
fi

# Imprimir los mensajes acumulados en success_message
print_success "$success_message"

exit 0
