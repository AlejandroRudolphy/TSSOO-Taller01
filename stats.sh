#!/bin/bash

UsoScript(){
	echo "Uso: $0 search_dir [-h]"
}

#Determinar cantidad total, máxima, mínima y promedio para el tiempo de simulador total y la memoria utilizada por el simulador.
Metrics(){
	tmpFile=metricsMem.txt
	#Crear archivos que contengan los valores de las columnas a utilizar para cada tarea.
	for i in ${metricsFiles[*]}; do
		printf ">>Evaluando: %s\n" $i
		metricsSim=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}; 
							{sum=$6+$7+$8}; \
							END{ print sum }')
		printf "$metricsSim\n" >> metricsSim.txt
		metricsMem=(`cat $i | tail -n+2 | cut -d ':' -f 9 \
		>> metricsMem.txt;`)
	done
	#Calcular el total, el promedio, el máximo y el mínimo del tiempo de simulación.
	simTotal=$(cat metricsSim.txt | awk 'BEGIN{ min=2**63-1; max=0 }{ if($0<min){min=$0}; 
								if($0>max){max=$0};		
								total+=$0; count+=1;\
								} \
								END { print total":"total/count":"min":"max}')
	#Calcular el total, el promedio, el máximo y el mínimo de la memoria tota utilizada por el simulador.
	memTotal=$(cat metricsMem.txt | awk 'BEGIN{ min=2**63-1; max=0 }{ if($0<min){min=$0};
								if($0>max){max=$0};\
								total+=$0; count+=1;\
								} \
								END { print total":"total/count":"min":"max}')
	rm metricsSim.txt
	rm metricsMem.txt
}
Summary(){
	#Crear un archivo que contenga los valores de la columna 8(evacTime) de los archivos summary-NNN.txt.
	for i in ${summaryFiles[*]}; do
        	printf ">>Evaluando: %s\n" $i
                evacTimeAll=(`cat $i | tail -n+2 | cut -d ':' -f 8 \
		>> evacTimeAll.txt;`)
		evacTimeResidents=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | cut -d ':' -f 8 \
		>> evacTimeResidents.txt;`)
		evacTimeResidentsG0=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 0' | cut -d ':' -f 8 \
		>> evacTimeResidentsG0.txt;`)
		evacTimeResidentsG1=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 1' | cut -d ':' -f 8 \
		>> evacTimeResidentsG1.txt;`)
		evacTimeResidentsG2=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 2' | cut -d ':' -f 8 \
		>> evacTimeResidentsG2.txt;`)
		evacTimeResidentsG3=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 3' | cut -d ':' -f 8 \
		>> evacTimeResidentsG3.txt;`)
		evacTimeVis1=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | cut -d ':' -f 8 \
		>> evacTimeVis1.txt;`)
		evacTimeVis1G0=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 0' | cut -d ':' -f 8 \
		>> evacTimeVis1G0.txt;`) 
		evacTimeVis1G1=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 1' | cut -d ':' -f 8 \
		>> evacTimeVis1G1.txt;`)
		evacTimeVis1G2=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 2' | cut -d ':' -f 8 \
		>> evacTimeVis1G2.txt;`)
		evacTimeVis1G3=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 3' | cut -d ':' -f 8 \
		>> evacTimeVis1G3.txt;`)

	done

	#Calcular el promedio total, el minimo y el máximo de los todas las personas.
	evacTimeAll=$(cat evacTimeAll.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1}; 
										if($1>max){max=$1};\
                 	                                           total+=$1; count+=1;\
                         	                                   } \
                                	                           END { print total":"total/count":"min":"max}')	
	#Eliminar archivo temporal.
	rm evacTimeAll.txt
	#Calcular el promedio total, el minimo y el máximo de todos los residentes.
	evacTimeResidents=$(cat evacTimeResidents.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
											if($1>max){max=$1};\
										total+=$1; count+=1;\
										} \
										END { print total":"total/count":"min":"max}')
	#Calcular el promedio total, el mínimo y el máximo de todos los residentes dependiendo de su grupo etario.
	evacTimeResidentsG0=$(cat evacTimeResidentsG0.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
											if($1>max){max=$1};\
										total+=$1; count+=1;\
										} \
										END { print total":"total/count":"min":"max}')
	evacTimeResidentsG1=$(cat evacTimeResidentsG1.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
											if($1>max){max=$1};\
										total+=$1; count+=1;\
										} \
										END { print total":"total/count":"min":"max}')
	evacTimeResidentsG2=$(cat evacTimeResidentsG2.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
											if($1>max){max=$1};\
										total+=$1; count+=1;\
										} \
										END { print total":"total/count":"min":"max}')
	evacTimeResidentsG3=$(cat evacTimeResidentsG3.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
											if($1>max){max=$1};\
										total+=$1; count+=1;\
										} \
										END { print total":"total/count":"min":"max}')

	#Eliminar archivos temporales.
	rm evacTimeResidents.txt
	rm evacTimeResidentsG0.txt
	rm evacTimeResidentsG1.txt
	rm evacTimeResidentsG2.txt
	rm evacTimeResidentsG3.txt

	#Calcular el promedio total, el mínimo y el máximo de todos los visitantes de tipo I.
	evacTimeVis1=$(cat evacTimeVis1.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
										if($1>max){max=$1};\
									total+=$1; count+=1;\
									} \
									END { print total":"total/count":"min":"max}')
	#Calcular el promedio total, el mínimo y el máximo de todos los visitantes de tipo I dependiendo de su grupo etario.
	evacTimeVis1G0=$(cat evacTimeVis1G0.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
										if($1>max){max=$1};\
									total+=$1; count+=1;\
									} \
									END { print total":"total/count":"min":"max}')		
	evacTimeVis1G1=$(cat evacTimeVis1G1.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
										if($1>max){max=$1};\
									total+=$1; count+=1;\
									} \
									END { print total":"total/count":"min":"max}')
	evacTimeVis1G2=$(cat evacTimeVis1G2.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
										if($1>max){max=$1};\
									total+=$1; count+=1;\
									} \
									END { print total":"total/count":"min":"max}')
	evacTimeVis1G3=$(cat evacTimeVis1G3.txt | awk 'BEGIN{ min=2**63-1; max=0} {if($1<min){min=$1};\
										if($1>max){max=$1};\
									total+=$1; count+=1;\
									} \
									END { print total":"total/count":"min":"max}')
	#Eliminar archivos temporales.
	rm evacTimeVis1.txt
	rm evacTimeVis1G0.txt
	rm evacTimeVis1G1.txt
	rm evacTimeVis1G2.txt
	rm evacTimeVis1G3.txt

}

#Determinar el promedio de uso de teléfonos móviles, además del mínimo, máximo y promedio para los instantes de tiempo
#especificados en el archivo usePhone-NNN.txt
UsoTelefono(){
	OUTFILE="usePhone-stats.txt"
	tmpFile="tiempos.txt" > $tmpFile
	for i in ${phoneFiles[*]}; do
		printf ">>Evaluando: %s\n" $i
		tiempos=(`cat $i | tail -n+2 | cut -d ':' -f 3`)
		for k in ${tiempos[*]}; do
			printf "%d: " $k >> $tmpFile
		done
		printf "\n" >> $tmpFile
	done

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
}
#Búsqueda recursiva en el directorio ingresado de todos los archivos executionSummary-*.txt, summary-*.txt y usePhone-0*.txt.
metricsFiles=$(find $searchDir -name "executionSummary-*.txt")
summaryFiles=$(find $searchDir -name "summary-*.txt")
phoneFiles=$(find $searchDir -name "usePhone-0*.txt")
#Main.
while getopts "d:h" opt; do
	case ${opt} in
		d)
			searchDir=$OPTARG
		;;
		h)
			UsoScript
		;;
		\? )
			UsoScript
		;;
	esac
done

if [ -z $searchDir ]; then
	usoScript
fi
#Verificar si searchDir es realmente un directorio.
if [ ! -d $searchDir ]; then
	"echo $searchDir no es un directorio"
	exit
fi
#Llamada a la función Metrics.
Metrics
#Llamada a la función Summary.
Summary
#Llamada a la función UsoTelefono
UsoTelefono
echo "tSimTotal:promedio:min:max" >> metrics.txt
echo $simTotal >> metrics.txt
echo "memUsed:promedio:min:max" >> metrics.txt
echo $memTotal >> metrics.txt
echo "All:promedio:min:max" >> evacuation.txt
echo $evacTimeAll >> evacuation.txt
echo "Residents:promedio:min:max" >> evacuation.txt
echo $evacTimeResidents >> evacuation.txt
echo "VisitorsI:promedio:min:max" >> evacuation.txt
echo $evacTimeVis1 >> evacuation.txt
echo "Residents-G0:promedio:min:max" >> evacuation.txt
echo $evacTimeResidentsG0 >> evacuation.txt
echo "Residents-G1:promedio:min:max" >> evacuation.txt
echo $evacTimeResidentsG1 >> evacuation.txt
echo "Residents-G2:promedio:min:max" >> evacuation.txt
echo $evacTimeResidentsG2 >> evacuation.txt
echo "Residents-G3:promedio:min:max" >> evacuation.txt
echo $evacTimeResidentsG3 >> evacuation.txt
echo "VisitorsI-G0:promedio:min:max" >> evacuation.txt
echo $evacTimeVis1G0 >> evacuation.txt
echo "VisitorsI-G1:promedio:min:max" >> evacuation.txt
echo $evacTimeVis1G1 >> evacuation.txt
echo "VisitorsI-G2:promedio:min:max" >> evacuation.txt
echo $evacTimeVis1G2 >> evacuation.txt
echo "VisitorsI-G3:promedio:min:max" >> evacuation.txt
echo $evacTimeVis1G3 >> evacuation.txt
