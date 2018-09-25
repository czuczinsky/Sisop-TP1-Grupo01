CONF="conf"
LOG="$CONF/log"
GRUPO=$PWD
inicializado=0

# Funcion de log
function log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$GRUPO/conf/log/inicializador.log" 
}

# funcion de reparacion de instalacion

function reportar() {
    echo -e "\e[1;31m$1\e[0m"
    echo -e "\e[1;31mPara reparar la instalación corra el script './instalador.sh -r'\e[0m"
}

#si la variable maestros no existe entonces se inicializa por primera vez
#si no ya se ha inicializado 
if [[ -z $MAESTROS ]]; then  
echo "primera vez que es inicializado"
log "inicializador" "INF" "primera vez que es inicializado"
else
echo "se ha inicializado una vez con anterioridad"
log "inicializador" "INF" "se ha inicializado una vez con anterioridad"
inicializado=1
fi

while read linea; do
# me quedo con el 1 campo
    key=$(echo "$linea" | cut -d- -f1)
# me quedo con el 2 campo  
  ruta=$(echo "$linea" | cut -d- -f2)
# me quedo con el 3 campo  
  user=$(echo "$linea" | cut -d- -f3)
# si nunca fue inicializado se inicializan las variables de ambiente
if [ $inicializado -eq 0 ]; then
    case "$key" in
        MAESTROS) export MAESTROS=$ruta;;
        EJECUTABLES) export EJECUTABLES=$ruta;;
        ACEPTADOS) export ACEPTADOS=$ruta;;
        RECHAZADOS) export RECHAZADOS=$ruta;;
        PROCESADOS) export PROCESADOS=$ruta;;
        SALIDA) export SALIDA=$ruta;;
        LOG) export LOG=$ruta;;
	NOVEDADES) export NOVEDADES=$ruta;;
	CONF) export CONF=$ruta;;
	GRUPO) export GRUPO=$ruta;;
	
    esac
    
fi

done < "$GRUPO/conf/tpconfig.txt"

log "inicializador" "INF" "cambio de permisos en MAESTROS y EJECUTABLES"
echo "cambio de permisos en MAESTROS y EJECUTABLES"
# busca si existe la ruta de maestros y se le cambia para que sea de lectura
find "$MAESTROS" -type f -exec chmod u+r {} +
# busca si existe la ruta de ejecutables y se le cambia para que sea de lectura y ejecucion
find "$EJECUTABLES" -type f -exec chmod u+rx {} +

for x in "$MAESTROS" "$EJECUTABLES" "$ACEPTADOS" "$RECHAZADOS" "$SALIDA" "$NOVEDADES"; do

    if [ -z "$x" ]; then
        echo "$x"
        echo "no esta $x en archivo de configuracion"
	    log "inicializador" "INF" "no esta $x en archivo de configuracion"
    else
	    echo "esta $x en archivo de configuracion"
	    log "inicializador" "INF" "esta $x en archivo de configuracion"
    fi

    if [ ! -d "$x" ]; then
        reportar "directorio de $x no existe"
    	log "inicializador" "INF" "directorio de $x no existe falta un componente"
    fi
    
done

# se llama al script START.sh
. "$EJECUTABLES/START.sh"
