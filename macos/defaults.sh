#	Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool true
defaults write com.apple.desktopservices "DSDontWriteUSBStores" -bool true

#	Expand the following File Info panes:
#	“General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Preview -bool false \
	Privileges -bool true

defaults write com.apple.finder "NewWindowTarget" -string "PfLo"
defaults write com.apple.finder "NewWindowTargetPath" -string "file:///Applications/"

defaults write com.apple.finder "SidebarTagsSctionDisclosedState" -bool false
defaults write com.apple.finder "SidebariCloudDriveSectionDisclosedState" -bool false
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool false

#	System Preferences

osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "Privacy" of pane id "com.apple.preference.security"
end tell

tell application "System Events" to tell application process "System Preferences"
	delay 1

	display alert "Enable Accesability access for terminal and confirm" as informational

end tell
delay 1
tell application "System Preferences" to quit'

#	Dock and menu bar
osascript -e '
tell application "System Preferences"
	activate
	reveal pane id "com.apple.preference.dock"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	display alert "Click element of scroll area to continue" as informational

	repeat until scroll area 1 of window 1 exists
		delay 0.5
	end repeat

	
	tell scroll area 1 of window 1
		select row 1 of outline 1
	end tell
	delay 0.5
	tell checkbox 6 of window 1
		if (its value as boolean) then click it
	end tell
	delay 0.5
	tell scroll area 1 of window 1
		select row 3 of outline 1
	end tell
	delay 0.5
	tell checkbox 1 of window 1
		if (its value as boolean) then click it
	end tell
	delay 0.5
	tell scroll area 1 of window 1
		select row 11 of outline 1
	end tell
	delay 0.5
	tell checkbox 1 of window 1
		if (its value as boolean) then click it
	end tell
	delay 0.5
	tell scroll area 1 of window 1
		select row 14 of outline 1
	end tell
	delay 0.5
	tell checkbox 1 of window 1
		if (its value as boolean) then click it
	end tell
	delay 0.5
	tell scroll area 1 of window 1
		select row 17 of outline 1
	end tell
	delay 0.5
	tell checkbox 3 of window 1
		if not (its value as boolean) then click it
	end tell
	delay 0.5
	tell checkbox 6 of window 1
		if not (its value as boolean) then click it
	end tell
	delay 0.5
	tell scroll area 1 of window 1
		select row 18 of outline 1
	end tell
	delay 0.5
	tell checkbox 1 of window 1
		if (its value as boolean) then click it
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Lock screen imidiately after sleep
osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "General" of pane id "com.apple.preference.security"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	tell pop up button 1 of tab group 1 of window 1
		click
		delay 0.5
		click menu item 1 of menu 1
	end tell
end tell
delay 1
repeat while true
	try
		tell application "System Preferences" to quit
		exit repeat
	on error
		delay 5
	end try
end repeat'

#	Disable automatic updates
osascript -e '
tell application "System Preferences"
	activate
	set the current pane to pane id "com.apple.preferences.softwareupdate"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	tell window 1
		tell group 2
			click button 3
		end tell
		tell sheet 1 to tell checkbox 1
			if (its value as boolean) then click it
		end tell
	end tell
end tell
delay 1
repeat while true
	try
		tell application "System Preferences" to quit
		exit repeat
	on error
		delay 5
	end try
end repeat'

#	Sound
osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "effects" of pane id "com.apple.preference.sound"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	tell checkbox 2 of window 1
		if (its value as boolean) then click it
	end tell
	tell checkbox 2 of tab group 1 of window 1
		if not (its value as boolean) then click it
	end tell
	tell checkbox 3 of tab group 1 of window 1
		if (its value as boolean) then click it
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Enable F keys insted of media keys, change repeat speed to max, key globe change input source, enable keyboard navigation
osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	tell tab group 1 of window 1
		set value of every slider to 10
		tell pop up button 2
			click
			delay 0.5
			click menu item 1 of menu 1
		end tell
		tell checkbox 3
			if not (its value as boolean) then click it
		end tell
	end tell
end tell
tell application "System Preferences"
	activate
	reveal anchor "shortcutsTab" of pane "com.apple.preference.keyboard"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	tell checkbox 1 of tab group 1 of window 1
		if not (its value as boolean) then click it
	end tell
	keystroke "	"
	delay 0.5
	keystroke "	"
	delay 0.5
	repeat 10 times
		key code 126
		delay 0.1
	end repeat
	repeat 3 times
		key code 125
		delay 0.1
	end repeat
	
	set x to 0
	
	repeat until x is equal to (count of rows of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1)
		set x to x + 1
		tell checkbox 1 of UI element 1 of row x of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
			if (its value as boolean) then click it
		end tell
	end repeat
	
	repeat 3 times
		key code 125
		delay 0.1
	end repeat
	
	set x to 0
	
	repeat until x is equal to (count of rows of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1)
		set x to x + 1
		tell checkbox 1 of UI element 1 of row x of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
			if (its value as boolean) then click it
		end tell
	end repeat
	
	key code 125
	delay 0.5
	
	set x to 0
	
	repeat until x is equal to (count of rows of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1)
		set x to x + 1
		try
			tell checkbox 1 of UI element 1 of row x of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
				if (its value as boolean) then click it
			end tell
		end try
	end repeat
	
end tell
delay 1
tell application "System Preferences" to quit'

#	Screenshot shortcut
sudo osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "shortcutsTab" of pane "com.apple.preference.keyboard"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1

	keystroke "	"
	delay 0.5
	keystroke "	"
	delay 0.5
	repeat 10 times
		key code 126
		delay 0.1
	end repeat
	repeat 4 times
		key code 125
		delay 0.1
	end repeat
	set x to 0
	
	repeat until x is equal to (count of rows of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1)
		set x to x + 1
		tell checkbox 1 of UI element 1 of row x of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
			if (its value as boolean) then click it
		end tell
	end repeat
	click checkbox 1 of UI element 1 of row 4 of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
	click checkbox 1 of UI element 1 of row 5 of outline 1 of scroll area 2 of splitter group 1 of tab group 1 of window 1
	delay 1
	keystroke "	"
	repeat 3 times
		key code 125
	end repeat
	repeat 2 times
		keystroke "	"
	end repeat
	delay 0.5
	key code 122 using option down
	repeat 4 times
		key code 125
	end repeat
	repeat 2 times
		keystroke "	"
	end repeat
	delay 0.5
	key code 120 using option down
end tell
delay 1
tell application "System Preferences" to quit'

#	Change resolution
sudo osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "displaysDisplayTab" of pane id "com.apple.preference.displays"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1
	tell group 1 of window 1
		repeat until radio group 1 exists
			delay 0.5
		end repeat
		tell radio group 1
			click radio button "Scaled"
		end tell
		delay 0.5
		try
			click button "Resolution1" of UI element 3
		end try
		tell checkbox 1
			if (its value as boolean) then click it
		end tell
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Dont dim on battery power
osascript -e '
tell application "System Preferences"
	activate
	set the current pane to pane id "com.apple.preference.battery"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1
	tell scroll area 1 of window 1
		select row 2 of table 1
	end tell
	delay 0.5
	tell checkbox 2 of group 1 of window 1
		if (its value as boolean) then click it
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Dock

defaults delete com.apple.dock "persistent-apps"
defaults write com.apple.dock "minimize-to-application" -bool true
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "autohide" -bool true
defaults write com.apple.dock "tilesize" -int 75
killall Dock

#	Use AirDrop over every interface
defaults write com.apple.NetworkBrowser "BrowseAllInterfaces" 1

#	Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

#	Plash
defaults write com.sindresorhus.Plash "SS_hasLaunched" -bool true
defaults write com.sindresorhus.Plash "hideMenuBarIcon" -bool true
defaults write com.sindresorhus.Plash "showOnAllSpaces" -bool true
mkdir -p $HOME/.plash/
cp ./macos/plash.html $HOME/.plash/index.html
defaults write com.sindresorhus.Plash websites -array '"{\"usePrintStyles\":false,\"isCurrent\":true,\"invertColors2\":\"never\",\"id\":\"6E009A39-16FE-4EA8-B262-57F6877B8051\",\"title\":\"stars\",\"css\":\"\",\"javaScript\":\"\",\"invertColors\":false,\"url\":\"file:\\/\\/\\/Users\\/wilkmaciej\\/.plash\"}"'
open /Applications/Plash.app

#	Stats
open /Applications/Stats.app
sudo osascript -e '
repeat until application "Stats" is running
	delay 0.5
end repeat'
killall Stats
defaults write eu.exelban.Stats "BAT_mini_color" -string "system"
defaults write eu.exelban.Stats "BAT_mini_label" -bool false
defaults write eu.exelban.Stats "Battery_lowLevelNotification" -string "Disabled"
defaults write eu.exelban.Stats "Battery_state" -bool true
defaults write eu.exelban.Stats "Battery_widget" -string "mini"
defaults write eu.exelban.Stats "CPU_mini_color" -string "utilization"
defaults write eu.exelban.Stats "CPU_mini_label" -bool false
defaults write eu.exelban.Stats "Disk_state" -bool false
defaults write eu.exelban.Stats "Network_speed_icon" -string "dots"
defaults write eu.exelban.Stats "RAM_state" -bool false
defaults write eu.exelban.Stats "update-interval" -string "Once per day"
open /Applications/Stats.app

# 	Rectangle
defaults write com.knollsoft.Rectangle "snapEdgeMarginTop" -int 50
defaults write com.knollsoft.Rectangle "snapEdgeMarginBottom" -int 50
defaults write com.knollsoft.Rectangle "snapEdgeMarginLeft" -int 50
defaults write com.knollsoft.Rectangle "snapEdgeMarginRight" -int 50
defaults write com.knollsoft.Rectangle "launchOnLogin" -int 0
defaults write com.knollsoft.Rectangle "SUHasLaunchedBefore" -int 1
defaults write com.knollsoft.Rectangle "hideMenubarIcon" -int 1
open /Applications/Rectangle.app

#	Raycast
defaults write com.raycast.macos "onboardingSkipped" -int 1
defaults write com.raycast.macos "raycastGlobalHotkey" -string "Command-49"
defaults write com.raycast.macos "NSStatusItem Visible raycastIcon" -int 0
defaults write com.raycast.macos "popToRootTimeout" -int 0
defaults write com.raycast.macos "boostRankingByPreviousSearches" -int 1
open /Applications/Raycast.app

#	Alt Tab
defaults write com.lwouis.alt-tab-macos "menubarIcon" -int 3
defaults write com.lwouis.alt-tab-macos "holdShortcut" -string "\\U2318"
defaults write com.lwouis.alt-tab-macos "hideWindowlessApps" -bool true
defaults write com.lwouis.alt-tab-macos "updatePolicy" -int 2
defaults write com.lwouis.alt-tab-macos "crashPolicy" -int 2
open /Applications/AltTab.app

#	Delete all login items and add new ones
sudo osascript -e 'tell application "System Events" to delete every login item'

osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Plash.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Rectangle.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Stats.app", hidden:true}'
