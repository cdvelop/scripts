
# Variable para almacenar los mensajes de éxito
success_message=""

# Función para mostrar un mensaje de error
error() {
  echo -e "\033[0;31mError: $1\n\033[0m" #color rojo
  echo -e "\033[0;31m$2\n\033[0m" #color rojo
}

# Función para mostrar un mensaje de éxito
success() {
  echo -e "\033[0;32m$1\033[0m" # color verde
}

warning() {
  echo -e "\033[0;33m$1\033[0m" # color amarillo
}

# Función para realizar una acción y mostrar un mensaje de error en caso de fallo
execute() {
 output=$(eval "$1" 2>&1)

  if [ $? -ne 0 ]; then
    print_error "$2" $output
    exit 1
  else
    success_message+=" $3"  # Concatenar el mensaje de éxito a la variable success_message
  fi
}