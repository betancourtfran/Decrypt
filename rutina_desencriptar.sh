#!/bin/bash
archivo_pem='clave_privada_20160729.pem';
ruta_archivos='../archivos/';
ruta_clave='../clave/';
PS3='¿Qué desea hacer?';
opciones="Revisar_claves Desencriptar_pedidos"
archivos=$(ls $ruta_archivos | cut -d'_' -f1-2 | grep -E "^0000602021_.*(\.txt)$") #obtiene los archivos contenidos en la carpeta "archivos"
claves=$(ls $ruta_archivos | grep "claves.txt" | cut -d'-' -f2 $ruta_archivos"claves.txt") #obtiene las claves contenidas en "claves.txt"
claves=($claves) #asigna las claves a un array
i=0

	select opcion in $opciones
	do
		if [[ $opcion == 'Revisar_claves' ]]
			then
				for clave in ${claves[*]}
				do
					echo $clave[$i];
					i=$((i+1));
				done
		elif [[ $opcion == 'Desencriptar_pedidos' ]]
			then
	
	for texto_enc in $archivos
	do
		clave=${claves[$i]}
		echo "$texto_enc"
		echo $clave
		if [[ $texto_enc != '' ]]
		then
			if [[ $texto_enc != *../* ]]
			then
				texto_enc=$ruta_archivos$texto_enc;
			fi
		else
			tex='no';
		fi
		if [[ $tex != 'no' ]]
		then
			if [ -e $texto_enc ];
			then
				texto_encontrado='si';
			else
				echo '--------------------------------------------------------------------------------------';
				echo El archivo $texto_enc no se encuentra por favor verifique e intente nuevamente.
				echo '--------------------------------------------------------------------------------------';
				texto_encontrado='no';
			fi
		fi

# VALIDAR EXISTENCIA DE CLAVE

		if [[ $clave == '' ]]
		then
			pass='no';
		else
			if [[ $clave != *../* ]]
			then
				ruta_pem=$ruta_clave$archivo_pem;
			fi
		fi
		if [[ $pass != 'no' ]]
		then
			if [ -e $ruta_pem ];
			then
				clave_encontrada='si';
			else
				echo '--------------------------------------------------------------------------------------';
				echo El archivo $ruta_pem no se encuentra por favor verifique e intente nuevamente.
				echo '--------------------------------------------------------------------------------------';
				clave_encontrada='no';
			fi
		fi
		if [[ $tex == $pass  ]]
		then
			if [[ $tex == 'no' ]]
			then
				echo '--------------------------------------------------------------------------------------';
				echo "Debe Completar los campos solicitados en este orden: texto_encriptado.txt $ruta_pem.pem";
				echo '--------------------------------------------------------------------------------------';
			else
				if [[ $clave_encontrada == $texto_encontrado ]]
				then
					if [[ $clave_encontrada != 'no' ]]
					then								
						arc_enc=$(echo $texto_enc | tr "." "\n")
						arc_enc=$(echo $arc_enc | tr "/" "\n")
						arc_enc=$(echo $arc_enc | tr "archivos" "\n")
						arc_enc=$(echo $arc_enc | tr "txt" "\n")
						arc_enc=$(echo $arc_enc | tr "TXT" "\n")
								
						openssl enc -d -base64 -in $texto_enc -out $texto_enc.zip
								
						unzip -j -P $clave $texto_enc.zip -d $ruta_archivos
								
						python GNUCryptoLine.py -d -f $ruta_archivos$arc_enc.lc  -g $ruta_pem -t $ruta_archivos$arc_enc'_'$(date '+%m%d%Y').txt -c0 -l ../log/desencriptar_$(date '+%m%d%Y').log
								
						resultado=$arc_enc'_'$(date '+%m%d%Y').txt;
								
						archivo_creado=$ruta_archivos$arc_enc'_'$(date '+%m%d%Y').txt

						if [ -e $archivo_creado ];
						then
							echo '-------------------------------------------------------------';
							echo "Su archivo desencriptado es: $resultado";
							echo '-------------------------------------------------------------';
							rm $ruta_archivos$arc_enc.txt.zip
							rm $ruta_archivos$arc_enc.lc
							rm $ruta_archivos$arc_enc.txt
							# sleep 1.5
						else
							echo '----------------------------------------------------------------------------------';
							echo 'No se ha podido desencriptar el archivo, por favor verifique e intente nuevamente.'
							echo '----------------------------------------------------------------------------------';
						fi							
					fi
				fi
			fi
		else
			echo '--------------------------------------------------------------------------------------';
			echo 'Debe Completar los campos solicitados en este orden: texto_encriptado.txt clave.pem';
			echo '--------------------------------------------------------------------------------------';
		fi
		i=$((i+1))
	done
	fi
	break
done
