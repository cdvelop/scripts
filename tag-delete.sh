#!/bin/bash

  tag=$1

  # Elimina la etiqueta localmente
  git tag -d "$tag"
  
  # Elimina la etiqueta en el repositorio remoto
  git push origin --delete "$tag"

