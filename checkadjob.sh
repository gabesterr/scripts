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
#userRecord=`dscl localhost -read /Active\ Directory/$DOMAINNAME/All\ Domains/Users/$user distinguishedName`
userRecord=`dscl localhost -read /Active\ Directory/$DOMAINNAME/All\ Domains/Users/$user JobTitle | sed 's/dsAttrTypeNative:distinguishedName://'`
echo $user " : " $userRecord
