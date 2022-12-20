#!/bin/bash

#Oudahya Ismaïl BA INFO
#000479390
#PROJET 1 SHELL SCRIPTING INFO-F201
#condition si moins de 3 paramètres
if [ "$#" -eq "3" ];then
	exec &>$3/log.out
else
	#crée le log dans l'endroit ou se trouve le fichier project1.sh
	#car les paramètres ne sont pas données
	echo "Veuillez entrer 3 paramètres">log.out
	exit 1
fi

A=$1 #chemin aboslu + le bon fichier
B=$2
C=$3
#########################################################
if [[ ${C::1} != "/" ]];then
	echo "Oublie du '/' donc une correction à été faîtes."
	C=$PWD/${C}
	echo "Voici la direction du C : ${C}"
fi 
echo ""
if [[ ${B::1} != "/" ]];then
	echo "Oublie du '/' donc une correction à été faîtes."
	B=$PWD/${B}
	echo "Voici la direction du B : ${B}"
fi
echo ""
if [[ ${A::1} != "/" ]];then
	echo "Oublie du '/' donc une correction à été faîtes."
	A=$PWD/${A}
	echo "Voici la direction du A : ${A}"
fi

# crée les dossiers et sous dossier
# Univerrsity et les sous dossier.
create_folder(){
	if [ -d ${C}/University ];then
		echo ""
		echo "Le dossier Uniersity existe déjà."
		echo "Suppression du dossier..."
		rm -r ${C}/University
		echo "Suppression terminer."
		echo ""
	fi
	echo ""
	echo "Création du dossier University"
	mkdir -p ${C}/University #crée le dossier University dans le dir_destination.
	echo "Création du dossier University terminer."

	for line in $(cat ${A});do
		echo "Création du sous dossiers...${line}"
		mkdir -p ${C}/University/$line;done
	echo "Création des sous dossiers terminer."

	echo ""
}

#La fonction test_dossier ici , permet de parcourir le dossier ayant les fichiers textes
# et de vérifier grâce au 1er paramètres qui contient les cours de tester si ils sont bien similaire 
# Si le nom du fichier n'est pas similaire alors on devra alors parcourir ce fichier texte à l'aide de la commande grep
test_dossier(){
	var=true
	for m in $(cat ${A});do
		#ici j'utilise tr pour transposer les caractères pour vérifier si ils sont bien similaire que ce soit en minuscule ou majuscule
		# avec l'expression régulière "=~"
		if [[ $(tr "[:upper:]" "[:lower:]" <<<"${1##*/}") =~ $(tr "[:upper:]" "[:lower:]" <<<"${m}") ]];then
			echo -e "${C}/University/${m} \t PRENDS \t ${1}\n"	
			cp "${1}" ${C}/University/"${m}" # utilisation du cp pour copier 
			var=false
			break
		fi
	done
	# parcours les noms de fichier si il trouve qu'ils ne sont pas bon alors
	# il effectue un deuxième parcours qui est le parcours du fichier.
	if $var  ;then # if true
		for j in $(cat ${A});do
			if [ "$(grep -i  ${j} ${1})" ];then # il cherche le nom du cours dans le fichier texte.
				echo -e "${C}/University/${j} \t PRENDS \t ${1}\n"	
				cp "${1}" ${C}/University/"${j}"
				break
			fi
		done
	fi

}
#La fonction permet ici de parcourir le dossier et les sous dossier si ils existent
#Sinon on parcours les fichiers texte dans le dossier en allant surr la fonction test_dossier
parcour_folder(){
	if [ -n "$(ls -A ${1})" ];then
		for dir in $1/*;do
			dir=${dir%*/}
			if [[  -d $dir ]];then
				parcour_folder ${dir} 
			else 
				test_dossier ${dir}
			fi
		done
	fi
}

# La condition suivante permet de tester si les paramètres sont bon
# Si ils sont bon on pourra aller dans la fonction create_folder et parcours_folder 
# parcour_folder reçoit en paramètre le dossier ou sont stocker les cours
if ! test -f "${A}" && [ -d "${B}" ] && [ -d "${C}" ];then 
	echo "Le fichier n'existe pas ou n'est pas dans le bon dossier"
	exit 1
else
	create_folder
	echo ""
	echo -e "Voici le parcours des dossier et sous dossier : \n" 
	parcour_folder ${B}
	exit 0 # succès de la fin du programme
fi


