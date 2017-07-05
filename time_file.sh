#!/bin/bash

function feng_get_avg_time()
{
	count=0
	tmp=0
	sum=0
	max=0
	min=99999999
	statement=0
	declare -a time

	if [ $# -lt 1 ]
	then
		echo "usage: feng_get_avg_time in.file"
		echo "format of in.file:"
		echo "========================="
		echo -e "\\t 38452.178486"
		echo -e "\\t 38456.226226"
		echo -e "\\t 38517.712919"
		echo -e "\\t 38520.859577"
		echo -e "\\t 38558.045892"
		echo -e "\\t 38560.155551"
		echo "========================="
		echo -e "data should be converted by user_time in main_log"
		echo -e "and cooked in kernel_log"
		return
	fi
	
	#$1 is file name, coutains timestamp
	echo "=====raw data start======="
	for i in `cat $1`
	do
		echo "$i"
		time[tmp++]=$i
	done
	echo "=====raw data end======="

	line=`cat $1 | wc -l`
	echo "line: $line"

	##times: how many times that the main loop should run
	times=`echo $line/2|bc`
	echo "times : $times"
	while [ "$count" -lt "$line" ]
	do
		a=`echo ${time[count+1]}-${time[count]}|bc`
		echo ${time[count+1]} - ${time[count]} = $a
		##findout the max
		judge=`echo "$a > $max" | bc`	
		if [ "$judge" -eq "1" ]
		then
			max=$a	
			statement_max=`echo ${time[count+1]} - ${time[count]}`
		fi
		##find out the min
		judge=`echo "$a < $min" | bc`	
		if [ "$judge" -eq "1" ]
		then
			min=$a	
			statement_min=`echo ${time[count+1]} - ${time[count]}`
		fi
		sum=`echo $sum+$a|bc`
		let "count=count+2"
	done

	avg=`echo "scale=10;$sum/$times" | bc`
	echo -e "\033[41;37mavg: $avg \033[0m"
	echo -e "\033[41;37mmax: $max \033[0m"
	echo -e "\033[41;37mmin: $min \033[0m"
	echo -e "\033[41;37mstatement_max: $statement_max \033[0m"
	echo -e "\033[41;37mstatement_min: $statement_min \033[0m"
}


function feng_set_android_time()
{
	adb root
	adb shell date -s `date +%G%m%d.%H%M%S`
}
