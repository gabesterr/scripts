#!/bin/bash
#
LS1='/bin/ls -1'
PATH="/Library/Logs/DiagnosticReports"
GRC='/usr/bin/grep' 
AW1='/usr/bin/awk'
# PR1="-F ' ' '{print $1}'"
KP=$(${LS1} ${PATH} | ${GRC} "panic\|crash" | ${GRC} "Kernel" | /usr/bin/wc | ${AW1} -F ' ' '{print $1}')
LS=$(${LS1} ${PATH} | ${GRC} "panic\|crash" | /usr/bin/cut -d"_" -f 1)
KINDS=$(echo "$LS" | /usr/bin/uniq)
#echo $KP 
#echo "$(${LS1} ${PATH})" | ${GRC} "panic\|crash" | /usr/bin/cut -d"_" -f1
#echo $LS1
for KIND in $KINDS
do
	if [ "$KIND" != "Kernel" ]; then
		NUM=$(${LS1} ${PATH} | ${GRC} "panic\|crash" | ${GRC} "$KIND" | /usr/bin/wc | ${AW1} -F ' ' '{print $1}')
		if [ "$LOG" ]; then
			LOG="$LOG\n$NUM $KIND"
		else
			LOG="$NUM $KIND"
		fi
		NUM=""
	fi
done
LOG=$(echo "$LOG" | /usr/bin/sort -r)
MOSTRECENT=$(/bin/ls -l ${PATH} | ${GRC} "ernel" | ${GRC} -v "gpuRestart" | /usr/bin/cut -d"_" -f3 | /usr/bin/sort -r | /usr/bin/head -1) 
#echo $MOSTRECENT

#force INT from STRING for comparisons
KP=$(( $KP + 0 ))
if [ $KP -gt 1 ]; then
	LOG="$KP hard crashes on $MOSTRECENT\n$LOG"
elif [ $KP -eq 1 ]; then
	LOG="$KP hard crash on $MOSTRECENT\n$LOG"
fi

echo "<result>$LOG</result>"
