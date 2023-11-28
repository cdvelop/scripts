#!/bin/bash

source functions.sh

# obtener el nombre de la carpeta actual
current_folder=$(basename "$(pwd)")


if [ ! -f "go.mod" ]; then

 execute "go mod init $repository/$current_folder" "no se inicializo go mod" "-go mod iniciado"

fi

# crear archivos básicos go

# Convertir la primera letra en mayúscula
struct="${current_folder^}"

func="func Add() (x *$struct, err string) {\n\nx = &$struct{}\n\n return x,""\n}"

execute "echo -e 'package $current_folder\n\n$func' >> add.go" 'al crear fichero add.go'

model="type $struct struct {}"

execute "echo -e 'package $current_folder\n\n$model' >> model.go" 'al crear fichero model.go'


bash init.sh