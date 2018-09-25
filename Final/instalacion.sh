# VARIABLES DE AMBIENTE
# RAIZ
GRUPO="$PWD"
# DIRECTORIOS RESERVADOS
CONF="$GRUPO/conf"
LOG="$CONF/log"
# VECTORES DE DIRECTORIOS/NOMBRE
NOMBRES_DIR=("ejecutables" "maestros" "novedades" "aceptados" "rechazados" "procesados" "salida")
DIRECTORIOS=("ejecutables" "maestros" "novedades" "aceptados" "rechazados" "procesados" "salida")

log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/instalacion.log" 
}

crear_config () 
{

        date +"GRUPO-$GRUPO-$USER-%x %X" > "$CONF/tpconfig.txt"
        date +"CONF-$CONF-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"LOG-$LOG-$USER-%x %X" >> "$CONF/tpconfig.txt"

        for i in {0..6}
        do
                NOMBRE_DIR_MAYUS=$(echo "${NOMBRES_DIR[$i]}" | tr '[a-z]' '[A-Z]')
                date +"$NOMBRE_DIR_MAYUS-$GRUPO/${DIRECTORIOS[$i]}-%x %X" >> "$CONF/tpconfig.txt"
        done
        
        log "crear_config" "INF" "Creacion de tpconfig.txt"
        
}

cargar_config ()
{
        GRUPO=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '1p')
        CONF=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '2p')
        LOG=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '3p')
        
        for i in {0..6}
        do
                j=$(($i + 4))
                DIRECTORIOS[$i]=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n "${j}p")
                DIRECTORIOS[$i]="${DIRECTORIOS[$i]##*/}"
        done
        
        log "cargar_config" "INF" "Carga de tpconfig.txt"
}

crear_respaldo ()
{
        
        mkdir "$GRUPO/respaldo"
        
        cp "instalacion.sh" "$GRUPO/respaldo/instalacion.sh"
        cp "inicializador.sh" "$GRUPO/respaldo/inicializador.sh"
        cp "daemon.sh" "$GRUPO/respaldo/daemon.sh"
        cp "START.sh" "$GRUPO/respaldo/START.sh"
        cp "STOP.sh" "$GRUPO/respaldo/STOP.sh"
        
        log "crear_respaldo" "INF" "Creo respaldo de ejecutables (extension .sh)"
        
        chmod -R -x "$GRUPO/respaldo/"
        
        log "crear_respaldo" "INF" "Retiro permisos del ejecucion de respaldo"
        
}

mover_archivos ()
{
        
        mv "inicializador.sh" "$GRUPO/${DIRECTORIOS[0]}/"
        mv "daemon.sh" "$GRUPO/${DIRECTORIOS[0]}/"
        mv "START.sh" "$GRUPO/${DIRECTORIOS[0]}/"
        mv "STOP.sh" "$GRUPO/${DIRECTORIOS[0]}/"
        
        log "mover_archivos" "INF" "Se mueven los archivos ejecutables a $GRUPO/${DIRECTORIOS[0]}/"
        
        if [ -a "$GRUPO/operadores.txt"]
        then
                mv "operadores.txt" "$GRUPO/${DIRECTORIOS[1]}/"
                log "mover_archivos" "INF" "Se mueve operadores.txt a $GRUPO/${DIRECTORIOS[1]}/"
        fi
        
        if [ -a "$GRUPO/sucursales.txt"]
        then
                mv "sucursales.txt" "$GRUPO/${DIRECTORIOS[1]}/"
                log "mover_archivos" "INF" "Se mueve sucursales.txt a $GRUPO/${DIRECTORIOS[1]}/"
        fi
        
        if [ "$(ls -A "$GRUPO"/Entregas_*)" ]
        then
                mv "Entregas"* "$GRUPO/${DIRECTORIOS[2]}/"
                log "mover_archivos" "INF" "Se mueven los archivos entregas a $GRUPO/${DIRECTORIOS[2]}/"
        fi
        
}

crear_directorios_reservados ()
{
        if [ ! -d "$CONF" ]
        then
                mkdir "$CONF"
        fi
        
        if [ ! -d "$LOG" ]
        then
                mkdir "$LOG"
        fi
}

crear_directorios ()
{
        
        for i in {0..6}
        do
                mkdir "$GRUPO/${DIRECTORIOS[$i]}"
                log "crear_directorios" "INF" "Creacion de directorio $GRUPO/${DIRECTORIOS[$i]}"
        done

}

info_directorios ()
{
        echo 'Directorio raiz: '
        echo "$GRUPO"
        echo 'Directorio de configuracion: '
        echo "$CONF"
        echo 'Directorio de logs: '
        echo "$LOG"

        for i in {0..6}
        do
                echo "Directorio de ${NOMBRES_DIR[$i]}:"
                echo "$GRUPO/${DIRECTORIOS[$i]}"
        done
}

validar_directorio ()
{
        VALDIR=0
        if [ "$GRUPO/$INPUT" == "$CONF" ]
        then
                echo "Directorio reservado. Se considera directorio por defecto."
                log "validar_directorio" "ALE" "Directorio reservado. Se considera directorio por defecto."
                VALDIR=1
        elif [ "$GRUPO/$INPUT" == "$LOG" ]
        then
                echo "Directorio reservado. Se considera directorio por defecto."
                log "validar_directorio" "ALE" "Directorio reservado. Se considera directorio por defecto."
                VALDIR=1
        else
                CONT=0
                for j in {0..6}
                do
                        if [ "${NOMBRES_DIR[$j]}" != "$1" ] && [ "${DIRECTORIOS[j]}" == "$INPUT" ]
                        then
                                echo "*Directorio repetido. Se considera directorio por defecto."
                                log "validar_directorio" "ALE" "Directorio repetido. Se considera directorio por defecto."
                                VALDIR=1
                        fi
                done
        fi
}

instalacion ()
{
        echo "Configuracion de los directorios"
        echo "Directorios reservados conf y conf/log"
        echo "Si no asigna una ruta se considera la ruta por defecto, la que se encuentra entre parentesis"
        log "instalacion" "INF" "Configuracion de directorios"

        for i in {0..6}
        do
                log "instalacion" "INF" "Ingrese directorio de ${NOMBRES_DIR[$i]}"
                echo "Ingrese directorio de ${NOMBRES_DIR[$i]} ($GRUPO/${DIRECTORIOS[$i]}):"
                read -p "$GRUPO/" INPUT
                validar_directorio "${NOMBRES_DIR[$i]}"
                if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
                then
                        DIRECTORIOS[$i]="$INPUT"
                fi
                log "instalacion" "INF" "Directorio de ${NOMBRES_DIR[$i]}: $GRUPO/${DIRECTORIOS[$i]}"
        done

        echo 'Confirmacion de la instalacion'
        info_directorios
        echo 'Estado de la instalcion: LISTA'
        
        log "instalacion" "INF" "Confirmacion de configuracion (s-n)"
        read -p "La informacion ingresada es correcta (s-n): " CONFIRMACION

        if [ "$CONFIRMACION" == 's' ]
        then
                log "instalacion" "INF" "Configuracion correcta"
                crear_respaldo
                crear_directorios
                crear_config
                mover_archivos
        elif [ "$CONFIRMACION" == 'n' ]
        then
                log "instalacion" "INF" "Configuracion rechazada"
                echo "Volviendo a iniciar instalacion"
                log "instalacion" "INF" "Reiniciando instalacion"
                instalacion
        else
                log "instalacion" "INF" "Configuracion abortada"
                echo "Opción invalida"
                echo "Abortando instalacion"
                log "instalacion" "INF" "Finalizando instalacion"
        fi
}

modo_reparacion ()
{
        cargar_config
        # Copiar archivos
}

# MAIN

crear_directorios_reservados

if [ "$#" == "0" ]
then
        if [ -e "conf/tpconfig.txt" ]
        then
                cargar_config
                info_directorios
        else
                instalacion
        fi
elif [ "$#" == "1" ] && [ "$1" == "-r" ] && [ -e "conf/tpconfig.txt" ]
then
        # reparacion
        modo_reparacion
else
        #mensaje de ayuda
        echo "Mensaje de ayuda"
fi
