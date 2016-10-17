#!/bin/bash
user=$1 
pass=$2
if [ $# -lt 4 ];
then
echo "Usage: $0 <username:$user> <password:$pass> -switch file"
exit -1
fi

for i in {1..4}
do
echo $1 
case $1 in
-d) shift; datafile=$1; shift ;;
-t) shift; datafile="test"; shift;;
*) url=${url:-$1}; shift;;
esac
done

if [ -d dps ]; then
	rm -Rf dps/*
fi

echo $user:$pass 
#$DEPTPri $SegmentID $SegmentName $startIP $endIP $LAST_MODIFY $FACILITY_ID    

#:echos line to txt file as XML:#
`curl -k -v -u 'administrator:pw' https://jss:port/JSSResource/distributionpoints/id/[1-9] -o 'dps/dps_#1.xml'`

#:upload XML file to JSS:#
#echo curl -k -v -u "'$user:$pass'" https://jss:port/JSSResource/distributionpoints/name/$_ADMNAME -T "dps/dps_$_ADMNAME.xml" -X POST
#`curl -k -v -u 'administrator:pw' https://jss:port/JSSResource/distributionpoints/name/$_ADMNAME -T "dps/dps_$_ADMNAME.xml" -X PUT`


exit 0
