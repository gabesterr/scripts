-- from http://hints.macworld.com/article.php?story=20030913153245341
-- also from http://www.mosasaur.com/projects/applescript.html for timestamp, leading zero code,
-- updated using working code from here: https://hea-www.harvard.edu/~fine/OSX/safari-tabs.html

tell application "Safari"
	set urlList to {}
	set nameList to {}
	set winList to every window
	repeat with win in winList
		set OK to true
		try
			set tablist to every tab of win
		on error errmsg
			-- display dialog name of win as string 
			set ok to false
		end try
		if ok then
			repeat with t in tablist
				set tabname to (name of t as string)
				set tabURL to (URL of t as string)
				set end of urlList to tabURL
				set end of nameList to tabname
			end repeat
		end if
	end repeat
--        try
--		set urlList to URL of tab of every window where its document is not missing value
--	on error errMsg number errNum
--		beep
--		tell me to display dialog "Error: " & errMsg & return & "Error Number: " & errNum
--	end try
--	try
--		set nameList to name of tab of every window where its document is not missing value
--	on error errMsg number errNum
--		beep
--		tell me to display dialog "Error: " & errMsg & return & "Error Number: " & errNum
--	end try
end tell

set listTextItems to ""
set i to 1

repeat with TextItem in urlList
	set NameItem to item i of nameList
	--	display dialog (i as text) & ": " & NameItem
	--	set subText to ""
	--	set j to 1
	--	display dialog TextItem
	--if (number of text items in TextItem) > 1 then
		--display dialog TextItem as text
		--repeat with subText in TextItem
		--	set NameText to item j of NameItem
		--	set listTextItems to (((listTextItems & "
<p>" & NameItem's text items as text) & "&nbsp;<a href=\"" & subText's text items as text) & "\">" & subText's text items as text) & "</a>"
		--	set j to j + 1
		--end repeat
	--else
		set listTextItems to (((listTextItems & "<p>" & NameItem's text items as text) & "&nbsp;<a href=\"" & TextItem's text items as text) & "\">" & TextItem's text items as text) & "</a>"
	--end if
	set i to i + 1
end repeat

set writeData to listTextItems
--set writeData to every item of urlList as text

set htmlheader to "<html><body>
"
set htmlfooter to "
</body></html>"


write_URL_log(htmlheader & writeData & htmlfooter)

on write_URL_log(SomeData)
	set the URL_log to ((path to desktop) as text) & "URL_" & getTimeStamp() & ".html"
	try
		open for access file the URL_log with write permission
		write (SomeData) to file the URL_log starting at eof
		close access file the URL_log
	on error
		try
			close access file the URL_log
		end try
	end try
end write_URL_log

on getTimeStamp()
	tell (current date)
		set theMonth to addLeadingZeros((its month as number), 1) of me
		set theDay to addLeadingZeros((its day as number), 1) of me
		set dateValue to (year as string) & theMonth & theDay
		set timeValue to its time
		set timeStamp to dateValue & timeValue
	end tell
end getTimeStamp

on addLeadingZeros(thisNumber, maxLeadingZeros)
	set the thresholdNumber to (10 ^ maxLeadingZeros) as integer
	if thisNumber is less than the thresholdNumber then
		set the leadingZeros to ""
		set the digitCount to the length of ((thisNumber div 1) as string)
		set the characterCount to (maxLeadingZeros + 1) - digitCount
		repeat characterCount times
			set the leadingZeros to (the leadingZeros & "0") as string
		end repeat
		return (leadingZeros & (thisNumber as text)) as string
	else
		return thisNumber as text
	end if
end addLeadingZeros
