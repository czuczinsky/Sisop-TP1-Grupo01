#! /bin/bash

ARRIBOS_PATH="arribos"
ACEPTADOS_PATH="aceptados"
RECHAZADOS_PATH="rechazados"
SALIDA_PATH="salida"
PROCESADOS_PATH="procesados"
ARCHIVO_OPERADORES="maestros/operadores.txt"
ARCHIVO_SUCURSALES="maestros/sucursales.txt"
CICLOS=0
#while :
#do
	#Mando a rechazados todos los archivos que no cumplan con el formato de entrega_mesMenorOIgualAlCorriente
	MES=`date +"%m"`
	MES=$(expr $MES + 0 )
	#MES=5
	if (($MES < 10))
	then
		find "$ARRIBOS_PATH" -type f -not -name "entregas_0[1-$MES].txt" -exec mv {} $RECHAZADOS_PATH \;
	fi

	if (($MES > 9))
	then
		let "MES=$MES - 10"
		find "$ARRIBOS_PATH" -type f -not -name "entregas_0[1-9].txt" -and -not -name "entregas_[1][0-$MES].txt" -exec mv {} $RECHAZADOS_PATH \;
	fi


	#Por cada archivo en el directorio de arribos los verifico
	#Mover al directorio aceptados o rechazados
	for f in "$ARRIBOS_PATH"/* 
	do
	  VALIDO=true  

	  if [ -f $f ] 
	  then
		echo "$f es un archivo regular."
	  else
		echo "$f no es un archivo regular."
		VALIDO=false
	  fi

	  if [ -s $f ] 
	  then
		echo "$f no está vacio."
	  else
		echo "$f está vacio."
		VALIDO=false
	  fi

	  if [ -f $PROCESADOS_PATH/"$(basename "$f")" ] 
	  then
		echo "Ya ha sido procesado."
		VALIDO=false
	  else
		echo "No ha sido procesado."
	  fi

	  if [ $VALIDO = true ]
	  then
		mv $f $ACEPTADOS_PATH
		echo "se movio a aceptados"
	  else		
		mv $f $RECHAZADOS_PATH
		echo "se movio a rechazados"
	  fi
	done

#done
