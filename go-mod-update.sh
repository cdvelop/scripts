#!/bin/bash

# Colores
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

# repositorio
REPO="github.com/cdvelop"


# Verificar si se proporcionaron dos parámetros
if [ "$#" -ne 2 ]; then
  echo -e "${RED}Error: Se requieren nombre paquete y version. ej mipkg v0.0.2 ${RESET}"
  exit 1
fi

# paquete a actualizar
pkg_updated=$1
# version nueva
new_tag=$2

# directorio usuario
 username=$(whoami)
# directorio paquetes go
go_pkgs="/c/Users/$username/Packages/go"

  # Buscar y actualizar paquetes en el directorio "\Packages\go"
if [ -d $go_pkgs ]; then

    for observed_pkg in "$go_pkgs"/*; do
    #    echo -e "${YELLOW}"$(basename "$observed_pkg")" paquete observado ruta: $observed_pkg\n${RESET}"
      # Verificar que el paquete no sea el actualizado recientemente
      if [ "$(basename "$observed_pkg")" != "$pkg_updated" ]; then
        
        go_mod_file="$observed_pkg/go.mod"
       
        if [ -f "$go_mod_file" ]; then
          # Obtener el nombre del paquete observado
          observed_pkg_name=$(gawk -v pattern=$REPO/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' $go_mod_file)
            
            old_tag=$(gawk -v package="$pkg_updated" -v common="$REPO" 'match($0, "^require[[:space:]]+" common "/" package "[[:space:]]+([^[:space:]]+)", tag) {print tag[1]; exit} $1==common "/" package {print $2}' "$go_mod_file")

            # Verificar si la variable old_tag está vacía
            if [ -z "$old_tag" ]; then
            continue
            fi
                       
            # Comparar la versión del paquete observado con la nueva versión
            if [ "$old_tag" != "$new_tag" ]; then
              echo -e "${YELLOW}=> Actualizando paquete: $observed_pkg_name modulo: $pkg_updated ver anterior: $old_tag nueva: $new_tag${RESET}"
              current_dir=$(pwd)
              cd "$observed_pkg"
              go get "$REPO/$pkg_updated@$new_tag"
              go mod tidy
              if [ $? -eq 0 ]; then
                echo -e "${GREEN}=> Paquete $pkg_updated actualizado correctamente en: $observed_pkg_name.${RESET}"
              
              
              
              else
                echo -e "${RED}=> Error al actualizar paquete: $pkg_updated en: $observed_pkg_name${RESET}"
              fi
              cd "$current_dir"
            fi
        fi
      fi
    done

fi