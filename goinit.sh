#!/bin/bash

source functions.sh

# obtener el nombre de la carpeta actual
current_folder=$(basename "$(pwd)")

if [ ! -f "go.mod" ]; then
 execute "go mod init $repository/$current_folder" "no se inicializó go mod" "-go mod iniciado"
fi

# crear archivo go único new.go
struct="handler"

# Definir la estructura y la función
model="type $struct struct {}"
func="func New() (*$struct) {\n\nh := &$struct{}\n\n return h\n}"

# Crea o sobrescribe new.go con el contenido completo
execute "echo -e 'package $current_folder\n\n$model\n\n$func' > new.go" 'al crear fichero new.go'

bash init.sh