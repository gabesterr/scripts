#!/bin/bash

#from http://bashscripts.org/forum/viewtopic.php?f=8&t=1330
#modified to reflect need to collect from subnets.csv the start IP, mask, dept #, description

#:Read variables from School_Subnets.csv:#
#"DEPT_ID","OWNING_UNIT","IP_SUBNET","IP_SUBNET_MASK_BITS","DNS_PRIMARY_IP","DNS_SECONDARY_IP","WINS_PRIMARY_IP","WINS_SECONDARY_IP","VLAN","VLAN_NAME","PRIMARY_DEPARTMENT","SCANNER_ENABLED",
#subnet_id,IP_SUBNET,ip_subnet_mask_bits,LOC_ROOM_NUM,COMMENT
#2,10.10.10.0,24,MANAGEMENT,Cluster 1/Region 1,Office
#distsrv_name,departmentcount,LAST_MODIFY,primary_department,FACILITY_ID
#ID-SRV01,4,9/25/2012,LocType/12345,54321

while read inputline;do
SegmentID="$(echo $inputline | cut -d, -f1)"
IPSubNet="$(echo $inputline | cut -d, -f2)"
IPSNMask="$(echo $inputline | cut -d, -f3)"
ROOM_NUM="$(echo $inputline | cut -d, -f4)"
_COMMENT="$(echo $inputline | cut -d, -f5)"
_ADMNAME="$(echo $inputline | cut -d, -f6)"
DEPT_COUNT="$(echo $inputline | cut -d, -f7)"
LAST_MODIFY="$(echo $inputline | cut -d, -f8)"
DEPTPri="$(echo $inputline | cut -d, -f9)"
FACILITY_ID="$(echo $inputline | cut -d, -f10)"
echo 

#:Set auto increment ID:#
#idAdd0=$((idAdd0 +1))

#:removes trailing alpha characters leaving only the IP address:#
#cutLine0=${line0//[^0-9.]/}

#:Strips trailing octet and appends .1:#
startIP=`echo $IPSubNet | sed 's/\.[0-9]*$/.1/'`

#:Strips trailing octet and appends 254:#
#WILL ACTUALLY NEED TO DO MATH HERE TO CALCULATE PROPER RANGES#
endIP=`echo $IPSubNet | sed 's/\.[0-9]*$/.254/'`

Romment="$ROOM_NUM $_COMMENT"
if [ "$_COMMENT" == "$ROOM_NUM" ]; then
	Romment="$_COMMENT"
fi
if [ "$_COMMENT" == "NULL" ]; then 
	Romment="$ROOM_NUM"
	if [ "$ROOM_NUM" == "NULL" ]; then 
		Romment="" 
	fi

fi

if [ "$LAST_MODIFY" == "NULL" ]; then
	LAST_MODIFY=""
fi

SegmentName="$_ADMNAME $DEPTPri $FACILITY_ID $SegmentID $Romment $LAST_MODIFY"

#DP-<Facility_ID>-<VLAN_Floor/Room|VLAN_COMMENT|VLAN_CODE_A-or-I-OBSOLETED>

#echo $SegmentName
#$DEPTPri $SegmentID $SegmentName $startIP $endIP $LAST_MODIFY $FACILITY_ID    

#:echos line to txt file as XML:#
echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'"<network_segment><id>$SegmentID</id><name>$SegmentName</name><starting_address>$startIP</starting_address><ending_address>$endIP</ending_address><distribution_point>$_ADMNAME</distribution_point><url/><netboot_server/><swu_server>$_ADMNAME</swu_server><building>$FACILITY_ID</building><department>$DEPTPri</department><override_buildings>false</override_buildings><override_departments>false</override_departments></network_segment>" # >> subnetsxml/subnets_$idAdd0.xml

#<?xml version="1.0" encoding="UTF-8" standalone="no"?><network_segment><id>2</id><name>3rd Floor DC</name><starting_address>10.129.160.1</starting_address><ending_address>10.129.160.254</ending_address><distribution_point/><url/><netboot_server/><swu_server/><building>Central Office</building><department>Central Office</department><override_buildings>true</override_buildings><override_departments>true</override_departments></network_segment>


#:upload XML file to JSS:#
#`curl -k -v -u 'admin:pw' https://jssserver/JSSResource/networksegments/name/SegmentName -T "xmldata$idAdd0.xml" -X POST`

done < subnetdepartments.csv

exit 0

#better way than while read inputline!!!
IFS=','
while read id old new; do
	curl -k -u 'jpa':'jamf' \
"https://jss:8443/JSSResource/departments/id/$id" -X PUT \ 
-H "content-type: application/xml" \
-d "<department>
	<name>$new Dept</name>
    </department>"
done < /path/to/some/file
