#!/bin/bash

source functions.sh

# obtener el nombre de la carpeta actual
current_folder=$(basename "$(pwd)")


if [ ! -f "go.mod" ]; then

 execute "go mod init $repository/$current_folder" "no se inicializo go mod" "-go mod iniciado"

fi

# crear archivos básicos go

struct="handler"
# Convertir la primera letra en mayúscula
# struct="${current_folder^}"

# Almacenar la primera letra en minúscula de struct en la variable x
x=$(echo "$current_folder" | cut -c1)

func="func New() (*$struct) {\n\nh := &$struct{}\n\n return h\n}"


execute "echo -e 'package $current_folder\n\n$func' >> new.go" 'al crear fichero new.go'

model="type $struct struct {}"

execute "echo -e 'package $current_folder\n\n$model' >> model.go" 'al crear fichero model.go'


bash init.sh