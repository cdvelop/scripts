#!/bin/bash

# Concatena los parámetros en una sola cadena
commit_message="$*"

# Colores
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# commit_message no esta vacío.
if [ -n "$commit_message" ]; then

  echo -e "${YELLOW}=> Añadiendo cambios a Git...${NC}"
  git add .
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}=> Cambios añadidos correctamente a Git.${NC}"
  else
    echo -e "${RED}=> Error al añadir cambios a Git.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}=> Creando nuevo commit...${NC}"
  git commit -m "$commit_message"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}=> Nuevo commit creado correctamente.${NC}"
  else
    echo -e "${RED}=> Error al crear el nuevo commit.${NC}"
    exit 1
  fi

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


  # Crear una nueva etiqueta con la versión proporcionada.
  echo -e "${YELLOW}=> Creando nueva etiqueta: $new_tag...${NC}"
  git tag "$new_tag"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}=> Nueva etiqueta creada correctamente.${NC}"
  else
    echo -e "${RED}=> Error al crear la nueva etiqueta.${NC}"
    exit 1
  fi

  # Empujar los cambios y la nueva etiqueta a remoto.
  echo -e "${YELLOW}=> Empujando cambios a remoto...${NC}"
  git push && git push origin "$new_tag"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}=> Cambios y nueva etiqueta $new_tag enviados a remoto.${NC}"
  else
    echo -e "${RED}=> Error al empujar los cambios y la nueva etiqueta a remoto.${NC}"
    exit 1
  fi


 else
  echo -e "${YELLOW}=> Mensaje commit vacio. Push no ejecutado.${NC}"
fi