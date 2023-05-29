#!/bin/bash

package=$1
tag_version=$2

# obtener paquete
go get github.com/cdvelop/$1@$2

# Ejecutar el comando "go mod tidy" para actualizar los módulos Go.
go mod tidy