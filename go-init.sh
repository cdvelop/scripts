#!/bin/bash

# obtener el nombre de la carepta actual
current_folder=$(basename "$(pwd)")
go mod init github.com/cdvelop/$current_folder
