#!/bin/bash

source functions.sh

# obtener el nombre de la carepta actual
current_folder=$(basename "$(pwd)")


if [ ! -f "go.mod" ]; then

 execute "go mod init $repository/$current_folder" "no se inicializo go mod" "-go mod iniciado"

fi

bash init.sh