(*
This script should be saved as xxx.app for normal usage, please paste selected lines into another window of Script Editor for test purpose. Hold down Command key and drag xxx.app into Finder toolbar for convenient access. 

Inspired by https://github.com/lexrus/LTFinderButtons

ashfinal 2017.07.06
*)

global plistFilePath, prefDataPath, scriptVersion, runFaceless

-- Set version string when modified so we know if show updategreeting or not
-- Also remember to update showUpdateGreeting function if necessary
set scriptVersion to "1.16"
set runFaceless to "once" -- once/always/never

set userSupportPath to (path to application support from user domain)
set prefFolderName to "FinderButtons"
set plistFilePath to POSIX path of ((path to me as text) & "Contents:Info.plist" as alias)
-- Use bundleID for preferences folder name
set subDirName to item 2 of (getOrSetPlistItem(plistFilePath, "CFBundleIdentifier", missing value, missing value))
set prefFolderPath to (POSIX path of ((userSupportPath as alias)) as text) & prefFolderName & "/" & subDirName
-- Create directories recursively if they don't exist
do shell script "[[ -d " & quoted form of prefFolderPath & " ]] || mkdir -p " & quoted form of prefFolderPath
-- Use settings.plist for persist stroage
set prefDataPath to prefFolderPath & "/settings.plist"

-- Try to load previous preferences from prefDataPath
try
	tell application "System Events" to set prefDataFile to property list file prefDataPath
on error
	-- Create preferences file and set initial value
	tell application "System Events"
		set prefDataFile to make new property list file with properties {name:prefDataPath}
		make new property list item at end of prefDataFile with properties {kind:list, name:"extraKinds", value:{"Folder", "Application", "Xcode Playground", "Workflow"}}
		make new property list item at end of prefDataFile with properties {kind:string, name:"applicationFaceless", value:"whatever"}
		make new property list item at end of prefDataFile with properties {kind:boolean, name:"launchGreeting", value:true}
		make new property list item at end of prefDataFile with properties {kind:boolean, name:"updateGreeting", value:true}
	end tell
end try

-- Update versionstr if necessary, and show updateGreeting, reset applicationFaceless
if getOrSetPlistItem(plistFilePath, "CFBundleShortVersionString", missing value, missing value) ­ {true, scriptVersion} then
	getOrSetPlistItem(plistFilePath, "CFBundleShortVersionString", scriptVersion, string)
	getOrSetPlistItem(prefDataPath, "updateGreeting", true, boolean)
	getOrSetPlistItem(prefDataPath, "applicationFaceless", "whatever", string)
end if

-- Automatically determine whether to run faceless or not
-- Don't modify this block unless you know what you're doing
if getOrSetPlistItem(prefDataPath, "applicationFaceless", missing value, missing value) ­ {true, runFaceless} then
	set BGOnlyRead to getOrSetPlistItem(plistFilePath, "LSBackgroundOnly", missing value, missing value)
	if BGOnlyRead = {true, false} or BGOnlyRead = {false, missing value} then
		set currentRunBackground to false
	else if BGOnlyRead = {true, true} then
		set currentRunBackground to true
	end if
	if runFaceless is in {"once", "always"} and currentRunBackground = false then
		getOrSetPlistItem(prefDataPath, "updateGreeting", true, boolean)
		getOrSetPlistItem(plistFilePath, "LSBackgroundOnly", true, boolean)
		getOrSetPlistItem(prefDataPath, "applicationFaceless", runFaceless, string)
	else if runFaceless is in {"once", "never"} and currentRunBackground = true then
		getOrSetPlistItem(plistFilePath, "LSBackgroundOnly", false, boolean)
		-- LSBackgroundOnly must be false to do interactive settings
		display notification "Configuration Updated!" with title "Please relaunch the application"
		quit
	else if (runFaceless = "always" and currentRunBackground = true) or (runFaceless = "never" and currentRunBackground = false) then
		getOrSetPlistItem(prefDataPath, "updateGreeting", true, boolean)
		getOrSetPlistItem(prefDataPath, "applicationFaceless", runFaceless, string)
	else if runFaceless = "always" and currentRunBackground = false then
		getOrSetPlistItem(prefDataPath, "updateGreeting", true, boolean)
		getOrSetPlistItem(plistFilePath, "LSBackgroundOnly", true, boolean)
		getOrSetPlistItem(prefDataPath, "applicationFaceless", runFaceless, string)
	end if
end if

if getOrSetPlistItem(prefDataPath, "launchGreeting", missing value, missing value) = {true, true} then
	showLaunchGreeting()
	getOrSetPlistItem(prefDataPath, "launchGreeting", false, boolean)
end if

if getOrSetPlistItem(prefDataPath, "updateGreeting", missing value, missing value) = {true, true} then
	showUpdateGreeting()
	getOrSetPlistItem(prefDataPath, "updateGreeting", false, boolean)
end if


-- Do actual work here
set specifiedPath to getSelectedFinderPathWithFallback()
set cmdStr to "cd " & specifiedPath & ";clear;"
runCommandWithTerminal(cmdStr)

on showUpdateGreeting()
	-- Show update notification or interactively update configuration
end showUpdateGreeting

on showLaunchGreeting()
	-- Show first-time launching notification or interactively set the preferences
	display notification "Hold down Command key and drag xxx.app into Finder toolbar for convenient access."
end showLaunchGreeting

on getOrSetPlistItem(plistPath, propertyItem, itemValue, itemKind)
	tell application "System Events"
		set specifiedPlist to property list file plistPath
		try
			set specifiedListitem to property list item propertyItem of specifiedPlist
			if itemValue ­ missing value and itemKind ­ missing value then
				make new property list item at end of specifiedPlist with properties {kind:itemKind, name:propertyItem, value:itemValue}
			else
				return {true, value of specifiedListitem}
			end if
		on error eText number eNum
			if eNum = -1728 then
				if itemKind ­ missing value and itemValue ­ missing value then
					make new property list item at end of specifiedPlist with properties {kind:itemKind, name:propertyItem, value:itemValue}
				else
					return {false, missing value}
				end if
			else
				display notification eText with title "Error"
			end if
		end try
	end tell
end getOrSetPlistItem

on getSelectedFinderPathWithFallback()
	tell application "Finder"
		set selectedItems to selection as list
		if (count of selectedItems) ­ 1 then
			try
				set currentFinderPath to quoted form of POSIX path of (target of front window as alias)
			on error
				set currentFinderPath to quoted form of POSIX path of (path to home folder)
			end try
		else
			-- log kind of item 1 of selectedItems
			set extraKindsList to item 2 of getOrSetPlistItem(prefDataPath, "extraKinds", missing value, missing value) of me
			if (kind of item 1 of selectedItems as text) is in extraKindsList then
				set currentFinderPath to quoted form of POSIX path of (item 1 of selectedItems as alias)
			else
				set currentFinderPath to quoted form of POSIX path of (target of front window as alias)
			end if
		end if
	end tell
	return currentFinderPath
end getSelectedFinderPathWithFallback

on runCommandWithTerminal(commandstr)
	tell application "Terminal"
		activate
		try
			set currentTab to selected tab of front window
			if currentTab is busy then
				error "Terminal is busy!" number 999
			end if
		on error
			tell application "System Events"
				set frontmost of process "Terminal" to true
				keystroke "n" using command down
			end tell
			delay 0.5
			set currentTab to selected tab of front window
		end try
		do script commandstr in currentTab
	end tell
end runCommandWithTerminal
