********************************************
# Sistemas Operativos - Trabajo Práctico Nº1
# Grupo 01 - 2º Cuatrimestre del 2018
********************************************

# Requisitos del Sistema
- Se requiere tener instalado Bash en el sistema.


# Descarga y descompresión del sistema
- Descargar el paquete llamado Grupo01.tgz del siguiente link: https://github.com/czuczinsky/Sisop-TP1-Grupo01
- Mover el paquete a la ubicación que usted desee.
- Abrir la terminal en la ubicación elegida y ejecutar el comando tar -zxvf Grupo01.tgz
- Se obtendrá dentro de la ubicación los comandos y archivos maestros.



# Instalación
- Ubicado en el directorio elegido, ejecutar por la terminal el comando ./instalacion.sh
- Se observará una pantalla de bienvenida y se crearan las carpetas conf y cong/log.
- Se pedira configurar los directorios de ejecutables, maestros, novedades, aceptados, rechazados, procesados, salida. Usted podrá ingresar una ruta, y si no ingresa una se asignará una ruta por defecto.
- Se pedirá una confirmación de la información ingresada. Si ingresa s se completará la instalación creando todos los directorios mencionados y ubicando los script y archivos maestros donde corresponden. Y si ingresa n volverá a comenzar la instalación y se pedirá nuevamente que se configuren los directorios.

(Nota: si el sistema ya ha sido correctamente instalado, la ejecución del comando ./instalacion.sh informará la situación e informará los directorios de la instalación)

- Para reparar el sistema ingrese al directorio de la instalación y ejecute el comando ./instalacion.sh -r



# Instrucciones de inicialización
- Ir al directorio de ejecutables y ejecutar el comando ./inicializador.sh
- Se informará si se inicializa por primera vez, si ya ha sido inicializado o, en caso de no estar dadas las condiciones para inicializarse, los componentes faltante junto a un mensaje de como reparar el sistema.
- En caso de estar todo en orden, se informará sobre el cambio de permisos en los archivoso maestros y ejecutables, y el inicio del proceso Demonmio.

# Uso
- Con el proceso daemon funcionando, se puede detener ubicandose en el directorio ejecutables y escribiendo el comando ./STOP.SH el cual informa si sea ha detenido el proceso o si no había proceso funcionando que detener.
- Para volver a iniciar el proceso daemon, ubicado en el directorio ejecutables, ingrese el comando ./START.SH el cual volverá a poner en funcionamiento el proceso daemon, siempre y cuando estén dadas las condiciones (variables inicializadas, directorios y archivos maestros disponibles/accesibles). En caso de que ya se encuentre un proceso daemon corriendo, no se correra uno adicional y se informará de la situación.
- Para procesar archivos debe colocar los archivos de entregas dentro del directorio novedades.


# Estructuras
- maestros/Operadores.txt
- maestros/Sucursales.txt
- Grupo01/conf/tpconfig.txt

# Listado de archivos de prueba dados por la cátedra
- entregas_03.txt
- entregas_04.txt
- entregas_05.txt
- entregas_06.txt
- entregas_07.txt

# Listado de archivos de prueba del grupo
RECHAZADOS POR TENER UN MAL NOMBRE
- Entergas_01.txt
- Entregas 01.txt
- Entregas_001.txt
- Entregas_13.txt
- Entregas_12.txt
- Entregas_00.txt
- Entregas-01.txt

RECHAZADOS POR ESTAR VACIO
- Entregas_02.txt

RECHAZADO POR SER UN PDF
- Entregas_02.pdf

RECHAZADO POR TRAILER INCORRECTO
- Entregas_07.txt No posee trailer
- Entregas_08.txt Incorrecta cantidad de registros.
- Entregas_09.txt No posee trailer Incorrecta sumatoria de codigo postal

