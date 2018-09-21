GRUPO="$PWD"
CONF="$GRUPO/conf"
LOG="$CONF/log"
EJECUTABLES="$GRUPO/ejecutables"
MAESTROS="$GRUPO/maestros"
NOVEDADES="$GRUPO/novedades"
ACEPTADOS="$GRUPO/aceptados"
RECHAZADOS="$GRUPO/rechazados"
PROCESADOS="$GRUPO/procesados"
SALIDA="$GRUPO/salida"

log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/instalacion.log" 
}

crear_config () 
{
        date +"GRUPO-$GRUPO-$USER-%x %X" > "$CONF/tpconfig.txt"
        date +"CONF-$CONF-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"LOG-$LOG-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"EJECUTABLES-$EJECUTABLES-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"MAESTROS-$MAESTROS-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"NOVEDADES-$NOVEDADES-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"ACEPTADOS-$ACEPTADOS-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"RECHAZADOS-$RECHAZADOS-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"PROCESADOS-$PROCESADOS-$USER-%x %X" >> "$CONF/tpconfig.txt"
        date +"SALIDA-$SALIDA-$USER-%x %X" >> "$CONF/tpconfig.txt"
        
        log "crear_config" "INF" "Creacion de tpconfig.txt"
}

cargar_config ()
{
        GRUPO=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '1p')
        CONF=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '2p')
        LOG=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '3p')
        EJECUTABLES=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '4p')
        MAESTROS=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '5p')
        NOVEDADES=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '6p')
        ACEPTADOS=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '7p')
        RECHAZADOS=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '8p')
        PROCESADOS=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '9p')
        SALIDA=$(cut -d'-' -f2 'conf/tpconfig.txt' | sed -n '10p')
}

crear_respaldo ()
{
        mkdir "$GRUPO/respaldo"
        cp "instalacion.sh" "$GRUPO/respaldo/instalacion.sh"
        # Agregar los otros archivos
}

mover_archivos ()
{
        mv "instalacion.sh" "$EJECUTABLES"
        # Agregar los otros archivos
}

renombrar_directorios ()
{
        mv "$GRUPO/ejecutables" "$EJECUTABLES"
        mv "$GRUPO/maestros" "$MAESTROS"
        mv "$GRUPO/novedades" "$NOVEDADES"
        mv "$GRUPO/aceptados" "$ACEPTADOS"
        mv "$GRUPO/rechazados" "$RECHAZADOS"
        mv "$GRUPO/procesados" "$PROCESADOS"
        mv "$GRUPO/salida" "$SALIDA"
        
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/ejecutables > $EJECUTABLES" >> "$LOG/instalacion.log"
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/maestros > $MAESTROS" >> "$LOG/instalacion.log"
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/aceptados > $ACEPTADOS" >> "$LOG/instalacion.log"
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/rechazados > $RECHAZADOS" >> "$LOG/instalacion.log"
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/procesados > $PROCESADOS" >> "$LOG/instalacion.log"
        date +"%x %X-$USER-crear_directorios-INF-Reasignado $GRUPO/salida > $SALIDA" >> "$LOG/instalacion.log"
}

info_directorios ()
{
        echo 'Directorio raiz: '
        echo "$GRUPO"
        echo 'Directorio de configuracion: '
        echo "$CONF"
        echo 'Directorio de logs: '
        echo "$LOG"
        echo 'Directorio de archivos ejecutables: '
        echo "$EJECUTABLES"
        echo 'Directorio de archivos maestros: '
        echo "$MAESTROS"
        echo 'Directorio de archivos novedades: '
        echo "$NOVEDADES"
        echo 'Directorio de archivos aceptados: '
        echo "$ACEPTADOS"
        echo 'Directorio de archivos rechazados: '
        echo "$RECHAZADOS"
        echo 'Directorio de archivos procesados: '
        echo "$PROCESADOS"
        echo 'Directorio de archivos salida: '
        echo "$SALIDA"
}

validar_directorio ()
{
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
                for i in "$EJECUTABLES" "$MAESTROS" "$NOVEDADES" "$ACEPTADOS" "$RECHAZADOS" "$PROCESADOS" "$SALIDA"
                do
                        if [ "$i" == "$GRUPO/$INPUT" ]
                        then
                                CONT=$(($CONT + 1))
                        fi
                done
                
                if [ $CONT -ge 1 ]
                then
                        echo "Directorio repetido. Se considera directorio por defecto."
                        log "validar_directorio" "ALE" "Directorio repetido. Se considera directorio por defecto."
                        VALDIR=1
                else
                        VALDIR=0
                fi
        fi
}

instalacion ()
{
        echo "Configuracion de los directorios"
        echo "Directorios reservados conf y conf/log"
        echo "Si no asigna una ruta se considera la ruta por defecto, la que se encuentra entre parentesis"
        log "instalacion" "INF" "Configuracion de directorios"

        # ejecutables
        log "instalacion" "INF" "Ingrese directorio de ejecutables"
        echo "Ingrese directorio de ejecutables ($EJECUTABLES):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                EJECUTABLES="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de ejecutables: $EJECUTABLES"

        # maestros
        log "instalacion" "INF" "Ingrese directorio de maestros"
        echo "Ingrese directorio de maestro ($MAESTROS):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                MAESTROS="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de maestros: $MAESTROS"

        # novedades
        log "instalacion" "INF" "Ingrese directorio de novedades"
        echo "Ingrese directorio de novedades ($NOVEDADES):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                NOVEDADES="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de novedades: $NOVEDADES"

        # aceptados
        log "instalacion" "INF" "Ingrese directorio de aceptados"
        echo "Ingrese directorio de aceptados ($ACEPTADOS):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                ACEPTADOS="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de novedades: $ACEPTADOS"

        # rechazados
        log "instalacion" "INF" "Ingrese directorio de rechazados"
        echo "Ingrese directorio de rechazados ($RECHAZADOS):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                RECHAZADOS="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de rechazados: $RECHAZADOS"

        # procesados
        log "instalacion" "INF" "Ingrese directorio de procesados"
        echo "Ingrese directorio de procesados ($PROCESADOS):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                PROCESADOS="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de procesados: $PROCESADOS"
        
        # salida
        log "instalacion" "INF" "Ingrese directorio de salida"
        echo "Ingrese directorio de procesados ($SALIDA):"
        read -p "$GRUPO/" INPUT
        validar_directorio
        if [ "$INPUT" != "" ] && [ "$VALDIR" == "0" ]
        then
                SALIDA="$GRUPO/$INPUT"
        fi
        log "instalacion" "INF" "Directorio de salida: $SALIDA"

        echo 'Confirmacion de la instalacion'
        info_directorios
        echo 'Estado de la instalcion: LISTA'
        
        log "instalacion" "INF" "Confirmacion de configuracion (s-n)"
        read -p "La informacion ingresada es correcta (s-n): " CONFIRMACION

        if [ "$CONFIRMACION" == 's' ]
        then
                log "instalacion" "INF" "Configuracion correcta"
                renombrar_directorios
                crear_config
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

# MAIN

if [ "$#" == "0" ]
then
        if [ -e "conf/tpconfig.txt" ]
        then
                cargar_config
                info_directorios
        else
                instalacion
        fi
elif [ "$1" == "-r" ]
then
        # reparacion
        :
else
        #mensaje de ayuda
        :
fi
