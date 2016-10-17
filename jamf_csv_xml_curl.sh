#!/bin/bash

#from http://bashscripts.org/forum/viewtopic.php?f=8&t=1330

#:Read variables from XMLInput.csv:#
while read inputline;do
line0="$(echo $inputline | cut -d, -f1)"
line1="$(echo $inputline | cut -d, -f2)"
echo 

#:Set auto increment ID:#
idAdd0=$((idAdd0 +1))

#:removes trailing alpha characters leaving only the IP address:#
cutLine0=${line0//[^0-9.]/}

#:Strips trailing octet and appends .1:#
startIP=`echo $cutLine0 | sed 's/\.[0-9]*$/.1/'`

#:Strips trailing octet and appens 254:#
endIP=`echo $cutLine0 | sed 's/\.[0-9]*$/.254/'`

#:echos line to txt file as XML:#
echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'"<network_segment><id>"$idAdd0"</id><name>$line0</name><starting_address>$startIP</starting_address><ending_address>$endIP</ending_address><distribution_point/><url/><netboot_server/><swu_server/><building>$line1</building><department/><override_buildings>false</override_buildings><override_departments>false</override_departments></network_segment>" >> subnetsxml/xmldata$idAdd0.xml

#:upload XML file to JSS:#
#`curl -k -v -u account:Password https://server address/JSSResource/networksegments/name/SegmentName -T "xmldata$idAdd0.xml" -X POST`

done < XMLInput.csv

exit 0
