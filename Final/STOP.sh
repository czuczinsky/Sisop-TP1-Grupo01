#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Sistemas operativos 75.08
# INFO
# USO: STOP.sh
# Detiene al demonio daemon.sh
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# RAIZ
GRUPO="$PWD"
# DIRECTORIOS RESERVADOS
CONF="$GRUPO/conf"
LOG="$CONF/log"



log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/STOP.log"
}

function obtenerPIDProceso(){

	PROCESOABUSCAR=$1

	#Busco en la lista de procesos en ejecucion el proceso que deseo detener
	#-w obliga a que PATRÓN coincida solamente con palabras completas

        PID=`ps ax | grep bash | grep -v $$ | grep -v grep | grep -w $PROCESOABUSCAR`

	#Me quedo unicamente con el PID
	PID=`echo $PID | cut -f 1 -d ' '`

	echo $PID
}

PID_BUSCADO=`obtenerPIDProceso daemon.sh`

if [ "$PID_BUSCADO" != "" ] ; then 
	
    kill -9 $PID_BUSCADO
    echo "El Demonio con PID $PID_BUSCADO se ha detenido correctamente"
    log "STOP" "INF" "El Demonio con PID $PID_BUSCADO se ha detenido correctamente"
else 
    echo "Error: No se detuvo ningun demonio ya que no se encontraba corriendo"
    log "STOP" "ERR" "No se detuvo ningun demonio ya que no se encontraba corriendo"
fi

