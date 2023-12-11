#!/bin/bash

source functions.sh

# obtener el nombre de la carpeta actual
current_folder=$(basename "$(pwd)")

model_pkg="$repository/model"

if [ ! -f "go.mod" ]; then

 execute "go mod init $repository/$current_folder" "no se inicializo go mod" "-go mod iniciado"

fi

# crear archivos básicos go

# Convertir la primera letra en mayúscula
struct="${current_folder^}"

# Almacenar la primera letra en minúscula de struct en la variable x
x=$(echo "$current_folder" | cut -c1)

func="func Add(h* model.Handlers) ($x *$struct, err string) {\n\n$x = &$struct{}\n\n return $x,\"\"\n}"

imports="\nimport \"$model_pkg\"\n\n"

execute "echo -e 'package $current_folder\n\n $imports $func' >> add.go" 'al crear fichero add.go'

model="type $struct struct {}"

execute "echo -e 'package $current_folder\n\n$model' >> model.go" 'al crear fichero model.go'

execute "echo '' >> go.mod" 'al agregar salto de linea en go.mod'

execute "echo 'replace $model_pkg => ../model' >> go.mod" 'al agregar replace model.go en go.mod'

execute "go get $model_pkg" "al obtener paquete $model_pkg"

bash init.sh