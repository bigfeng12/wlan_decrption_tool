function fvim()
{
	file=`echo $1 | cut -d: -f1`
	line=`echo $1 | cut -d: -f2`
	#call vim
	if [ $line != $file ]
	then
		vim $file +$line
	else
		vim $file
	fi
}

function wgrep()
{
	echo "run grep wpa_supplicant"
	grep -nair -e wpa_supplicant -e wpa_p2p -e wpa_legacy -e wpa_ais -e wpa_driver -e wfa_dut $1 > $2
}
function dgrep()
{
	echo "run grep driver wlan"
	grep -nair -e mt6632 -e "wifi" -e "main_thread" -e "wmtd" -e "tx_thread" -e "rx_thread" -e "hif_thread" -e "\[wlan\]" -e wlan_gen -e wpa_supplicant $1 > $2
}
function ovim()
{
	echo "run find file and exec vim"
	find . -name $1 -exec vim {} \;
}

function gotots()
{
	echo "Go to Linux TS: mbjswglx947"
	echo "Keep SSH alive every 10 seconds"
	ssh mtk06167@mbjswglx947 -o ServerAliveInterval=10
}


function gotows()
{
	echo "Go To worktmp"
	cd /proj/mtk06167/.gvfs/sftp:host=mbjswglx947/worktmp/
}

##$1 is the file name
##$2 is the output file used to store the score if exsit
function wfdgetScore()
{

	if [ $# -gt 1 ]
	then
		echo "getScore(): have output file: $2"
		grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f2 > $2
		return
	fi
	echo "getScore(): have not output file"
	grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f2
}

function wfdgetNoTCEnqueue()
{
	if [ $# -gt 1 ]
	then
		echo "getNoTCEnqueue(): have output file: $2"
		grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f4 | \
			awk -F '#' '{print $1 + $2 + $3 + $4}' > $2
		return
	fi
	echo "getNoTCEnqueue(): have no output file"
	grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f4 | \
			awk -F '#' '{print $1 + $2 + $3 + $4}'
}

function wfdgetNoTCDequeue()
{
	if [ $# -gt 1 ]
	then
		echo "getNoTCDequeue(): have output file: $2"
		grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f6 | \
			awk -F '#' '{print $1 + $2 + $3 + $4}' > $2

		return
	fi
	echo "getNoTCenqueue(): have no output file"
	grep -nir -e "nwfd: no tc" $1 | cut -d* -f2 | cut -d: -f6 | \
			awk -F '#' '{print $1 + $2 + $3 + $4}'
}

function wfdgetTxTotalCnt()
{
	echo "getTxTotalCnt(): WARNING! need raw log"
	if [ $# -gt 1 ]
	then
		echo "getTxTotalCnt(): have output file: $2"
		grep -nir -e "WifiHW  : total_cnt=" $1 | cut -d= -f2 > $2
		return
	fi
	echo "getTxTotalCnt(): have no output file"
	grep -nir -e "WifiHW  : total_cnt=" $1 | cut -d= -f2
}

function wfdgetThresholdCnt()
{
	echo "getThresholdCnt(): WARNING! need raw log"
	if [ $# -gt 1 ]
	then
		echo "getThresholdCnt(): have output file: $2"
		grep -nir -e "WifiHW  : threshold_cnt="  $1 | cut -d= -f2 > $2
		return
	fi
	echo "getThresholdCnt(): have no output file"
	grep -nir -e "WifiHW  : threshold_cnt="  $1 | cut -d= -f2
}

function wfdgetRCwanted()
{
	if [ $# -gt 1 ]
	then
		grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f1 > $2
		return
	fi
	grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f1
}

function wfdgetRCused()
{
	if [ $# -gt 1 ]
	then
		grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f2 > $2
		return
	fi
	grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f2
}

function wfdgetRCback()
{
	if [ $# -gt 1 ]
	then
		grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f3 > $2
		return
	fi
	grep -nir -e "nwfd: tc res inf" $1 | cut -d* -f2 | cut -d# -f6 | cut -d: -f3
}

function createSnapShot()
{
	echo "create snapShot: $1"
	mtk-spice-snapshot --action create --workspaceRef $1
}

function deleteSnapShot()
{
	echo "create snapShot: $1"
	mtk-spice-snapshot --action delete --workspaceRef $1
}

function fenableFWlog()
{
	adb remount
	adb shell "echo \'module wlan_gen2 +p\' > sys/kernel/debug/dynamic_debug/control"
	adb shell "echo c 0xf0080040 0x1 > /proc/driver/wmt_dbg"
	adb shell "echo 0x16 0x1 0x0 >/proc/driver/wmt_dbg &"
}


function finitrepo()
{
	echo "init repo with branch: $1"
	/mtkoss/git/mtk_repo init -u \
	http://gerrit.mediatek.inc:8080/alps/platform/manifest \
	-b $1 \
	-m manifest-one.xml
}

function freposync()
{
	/mtkoss/git/mtk_repo sync -c --no-tags
}
