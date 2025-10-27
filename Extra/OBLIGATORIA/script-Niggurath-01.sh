#!/bin/bash

# ------------------------------------------------------------------------------------
#   A medida que nos internamos en Arkham vamos conociendo a los habitantes
# de esta oscura ciudad. Una de las pistas que estábamos siguiendo nos lleva
# hasta Thelonius Wolf, un criador de perros de la raza husky, que roporciona
# perros guardianes a muchas de las casa de Arkham para protegerlas durante
# las noches.

#   Este criador está especialmente pendiente del número de cachorros en las
# camadas, ya que cuando el número de cachorros que nacen de una perra es
# múltiplo de 3 debe ofrecer un pequeño ritual a lo que él llama : La Negra
# Cabra de los Bosques con sus Diez Mil Vástagos.


#   Debemos crear un Script que genere un número aleatorio de cachorros (ver
# fragmento del SCRIPT más adelante para obtener pistas), por cada uno de
# los dias del año (no importa si es bisiesto).

#   Además debemos contar cuantas veces se ha cumplido la maldición de
# Shub-Niggurath a lo largo del año, según lo descrito anteriormente,
# mostrando al final del Script cuantas veces se ha ido realizando.

#   El Ritual de Expiación consiste en mostrar por pantalla cuantos Cachorros
# han nacido este año en TOTAL, hasta ese momento.


#   Además es importante tener en cuenta que si el día en el que nacen los
# cachorros es luna llena, no se debe realizar el ritual, sino que debe
# mostrar el mensaje:

#   SALVADOS POR LA CABRA, SALVADOS POR SHUB-NIGGURATH

#   Podéis tener en cuenta que el día 1 de Enero siempre es luna llena.
# ------------------------------------------------------------------------------------

clear

# El script consiste en crear un fichero con los números aleatorios generados durante
# cada día del año, es decir, un número aleatorio del 1 al 9 -> 365 veces.
# Para que sea más facil leerlo y consultarlo se creará un fichero el cual luego se le
# hará un cat -n del mismo (-n muestra las líneas del fichero).
if [ -e ./listado-Niggurath.txt ]; then
  rm listado-Niggurath.txt # Eliminamos el archivo para asegurarnos de que los datos se borran
  touch listado-Niggurath.txt
else
  touch listado-Niggurath.txt
fi

# Ahora generaremos el bucle para que muestre un número aleatorio 365 veces. Para ello
# declaramos una variable que ejecute el numero aleatorio, y luego al final de la línea
# añadimos el número con un echo sin sobreescribir el contenido del fichero.

# También añadiremos la variable $total para contar todos los cachorros y luego añadirlo
# al final del fichero.
objetivo=0
total=0
while [ $objetivo -lt "365" ]; do
  objetivo=$(($objetivo + 1))
  NUMERO_CACHORROS=$((1 + $RANDOM% 9)) # Esto lo que hace es elegir un número aleatorio entre ``posición`` 1 y 9, es decir entre 0 y 8. Por lo que se le añade al principio un +1 para que sea entre el 1 y el 9 o `posición` 2 y 10.

# Comprobación de calendario lunar (luna llena) 2025.
  if [ $objetivo == 12 ] || [ $objetivo == 43 ] || [ $objetivo == 73 ] || [ $objetivo == 103 ] || [ $objetivo == 132 ] || [ $objetivo == 162 ] || [ $objetivo == 191 ] || [ $objetivo == 221 ] || [ $objetivo == 250 ] || [ $objetivo == 280 ] || [ $objetivo == 309 ] || [ $objetivo == 338 ]; then
    NUMERO_CACHORROS=0
    echo "¡¡¡SALVADOS POR LA CABRA, SALVADOS POR SHUB-NIGGURATH!!!" >> listado-Niggurath.txt
  else
  # En el siguiente if comprobaremos que los números sean múltiplos de 3.
    if [ $(($NUMERO_CACHORROS % 3)) -eq 0 ]; then
      echo "|  Día: $objetivo || Cachorros: $NUMERO_CACHORROS || **ESTE ES MÚLTIPLO DE 3**" >> listado-Niggurath.txt
    else
      echo "|  Día: $objetivo || Cachorros: $NUMERO_CACHORROS" >> listado-Niggurath.txt
    fi
  fi

# Aqui es donde se van haciendo la suma de los cachorros:
  total=$(($total + $NUMERO_CACHORROS))
done

echo "" >> listado-Niggurath.txt
echo "|  TOTAL CACHORROS: $total" >> listado-Niggurath.txt
cat listado-Niggurath.txt

exit 0
