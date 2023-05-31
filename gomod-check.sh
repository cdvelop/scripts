#!/bin/bash

source functions.sh

if [ -f "go.mod" ]; then
  #obtenemos el nombre del modulo go
  go_mod_name=$(gawk -v pattern=$repository/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' go.mod)
  
  execute "go mod tidy" "go mod tidy en $go_mod_name ha fallado" "go mod tidy $go_mod_name ok"

  execute "go vet" "go vet en $go_mod_name ha fallado" "go vet $go_mod_name ok"

  execute "go test" "Hubo errores en las pruebas en $go_mod_name" "root test $go_mod_name ok"
  
  # Buscar carpetas que contengan nombre test y ejecutar tests
  test_folders=$(find -type d -name "*test*")
  for folder in $test_folders; do
     if [ -n "$(find $folder -type f -name "*_test.go")" ]; then
      execute "go test $folder" "Hubo errores en las pruebas carpeta $folder en $go_mod_name" "$go_mod_name carpeta: $folder test ok"
     fi   
  done

  # Ejecutar prueba de carrera de datos con go run
  race_output=$(go run -race "$go_mod_name" 2>&1)
  if [[ $race_output == *"WARNING: DATA RACE"* ]]; then
    warning "$race_output"
  fi
  
  successMessages
  exit 0
fi

exit 1
