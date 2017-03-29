#!/bin/bash

# use this if you are restricting user's network prefpane access but they need to be able to connect to different wifi networks
# note that it won't be available offline :-( rank this up on JAMF: https://www.jamf.com/jamf-nation/feature-requests/222/self-service-work-offline

ap="ssidname"
ap=$(osascript -e 'text returned of (display dialog "Enter your SSID" default answer "'$ap'")')
pw=$(osascript -e 'text returned of (display dialog "Enter your pw" default answer "")')

#obviously you may want to do more error checking et cetera
if [ ! -z "$ap" -a  "$ap"!="" ]; then
	#pw=$(osascript -e 'text returned of (display dialog "Enter SSID '$ap'" password:" default answer "")')
	#echo $ap $pw
  networksetup -setairportnetwork en0 $ap $pw
fi

#/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport

#wifiscan=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -s | grep "Class1")

#[ $wifiscan ]

# need networksetup to find wireless adapters and their hardware interface ids - don't assume en1!

# run airport with wirless adapter for now use en0 for macbook 

#networksetup -setairportnetwork en0 Class1 Educlass1

#should improve to prompt for ssid / pw so users can join networks without admin privs

#ap=$(osascript -e 'text returned of (display dialog "Enter your SSID:" default answer "")')
#pw=$(osascript -e 'text returned of (display dialog "Enter SSID '$ap'" password:" default answer "")')
