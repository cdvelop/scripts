#!/bin/bash

# repositorio
REPO="github.com/cdvelop"
#obtenemos el nombre del modulo go
go_mod_name=$(gawk -v pattern=$REPO/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' go.mod)

GREEN='\033[0;32m'  # Código de escape ANSI para el color verde
YELLOW='\033[0;33m'  # Código de escape ANSI para el color amarillo
RED='\033[0;31m'  # Código de escape ANSI para el color rojo
NC='\033[0m'  # Código de escape ANSI para reiniciar el color

# Variables para contar los resultados
vet_errors=0
test_errors=0
race_warning=0
push_executed=0

# Verificar el código del módulo con go vet
vet_output=$(go vet 2>&1)
vet_exit_code=$?

if [ $vet_exit_code -ne 0 ]; then
  echo -e "${RED}Hubo errores en el código.${NC}"
  echo -e "${RED}$vet_output${NC}"
  vet_errors=1
fi

if [ $vet_exit_code -eq 0 ]; then

  # Ejecutar pruebas con go test
  test_output=$(go test 2>&1)
  test_exit_code=$?

  if [ $test_exit_code -ne 0 ]; then
    echo -e "${RED}Hubo errores en las pruebas.${NC}"
    echo -e "${RED}$test_output${NC}"
    test_errors=1
  fi

  # Buscar y ejecutar tests en carpetas con "test" en su nombre
  test_folders=$(find -type d -name "*test*")
  for folder in $test_folders; do
    folder_output=$(go test "$folder" 2>&1)
    folder_exit_code=$?
    
    if [ $folder_exit_code -ne 0 ]; then
      echo -e "${RED}Hubo errores en las pruebas carpeta $folder.${NC}"
      echo -e "${RED}$folder_output${NC}"
      test_errors=1
    fi
  done

  # Ejecutar prueba de carrera de datos con go run
  race_output=$(go run -race "$go_mod_name" 2>&1)

  if [[ $race_output == *"WARNING: DATA RACE"* ]]; then
    echo -e "${YELLOW}$race_output${NC}"
    race_warning=1
  fi

fi


echo -e "${YELLOW}=== Resumen paquete $go_mod_name ===${NC}"
echo -e "Errores en go vet: ${RED}$vet_errors${NC}"
echo -e "Errores en las pruebas: ${RED}$test_errors${NC}"
echo -e "Advertencias de carrera de datos: ${YELLOW}$race_warning${NC}"
echo -e "${YELLOW}==============================${NC}"

# Ejecutar script -push.sh
if [ $vet_errors -eq 0 ] && [ $test_errors -eq 0 ]; then
  echo -e "${GREEN}Ejecutando -push.sh con paquete: $go_mod_name${NC}"
#   ./go-push.sh pkg_name

fi

