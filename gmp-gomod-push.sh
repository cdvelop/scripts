#!/bin/bash

# Concatena los parámetros en una sola cadena
commit_message="$*"

  # repositorio
  REPO="github.com/cdvelop"

  GREEN='\033[0;32m'  # Código de escape ANSI para el color verde
  YELLOW='\033[0;33m'  # Código de escape ANSI para el color amarillo
  RED='\033[0;31m'  # Código de escape ANSI para el color rojo
  NC='\033[0m'  # Código de escape ANSI para reiniciar el color

if [ -f "go.mod" ]; then
  #obtenemos el nombre del modulo go
  go_mod_name=$(gawk -v pattern=$REPO/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' go.mod)
  
  # Variables para contar los resultados
  tidy_error=0
  vet_error=0
  test_error=0
  race_warning=0

  tidy_output=$(go mod tidy 2>&1)
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error: 'go mod tidy' en $go_mod_name ha fallado.${NC}"
    echo -e "${RED}$tidy_output${NC}"
    tidy_error=1
  fi

  if [ $tidy_error -eq 0 ]; then

    # Verificar el código del módulo con go vet
    vet_output=$(go vet 2>&1)
    if [ $? -ne 0 ]; then
      echo -e "${RED}Hubo errores en el código.${NC}"
      echo -e "${RED}$vet_output${NC}"
      vet_error=1
    fi

    if [ $vet_error -eq 0 ]; then

      # Ejecutar pruebas con go test
      test_output=$(go test 2>&1)
      if [ $? -ne 0 ]; then
        echo -e "${RED}Hubo errores en las pruebas.${NC}"
        echo -e "${RED}$test_output${NC}"
        test_error=1
      fi

      # Buscar y ejecutar tests en carpetas con "test" en su nombre
      test_folders=$(find -type d -name "*test*")
      for folder in $test_folders; do
        folder_output=$(go test "$folder" 2>&1)    
        if [ $? -ne 0 ]; then
          echo -e "${RED}Hubo errores en las pruebas carpeta $folder.${NC}"
          echo -e "${RED}$folder_output${NC}"
          test_error=1
        fi
      done

      # Ejecutar prueba de carrera de datos con go run
      race_output=$(go run -race "$go_mod_name" 2>&1)
      if [[ $race_output == *"WARNING: DATA RACE"* ]]; then
        echo -e "${YELLOW}$race_output${NC}"
        race_warning=1
      fi
    fi
  fi

  echo -e "${YELLOW}=== Resumen paquete $go_mod_name ===${NC}"
  echo -e "Errores en go vet: ${RED}$vet_error${NC}"
  echo -e "Errores en las pruebas: ${RED}$test_error${NC}"
  echo -e "Advertencias de carrera de datos: ${YELLOW}$race_warning${NC}"
  echo -e "${YELLOW}==============================${NC}"

  # Ejecutar -push.sh
  if [ $tidy_error -eq 0 ] &&  [ $vet_error -eq 0 ] && [ $test_error -eq 0 ]; then
  
    if [ -z "$commit_message" ]; then
      echo "La cadena commit está vacía."
      else
      echo -e "${YELLOW}=>commit: $commit_message push run paquete: $go_mod_name${NC}"
       # bash -push.sh $commit_message
    
     #bash go-mod-update.sh $pkg_updated $new_tag 
    fi

  fi

fi