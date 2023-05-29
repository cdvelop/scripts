#!/bin/bash

# Concatena los parámetros en una sola cadena
commit_message="$*"

# Colores
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

if [ -f "go.mod" ]; then
  echo -e "${YELLOW}=> Ejecutando 'go mod tidy'...${RESET}"
  go mod tidy
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}=> 'go mod tidy' completado correctamente.${RESET}"
  else
    echo -e "${RED}=> Error: 'go mod tidy' ha fallado.${RESET}"
    exit 1
  fi
fi

echo -e "${YELLOW}=> Añadiendo cambios a Git...${RESET}"
git add .
if [ $? -eq 0 ]; then
  echo -e "${GREEN}=> Cambios añadidos correctamente a Git.${RESET}"
else
  echo -e "${RED}=> Error al añadir cambios a Git.${RESET}"
  exit 1
fi

echo -e "${YELLOW}=> Creando nuevo commit...${RESET}"
git commit -m "$commit_message"
if [ $? -eq 0 ]; then
  echo -e "${GREEN}=> Nuevo commit creado correctamente.${RESET}"
else
  echo -e "${RED}=> Error al crear el nuevo commit.${RESET}"
  exit 1
fi

# Obtén la última etiqueta
latest_tag=$(git describe --abbrev=0 --tags)
echo -e "${YELLOW}=> Version Anterior: $latest_tag${RESET}\n"

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

echo -e "${YELLOW}=> Commit: $commit_message\n${RESET}"


# Crear una nueva etiqueta con la versión proporcionada.
echo -e "${YELLOW}=> Creando nueva etiqueta: $new_tag...${RESET}"
git tag "$new_tag"
if [ $? -eq 0 ]; then
  echo -e "${GREEN}=> Nueva etiqueta creada correctamente.${RESET}"
else
  echo -e "${RED}=> Error al crear la nueva etiqueta.${RESET}"
  exit 1
fi

# Empujar los cambios y la nueva etiqueta a remoto.
echo -e "${YELLOW}=> Empujando cambios a remoto...${RESET}"
git push && git push origin "$new_tag"
if [ $? -eq 0 ]; then
  echo -e "${GREEN}=> Cambios y nueva etiqueta $new_tag enviados a remoto.${RESET}"
else
  echo -e "${RED}=> Error al empujar los cambios y la nueva etiqueta a remoto.${RESET}"
  exit 1
fi

# Verifica si existe el archivo go.mod
if [ -f "go.mod" ]; then

  # Buscar y extraer el nombre del paquete actual
  pkg_updated=$(gawk -v pattern=github.com/cdvelop/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' go.mod)
  echo -e "${YELLOW}Paquete Actualizado: $pkg_updated${RESET}"

  bash go-mod-update.sh $pkg_updated $new_tag 

fi