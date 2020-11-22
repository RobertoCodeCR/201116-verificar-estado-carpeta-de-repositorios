#!/bin/bash

# Check system language and add strings
case $LANG in 
    es_ES.UTF-8)
        check_modif="modificado"
        message_modif="modificado"
        check_untr="seguimiento"
        message_untr="archivos sin seguimiento"
        check_unpush="adelantada"
        message_unpush="falta hacer push"
        clean="nada a hacer commit"
        no_git="no es un repositorio de git"
        ;;
    en_US.UTF-8)
        check_modif="modified"
        message_modif="modified"
        check_untr="untracked"
        message_untr="untracked"
        check_unpush="ahead"
        message_unpush="unpushed"
        clean="nothing to commit"
        no_git="not a git repository"
        ;;
	*)
        check_modif="modificado"
        message_modif="modificado"
        check_untr="seguimiento"
        message_untr="archivos sin seguimiento"
        check_unpush="adelantada"
        message_unpush="falta hacer push"
        clean="nada a hacer commit"
        no_git="no es un repositorio de git"
    ;;
esac

dir="$1"

# No directory has been provided, use current
if [ -z "$dir" ]
then
    dir="`pwd`"
fi

# Make sure directory ends with "/"
if [[ $dir != */ ]]
then
	dir="$dir/*"
else
	dir="$dir*"
fi

# Loop all sub-directories
for f in $dir
do
	# Only interested in directories
	[ -d "${f}" ] || continue

	# Check if directory is a git repository
	if [ -d "$f/.git" ]
	then
        mod=0	
		modificado=""
		no_agregado=""
		adelantado=""
		cd $f

		# Check for modified files
		if [ $(git status | grep "$check_modif" -c) -ne 0 ]
		then
			mod=1
			modificado="\033[0;93m$message_modif\033[0m "
		fi

		# Check for untracked files
		if [ $(git status | grep "$check_untr" -c) -ne 0 ]
		then
			mod=1
			no_agregado="\033[0;91m$message_untr\033[0m "
		fi

        # Check for unpushed changes
        if [ $(git status | grep "$check_unpush" -c) -ne 0 ]
        then
			mod=1
            adelantado="\033[0;92m$message_unpush\033[0m "
        fi

		#Solo se muestra si la rama tiene cambios
		if [ $mod -eq 1 ]
		then
			#Se imprime el nombre del directorio
			echo -en "\033[0;35m"
			echo "${f}"
			echo -en "\033[0m"

			# Se imprime la rama
			s=$(git status | head -n1)
			echo -en "\033[0;36m${s:10}\033[0m "

			#Se imprime los estados
			echo -en $modificado" "$no_agregado" "$adelantado

			#Espacio entre carpetas
			echo -e " "
			echo
		fi

		# Check if everything is peachy keen
		# if [ $mod -eq 0 ]
		# then
		# 	echo -en "$clean"
		# fi


        
		cd ../
	# else
    #     # Not a git repository

	#     echo -en "\033[0;37m"
    # 	echo "${f}"
	# 	echo "$no_git"
	#     echo -en "\033[0m"
	fi
    #echo
done
