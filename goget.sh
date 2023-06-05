#!/bin/bash

source functions.sh

package=$1
tag_version=$2


execute "go get $repository/$1@$2" "al obtener paquete $package" "$package actualizado ok"

execute "go mod tidy" "go mod tidy ha fallado" "go mod tidy ok"

