# repositorio
repository="github.com/cdvelop"

# Variable para almacenar los mensajes de éxito
message=""

# Función para mostrar un mensaje de error
error() {
  echo -e "\033[0;31mError: $1 $2\033[0m" #color rojo
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
    error "$2" "$output"
    exit 1
  else
    # Concatenar el mensaje de éxito a la variable message si es enviada
    if [ -n "$3" ]; then
      symbol="\033[0;33m▶\033[0m"  # Símbolo naranja: ▶
      text="\033[0;32m$3\033[0m"  # Texto verde
      message+="\n$symbol $text"  # Concatenar el mensaje de éxito con el símbolo y el texto
    fi
  fi
}

# Imprimir los mensajes acumulados
successMessages(){
  echo -e "$message"
  mensaje=""
}