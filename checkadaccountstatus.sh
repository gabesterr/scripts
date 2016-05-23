#!/bin/bash
pwPolicy=179
processLine(){
	line="$@"
echo "${line}" -O
}

if [ "$1" == "" ]; then
	user=`whoami`
else
   user="$1"
fi

#use dscl in interactive mode to find out ADdomain
DOMAINNAME="yourdomain"
userRecord=`dscl localhost -read /Active\ Directory/$DOMAINNAME/All\ Domains/Users/$user`
badpwtime=`echo "$userRecord" | grep -i badPasswordTime | sed 's/dsAttrTypeNative:badPasswordTime://'`
badpwcount=`echo "$userRecord" | grep -i badPwdCount | sed 's/dsAttrTypeNative:badPwdCount://'`
userLock=`echo "$userRecord" | grep -i lockoutTime | sed 's/dsAttrTypeNative:lockoutTime://'`
#lastpwdMS=`echo "$userRecord" | grep -i pwdLastSet | sed 's/dsAttrTypeNative:pwdLastSet: //'`
#todayUnix=`date "+%s"`
#lastpwdUnix=`expr $lastpwdMS / 10000000 - 11644473600`
#diffUnix=`expr $todayUnix - $lastpwdUnix`
#diffdays=`expr $diffUnix / 86400`
#daysremaining=`expr $pwPolicy - $diffdays`
if [ "$badpwcount" == "" ]; then
	displaybadpw=" no recent bad passwords."
else
nowUnix=`date "+%s"`
badpwdUnix=`expr $badpwtime / 10000000 - 11644473600`
diffUnix=`expr $nowUnix - $badpwdUnix`
badpwmins=`expr $diffUnix / 60`


	displaybadpw=`echo " with " $badpwcount " bad passwords in " $badpwmins " minutes"` 
fi
echo $user " locktime: " $userLock $displaybadpw

