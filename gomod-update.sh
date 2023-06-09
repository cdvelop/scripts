#!/bin/bash

source functions.sh

# Verificar si se proporcionaron dos parámetros
if [ "$#" -ne 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
  error "Se requieren nombre de paquete y versión ej: mipkg v0.0.2"
  exit 1
fi

# paquete a actualizar
pkg_updated=$1
# version nueva
new_tag=$2

# directorio usuario
username=$(whoami)
# Buscar y actualizar paquetes en el directorio "\Packages\go"
go_pkgs="/c/Users/$username/Packages/go"

if [ -d $go_pkgs ]; then
   
    for observed_pkg in "$go_pkgs"/*; do
         
      # Verificar que el paquete no sea el actualizado recientemente
      if [ "$(basename "$observed_pkg")" != "$pkg_updated" ]; then
        
        go_mod_file="$observed_pkg/go.mod"

        if [ -f "$go_mod_file" ]; then
          
          # Obtener el nombre del paquete observado
          observed_pkg_name=$(gawk -v pattern=$repository/ 'NR==1 && match($0, pattern "([^/]+)", arr) { print arr[1] }' $go_mod_file)
            
          old_tag=$(gawk -v package="$pkg_updated" -v common="$repository" 'match($0, "^require[[:space:]]+" common "/" package "[[:space:]]+([^[:space:]]+)", tag) {print tag[1]; exit} $1==common "/" package {print $2}' "$go_mod_file")

            # Verificar si la variable old_tag no está vacía
            if [ -z "$old_tag" ]; then
                continue
            fi

            # Comparar la versión del paquete observado con la nueva versión
            if [ "$old_tag" != "$new_tag" ]; then
              current_dir=$(pwd)
              cd "$observed_pkg"
                
                execute "go get $repository/$pkg_updated@$new_tag" "no se actualizo paquete $pkg_updated en $observed_pkg_name" "paquete $pkg_updated actualizado en $observed_pkg_name ok"
                
                bash gomod-check.sh
                if [ $? -eq 0 ]; then # Verificar si es 0 subimos los cambios

                  bash pu.sh "update module: $pkg_updated"

                fi

              cd "$current_dir"
            fi
        fi
      fi
    done
fi
successMessages
exit 0
