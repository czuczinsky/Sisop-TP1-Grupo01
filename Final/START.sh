#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Sistemas operativos 75.08
#INFO
#USO: START.sh
#
#Arranca el demonio daemon.sh
#únicamente si la inicialización 
#se realizó con éxito 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ -z "$GRUPO" ] ; then

        cd ..
fi

#RAIZ
GRUPO="$PWD"
# DIRECTORIOS RESERVADOS
CONF="$GRUPO/conf"
LOG="$CONF/log"

#para obtener las variables que necesito
#source "$EJECUTABLES/inicializador.sh"

#sleep 5s

log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/START.log"
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

function variablesInicializadas(){

        #si las variables no estan vacias significa que se inicializaron

	if [ "$MAESTROS" != "" ] && [ "$EJECUTABLES" != "" ] && [ "$ACEPTADOS" != "" ] \
	&& [ "$RECHAZADOS" != "" ] && [ "$PROCESADOS" != "" ] && [ "$SALIDA" != "" ] \
	&& [ "$LOG" != "" ]; then

                echo 0
        else
                echo 1
        fi
}

function existenArchivosMaestros(){

        SUCURSALES="$MAESTROS/sucursales.txt"
        OPERADORES="$MAESTROS/operadores.txt"

#chequeo que existan los archivos

        if [ ! -f "$OPERADORES" ] || [ ! -f "$SUCURSALES" ]; then

	#no existen los archivos maestros
	echo 1
	return

        fi

	if [ ! -r "$OPERADORES" ] || [ ! -r "$SUCURSALES" ]; then

	#no tienen permiso de lectura
	echo 1 
	return

	fi

echo 0
return

}

function permisoEjecutables(){

        START="$EJECUTABLES/START.sh"
        STOP="$EJECUTABLES/STOP.sh"
        INICIALIZACION="$EJECUTABLES/inicializador.sh"
        PROCESO="$EJECUTABLES/daemon.sh"


#chequeo que tengan permiso de ejecucion

        if [ ! -x "$START" ] || [ ! -x "$STOP" ] \
        || [ ! -x "$INICIALIZACION" ] || [ ! -x "$PROCESO" ]; then

        #no tienen permiso de ejecucion
        echo 1
        return

        fi

echo 0
return

}


function existenDirectorios(){


        if [ ! -d "$MAESTROS" ] || [ ! -d "$ACEPTADOS" ] || [ ! -d "$RECHAZADOS" ] \
	|| [ ! -d "$EJECUTABLES" ] || [ ! -d "$PROCESADOS" ] || [ ! -d "$SALIDA" ] \
        || [ ! -d "$LOG" ]; then 	

                echo 1
        else
                echo 0
        fi
}



if [ `variablesInicializadas` -eq 1 ] ; then
	echo "Error: Variables necesarias no inicializadas"
	log "START" "ERR" "Variables de ambiente no se encuentran inicializadas"
	exit 1 
fi

if [ `existenDirectorios` -eq 1 ] ; then
        echo "Error: Directorios necesarios no se encuentran disponibles"
        log "START" "ERR" "Directorios necesarios no se encuentran disponibles"
        exit 1
fi

if [ `permisoEjecutables` -eq 1 ] ; then
        echo "Error: Los ejecutables no tienen permiso de ejecución"
        log "START" "ERR" "Los ejecutables no tienen permiso de ejecución"
        exit 1
fi

if [ `existenArchivosMaestros` -eq 1 ] ; then
        echo "Error: Archivos maestros no existen o no tienen permiso de lectura"
        log "START" "ERR" "Archivos maestros no existen o no tienen permiso de lectura"
	exit  1
fi


#Busco si el demonio esta corriendo

PID_BUSCADO=`obtenerPIDProceso daemon.sh`

#si no esta corriendo hago que empiece a correr
if [ -z "$PID_BUSCADO" ] ; then
    
        #. "$EJECUTABLES/daemon.sh" &
	bash "$EJECUTABLES/daemon.sh" &
	PID_BUSCADO=`obtenerPIDProceso daemon.sh`
	echo "El Demonio ha sido iniciado bajo el PID: $PID_BUSCADO"
	log "START" "INF" "El Demonio ha sido iniciado  bajo el PID: $PID_BUSCADO"
else 
        echo "Error: Demonio ya ejecutado bajo PID: $PID_BUSCADO"
	log "START" "ERR" "El demonio ya se encuentra corriendo bajo el PID: $PID_BUSCADO"

fi
