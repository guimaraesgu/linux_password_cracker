#!/bin/bash
if [ "$1" == "" ]
then
	echo "Linux Password Cracker"
	echo "Modo de uso: ./lpc.sh hash_file wordlist"
else

arquivo=$1
wordlist=$2
while read hash; do
	hashType=$(echo $hash | cut -d $ -f 2)
	salt=$(echo $hash | cut -d $ -f 3)

	for linha in $(cat ${2}); do
		if [ "$hashType" == "1" ]
		then
			wordHash=$(mkpasswd -S $salt --method=md5 $linha)
			if [ "$wordHash" == "$hash" ]
			then
				echo {$hash ==\> $linha}
			fi
		elif [ "$hashType" == "5" ]
		then
			wordHash=$(mkpasswd -s $salt --method=sha-256 $linha)
			if [ "$wordHash" == "$hash" ]
			then
				echo {$hash ==\> $linha}
			fi
		else
			wordHash=$(openssl passwd -6 -salt $salt $linha)
			if [ "$wordHash" == "$hash" ]
			then
				echo {$hash ==\> $linha}
			fi
		fi
	done
done < $arquivo
fi
