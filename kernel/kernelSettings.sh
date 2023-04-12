#!/bin/bash
set -x

if [ -z "$1" ]; then 
	echo "path to config file not set"
	exit $1
fi

while IFS=$'\n' read line
do
	if [[ ! ${line:0:1} == "#" ]] && [[ ! $line == "" ]] ; then
		if [[ ${line: -2} == "=y" ]]; then
			/usr/src/linux/scripts/config --file /usr/src/linux/.config --enable ${line::-2}
			#echo fix ${line: -2}
		else
	
			/usr/src/linux/scripts/config --file /usr/src/linux/.config --module ${line:0:-2}
			#echo module ${line: -2}
		fi
	fi
done < $1
