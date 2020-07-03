# TSSOO-Taller01

Alejandro Rudolphy - alejandro.rudolphy@alumnos.uv.cl

>> *Universidad de Valparaíso* 

## 1. Requerimientos.

Implementar un script que sirva como simulador para el análisis de datos.

## 2. Diseño.

Se crearán listas con todos los archivos -NNN.txt a utilizar, separándolos por tipo de archivo, generando tres listas. La lista que contiene los archivos executionSummary-NNN.txt 

se usará en la función Metrics, la lista que contiene los archivos summary-NNN.txtse usará en la función Summary y la lista que contenga los archivos usePhone-NNN.txt se usará en la función UsoTelefono.
 
En base a cada una de estas listas, se crearán archivos temporales desde donde se extraerán los datos necesarios para los cálculos de cada solución, para finalmente, almacenar esos datos en variables que serán guardadas en archivos de salida dependiendo de la tarea que se esté ejecutando, la función Metrics
entregará un archivo metrics.txt, la función summary entregará un archivo summary.txt y la función UsoTelefono entregará un archivo usePhone-stats.txt. 
Los archivos se filtrarán con los siguientes comandos:

    metricsFiles=(`find $searchDir -name "executionSummary-*.txt")
    
    summaryFiles=(`find $searchDir -name "summary-*.txt")
    
    phoneFiles=(`find $searchDir -name "usePhone-0*.txt")

Finalmente, cada función eliminará los archivos temporales que haya utilizado. El problema se puede separar en tres tareas.

## 2.1 Tarea 1

Para esta tarea se filtrarán los archivos "executionSummary-NNN.txt".
En primera instancia, se busca con el comando find dentro de los archivos del directorio ingresado, con el nombre de "executionSummary.txt", para esto se buscará asignar la ruta de cada archivo a una variable,
para luego recorrer el contenido de esa variable y a su vez, el contenido de cada archivo. Se filtrarán los archivos con el siguiente comando:

    executionSummary=(`find $searchDir -name "executionSummary-*.txt")

Una vez encontrado cada archivo por cada carpeta de la simulacion se crearon archivos temporales para su posterior almacenamiento de datos, donde estos seran utilizados para calcular información mas adelante.

Para calcular la suma del tiempo y memoria total utilizada, se creo un bucle para recorrer los archivos almacenados en metricsFiles[*], para luego asignar correspondientemente los valores de suma del tiempo a la variable
metricsSim y metricsMem utilizada a memTotal, donde posteriormente se almacenan dentro de los archivos temporales metricsSim.txt y metricsMem.txt. El primer archivo temporal será utilizado por el siguiente comando:

    simTotal=$(cat metricsSim.txt | awk 'BEGIN{ min=2**63-1; max=0}{if($0<min){min=$0};\
        							if($0>max){max=$0};\
            						total+=$0; count+=1;\
                						} \
                						END{ print total, total/count, min, max }')
                						

y el segundo será utilizado por el siguiente:

    memTotal=$(cat metricsMem.txt | awk 'BEGIN{ min=2**63-1; max=0}{if($0<min){min=$0};\
        							if($0>max){max=$0};\
            						total+=$0; count+=1;\
                						} \
                						END{print total, total/count, min, max}')

Una vez terminada la ejecución, se almacenan los resultados obtenidos dentro del archivo de salida "metrics.txt" y se procede a eliminar los archivos temporales utilizados durante la ejecución.

## 2.2 Tarea 2
Para esta tarea se filtrarán los archivos "summary-NNN.txt".

Una vez encontrado cada archivo por cada carpeta de la simulacion se crearon nuevamente archivos temporales para su posterior almacenamiento de datos, donde estos seran utilizados para calcular información más adelante.
Estos archivos temporales fueron creados de la siguiente manera, dando como ejemplo el caso de los residentes-G0.

    evacTimeResidentsG0=(`cat $i | tail -n+2 |  | cut -d ':' -f 8 >> evacTimeResidentsG0.txt;`)

Los comandos "awk -F ':' '$3 == 0' " y "awk -F ':' '$4 == 0' " se utilizan para filtrar a las personas mediante los datos que tienen en las columnas 3 y 4. Posteriormente, se realizan 
los cálculos correspondientes de cada archivo temporal creado de la misma manera que este.

    evacTimeResidentsG0=$(cat evacTimeResidentsG0.txt | awk 'BEGIN{ min=2**63-1; 		max=0} {if($1<min){min=$1};\
    										if($1>max){max=$1};\
    										total+=$1; count+=1;\
    										} \
    										END { print total":"total/count":"min":"max}')

Una vez terminada la ejecución, se almacenan los resultados obtenidos dentro del archivo "evacuation.txt" y se eliminan los archivos temporales utilizados durante la ejecución.


## 2.3 Tarea 3

Para esta tarea se filtrarán los archivos "usePhone-NNN.txt".
En primer lugar se guardan los tiempos de uso del teléfono en un archivo temporal "tiempos.txt", que será utilizado más tarde para los cálculos respectivos, este archivo se llena de la siguiente manera:

    for i in ${phoneFiles[*]}; do
    		printf ">>Evaluando: %s\n" $i
    		tiempos=(`cat $i | tail -n+2 | cut -d ':' -f 3`)
    		for k in ${tiempos[*]}; do
    				printf "%d: " $k >> $tmpFile
    		done
    		printf "\n" >> $tmpFile
    done
Luego, se llenará el archivo "usePhone-stats.txt" con otro bucle que almacenará en el archivo el intervalo de tiempo, con 1 siendo el intervalo de 0 a 10; y el promedio, el minimo y el máximo de los tiempos en este intervalo. Esto fue realizado de la siguiente manera:

    totalFields=$(head -1 $tmpFile | sed 's/.$//' | tr ':' '\n' | wc -l) > $OUTFILE
    printf "timestamp:promedio:min:max\n" >> $OUTFILE
    for i in $(seq 1 $totalFields); do
    		out=$(cat $tmpFile | cut -d ':' -f $i |\
    					awk 'BEGIN{ min=2**63-1; max = 0}\
    					{if($1<min){min=$1};if($1>max){max=$1};total+=$1; count+=1;}\
    					END{ print total/count":"max":"min}')
    					printf "$i:$out\n" >> $OUTFILE
    done
    rm $tmpFile

Y con esto, termina la ejecución del script.







