#!/bin/bash

processLine(){
	line="$@"
  
ECHO "${line}" -O
}

if [ "$1" == "" ]; then
	user=`whoami`
else
   user="$1"
fi

#use dscl in ineractive mode to find out ADdomain
ADdomain="All\ Domains"
DOMAINNAME="yourdomain"
#userRecord=`dscl localhost -read /Active\ Directory/DOMAINNAME/All\ Domains/Users/$user distinguishedName`
#userRecord=`dscl localhost -read /Active\ Directory/DOMAINNAME/All\ Domains/Users/$user JobTitle distinguishedName`
#userRecord=`dscl localhost -read /Active\ Directory/DOMAINNAME/All\ Domains/Users/$user distinguishedName JobTitle | sed 's/dsAttrTypeNative:distinguishedName://' | sed 's/DC=cps,DC=k12,DC=il,DC=us//' | sed 's/JobTitle://'`
userRecord=`dscl localhost -read /Active\ Directory/$DOMAINNAME/All\ Domains/Users/$user distinguishedName JobTitle PhoneNumber | sed 's/dsAttrTypeNative:distinguishedName://' | sed 's/DC=domain,DC=name,DC=tld//' | sed 's/JobTitle//' | tr ":" "\n"`
# CN=000080736,OU=anou,OU=anotherou,DC=domain,DC=name,DC=tld JobTitle: Principal
#
#jobTitle=`($userRecord | sed 's/JobTitle://')`
echo $userRecord #" : " $userJob #" : " $userDN  

