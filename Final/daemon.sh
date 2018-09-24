#! /bin/bash

ARRIBOS_PATH="$NOVEDADES"
ACEPTADOS_PATH="$ACEPTADOS"
RECHAZADOS_PATH="$RECHAZADOS"
SALIDA_PATH="$SALIDA"
PROCESADOS_PATH="$PROCESADOS"
ARCHIVO_OPERADORES="$MAESTROS/operadores.txt"
ARCHIVO_SUCURSALES="$MAESTROS/sucursales.txt"
CICLO=0
#while :
#do
	#Por cada archivo en el directorio de aceptados
	#Verifico que sean validos para procesar o los muevo a rechazados
	for f in "$ACEPTADOS_PATH"/* 
	do
	  echo "$(basename "$f")"
	  #Vars para verificar si archivo debe ser movido a rechazados
	  cantidad_lineas=-1 #no se porque me cuenta una linea de mas
	  codigo_postal_suma=0
	  trailer_cantidad_lineas=0
	  trailer_codigo_postal=0
	  #leo el archivo linea por linea
	  #verifico que el codigo postal y la cant de lineas sean las correctas
	  #sino, muevo el archivo a rechazados
	  while IFS=';' read -r  operador pieza nombre doc_tipo doc_numero codigo_postal;
	  do
		echo $cantidad_lineas
		echo $codigo_postal_suma
		let "cantidad_lineas=cantidad_lineas + 1"
		let "codigo_postal_suma=codigo_postal_suma + codigo_postal"
		echo "ultima linea" $doc_numero $codigo_postal
		trailer_codigo_postal=$codigo_postal
		trailer_cantidad_lineas=$doc_numero
		echo "traileres" $trailer_codigo_postal " " $trailer_cantidad_lineas
	  done < $f
	  echo "Total lineas" $cantidad_lineas
	  echo "Suma codigo postal" $codigo_postal_suma
	  #Comparo cantidad de lineas del archivo y suma codigo postal con los trailers
	  let "codigo_postal_suma=codigo_postal_suma -trailer_codigo_postal " #le resto porque me suma el ultimo dos veces
	  echo codigo_postal_suma
	  if [ $cantidad_lineas -eq $trailer_cantidad_lineas ] && [ $codigo_postal_suma -eq $trailer_codigo_postal ];
	  then
		echo $f " archivo valido"
		#loggear 
	  else
		echo $f " archivo invalido"
		mv $f $RECHAZADOS_PATH
		#loggear
	  fi	
	done
 	#Ya tengo los archivos validados, empiezo a procesesar
	#Es lo mismo que arriba, capaz conviene hacer todo en el mismo loop
	#PROCESANDO EL CONTENIDO DEL ARCHIVO
	for f in "$ACEPTADOS_PATH"/*
	do
	  echo "procesando archivo $(basename "$f")"
	  while IFS=';' read -r  operador pieza nombre doc_tipo doc_numero codigo_postal;
	  do
	  	#Verificar que el operador exista en archivo operadores
		if  grep -q $operador "$ARCHIVO_OPERADORES" ;
		then
			echo "operador " $operador " se encuentra en archivo de operadores" 
		else
			echo "operador " $operador " no se encuentra en el archivo de operadores"
		fi
		#verificar que operador codigo postal en sucursales
		if  grep -q "$operador\|$codigo_postal" "$ARCHIVO_SUCURSALES" ;
		then
			echo "operador y codigo postal " $operador "-" $codigo_postal " se encuentra en archivo de sucursales" 
		else
			echo "operador " $operador "-" $codigo_postal " no se encuentra en el archivo de sucursales"
		fi
		#verificar operador vigente

		#si ok, genero o agrego a archivo correspondiente y escribo registro en el archivo
		#completo con ceros
		printf -v pieza '%020d' $pieza
	        nombre=$(echo $nombre | awk '$1=$1')
		#completo con espacios
	       	printf -v nombre_pad '%50s' $nombre
		printf -v doc_numero '%011d' $doc_numero
		archivo=$(basename "$f")
	        codigo_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $1 } }' "$ARCHIVO_SUCURSALES")
		suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $2 } }' "$ARCHIVO_SUCURSALES")
	        direccion_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{if($6 == codigo) {print $3 } }' "$ARCHIVO_SUCURSALES")
		costo_entrega=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $8 } }' "$ARCHIVO_SUCURSALES")
		printf -v costo_entrega '%06d' $costo_entrega
		echo $pieza"$nombre_pad"$doc_tipo$doc_numero$codigo_postal$codigo_suc_destino$suc_destino$direccion_suc_destino$costo_entrega$archivo >> $SALIDA_PATH/"Entregas_"$operador
	  done < $f
	  #Fin proceso, mover archivo a procesado
	  #mv $f $PROCESADOS_PATH

	done

	let "CICLO=CICLO+1"
	echo "Numero de ciclo: " $CICLO
	#sleep 1m
#done
