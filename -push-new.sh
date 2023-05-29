#!/bin/bash

# Concatena los parámetros en una sola cadena
commit_message="$*"

# Colores
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Variable para realizar un seguimiento de los errores
has_error=false

# Función para mostrar un mensaje de error y marcar el seguimiento de errores como verdadero
print_error() {
  echo -e "${RED}$1${NC}"
  has_error=true
}

# Función para mostrar un mensaje de éxito
print_success() {
  echo -e "${GREEN}$1${NC}"
}

# Función para realizar una acción y mostrar el mensaje de éxito o error correspondiente
perform_action() {
  echo -e "${YELLOW}=> $1...${NC}"
  eval "$2"
  if [ $? -eq 0 ]; then
    print_success "$3"
  else
    print_error "$4"
  fi
}

# commit_message no está vacío.
if [ -n "$commit_message" ]; then

  perform_action "Añadiendo cambios a Git" "git add ." "Cambios añadidos correctamente a Git." "Error al añadir cambios a Git."
  perform_action "Creando nuevo commit" "git commit -m \"$commit_message\"" "Nuevo commit creado correctamente." "Error al crear el nuevo commit."

  # Obtén la última etiqueta
  latest_tag=$(git describe --abbrev=0 --tags)
  echo -e "${YELLOW}=> Version Anterior: $latest_tag${NC}\n"

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

  echo -e "${YELLOW}=> Commit: $commit_message\n${NC}"

  perform_action "Creando nueva etiqueta: $new_tag" "git tag \"$new_tag\"" "Nueva etiqueta creada correctamente." "Error al crear la nueva etiqueta."
  perform_action "Empujando cambios a remoto" "git push && git push origin \"$new_tag\"" "Cambios y nueva etiqueta $new_tag enviados a remoto." "Error al empujar los cambios y la nueva etiqueta a remoto."

else
  echo -e "${YELLOW}=> Mensaje commit vacío. Push no ejecutado.${NC}"
  exit 1  # error
fi

# Mostrar un resumen de las acciones realizadas y verificar si hubo errores
if [ "$has_error" = true ]; then
  exit 1  # Establecer código de salida como 1 en caso de error
else
  exit 0  # Establecer código de salida como 0 en caso de éxito
fi