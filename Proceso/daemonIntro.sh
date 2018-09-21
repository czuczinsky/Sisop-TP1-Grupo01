#! /bin/bash

ARRIBOS_PATH="arribos"
ACEPTADOS_PATH="aceptados"
RECHAZADOS_PATH="rechazados"
SALIDA_PATH="salida"
PROCESADOS_PATH="procesados"
ARCHIVO_OPERADORES="maestros/operadores.txt"
ARCHIVO_SUCURSALES="maestros/sucursales.txt"
CONF="conf"
LOG="$CONF/log"
CICLOS=0

log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/daemon.log" 
}

#while :
#do
	#Mando a rechazados todos los archivos que no cumplan con el formato de entrega_mesMenorOIgualAlCorriente
	MES=`date +"%m"`
	MES=$(expr $MES + 0 )
	#MES=5
	if (($MES < 10))
	then
		find "$ARRIBOS_PATH" -type f -not -name "entregas_0[1-$MES].txt" |
			while read file
				do log "daemon" "INF" "$file tiene un nombre incorrecto. Ha sido rechazado"
				mv $file $RECHAZADOS_PATH
			done
	fi

	if (($MES > 9))
	then
		let "MES=$MES - 10"
		find "$ARRIBOS_PATH" -type f -not -name "entregas_0[1-9].txt" -and -not -name "entregas_[1][0-$MES].txt" |
			while read file
				do log "daemon" "INF" "$file tiene un nombre incorrecto. Ha sido rechazado"
				mv $file $RECHAZADOS_PATH
			done
	fi


	#Por cada archivo en el directorio de arribos los verifico
	#Mover al directorio aceptados o rechazados
	for f in "$ARRIBOS_PATH"/* 
	do
	  VALIDO=true  

	  if ! [ -f $f ] 
	  then
		log "daemon" "INF" "$f no es un archivo regular"
		VALIDO=false
	  fi

	  if ! [ -s $f ] 
	  then
		log "daemon" "INF" "$f está vacio"
		VALIDO=false
	  fi

	  if [ -f $PROCESADOS_PATH/"$(basename "$f")" ] 
	  then
		log "daemon" "INF" "$f ya ha sido procesado"
		VALIDO=false
	  fi

	  if [ $VALIDO = true ]
	  then
		mv $f $ACEPTADOS_PATH
		log "daemon" "INF" "$f ha sido aceptado"
	  else		
		mv $f $RECHAZADOS_PATH
		log "daemon" "INF" "$f ha sido rechazado"
	  fi
	done

#done
