use framework "Foundation"
use framework "Vision"
use scripting additions
-- text from image from https://www.macscripter.net/t/image-png-to-text-through-applescript/74490/15 
-- basic droplet function from https://gist.github.com/peteburtis/8592257
-- basic droplet processing from https://forums.macrumors.com/threads/applescript-droplets-and-large-folders.1349476/
-- maybe some from https://www.macscripter.net/t/dropping-an-open-folder-and-its-contents-on-a-droplet/57212/3 
-- link not used https://apple.stackexchange.com/questions/100399/running-an-as-droplet-from-terminal
-- link not used https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ProcessDroppedFilesandFolders.html
-- link not used https://discussions.apple.com/thread/253076267?sortBy=rank
-- link not used https://www.macscripter.net/t/applescript-for-beginners-ix-getting-the-drop-on-droplets/45791
-- GOOGLE applescript droplet "on open" multiple files
-- added from https://github.com/gabesterr/scripts/blob/master/saveopensafariurls.applescript to save text file output

on open dropItems
	if number of dropItems is 1 then
		set dropInfo to "Processing " & name of (info for first item of dropItems)
	else
		set dropInfo to "Processing " & number of items in dropItems
	end if
	display notification dropInfo
	set the_Text to "Processing files on " & getTimeStamp() & return
	repeat with i from 1 to count of dropItems
		set this_item to item i of dropItems
		set item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			if (folder of item_info is false) then
				process_item(this_item)
			end if
		end if
		set the_Text to the_Text & name of item_info & return
	end repeat
	write_File_log(the_Text, "Macintosh HD:Users:gabester:Desktop:", "log for " & (name of me as text))
end open

on run
	set theFile to (choose file with prompt "Select a file for automation.")
	process_item(theFile)
end run

on process_folder(this_folder)
	set these_items to list folder this_folder without invisibles
	repeat with i from 1 to the count of these_items
		set this_item to alias ((this_folder as Unicode text) & (item i of these_items))
		set the item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			if (alias of the item_info is false) then
				process_item(this_item)
			end if
		end if
	end repeat
end process_folder

on process_item(theFile)
	tell application "Finder"
		set thePath to (container of theFile) as text
		set theName to (name of theFile) as text
		--display dialog thePath & " has " & theName
		set oldDelims to AppleScript's text item delimiters
		set AppleScript's text item delimiters to {"."}
		try
			set nameWithoutExtension to (text items 1 thru -2 of theName) as string
		on error
			set nameWithoutExtension to theName
		end try
		set AppleScript's text item delimiters to oldDelims
	end tell
	set theText to getText(theFile)
	set textHeader to "== text extracted from " & theFile & ": 
"
	set textFooter to "
== text extraction completed " & getTimeStamp()
	set theData to textHeader & theText & textFooter
	write_File_log(theData, thePath, nameWithoutExtension)
end process_item

on getText(sourceFile)
	set myFile to current application's |NSURL|'s fileURLWithPath:(POSIX path of sourceFile)
	set requestHandler to current application's VNImageRequestHandler's alloc()'s initWithURL:myFile options:(missing value)
	set theRequest to current application's VNRecognizeTextRequest's alloc()'s init()
	theRequest's setAutomaticallyDetectsLanguage:true -- test this first
	-- theRequest's setRecognitionLanguages:{"en", "fr"} -- if the above doesn't work
	theRequest's setUsesLanguageCorrection:false -- language correction if desired but not Chinese
	requestHandler's performRequests:(current application's NSArray's arrayWithObject:(theRequest)) |error|:(missing value)
	set theResults to theRequest's results()
	set theArray to current application's NSMutableArray's new()
	repeat with aResult in theResults
		(theArray's addObject:(((aResult's topCandidates:1)'s objectAtIndex:0)'s |string|()))
	end repeat
	return (theArray's componentsJoinedByString:tab) as text -- return a string
end getText

on write_File_log(SomeData, thePath, nameWithoutExtension)
	set the URL_log to thePath & nameWithoutExtension & "_" & getTimeStamp() & ".txt"
	tell application "Finder"
		try
			open for access file the URL_log with write permission
			write (SomeData) to file the URL_log starting at eof
			close access file the URL_log
		on error
			try
				close access file the URL_log
			end try
		end try
	end tell
end write_File_log

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
