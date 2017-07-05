#/bin/bash

# function used to covert user space time to sec.msec
# format:
# raw data:
#  10:55:11.283965
#  10:55:08.771462
# after covert:
#  39308.771462
#  39311.283965

function feng_user_time()
{
	if [ $# -lt 2 ]
	then
		echo "userage: user_time in.file out.file"
		return
	fi

	cat /dev/null > $2

	for i in `cat $1 | cut -d' ' -f2`
	do
		timestmp=`echo $i`
		hour=`echo $timestmp | cut -d: -f1`
		mini=`echo $timestmp | cut -d: -f2`
		msecs=`echo $timestmp | cut -d: -f3`

		total_secDotmsec=`echo "$hour * 3600 + $mini * 60 + $msecs" | bc`
		echo "total_secDotmsec $total_secDotmsec"
		echo $total_secDotmsec >> $2
	done
}
