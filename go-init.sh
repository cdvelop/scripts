#!/bin/bash

# obtener el nombre de la carepta actual
current_folder=$(basename "$(pwd)")


if [ ! -f "go.mod" ]; then

 go mod init github.com/cdvelop/$current_folder



fi