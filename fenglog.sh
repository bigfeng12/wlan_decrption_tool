#!/bin/bash

function ctrl_if()
{
	#$1 is the targe file which is scanned for the key words
	if [ $1 = "" ]
	then
		echo "usage: ctrl_if filename"
	fi
	grep -nir -e "control interface" $1
}
