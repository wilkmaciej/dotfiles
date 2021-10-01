#	Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool true
defaults write com.apple.desktopservices "DSDontWriteUSBStores" -bool true

#	Expand the following File Info panes:
#	“General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

#	System Preferences

#	Dock and menu bar
osascript -e '
tell application "System Preferences"
	activate
	reveal pane id "com.apple.preference.dock"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1
	
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
	tell tab group 1 of window 1
		tell pop up button 1
			click
			delay 0.5
			click menu item 1 of menu 1
		end tell
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Enable automatic updates
osascript -e '
tell application "System Preferences"
	activate
	set the current pane to pane id "com.apple.preferences.softwareupdate"
end tell
tell application "System Events" to tell application process "System Preferences"
	delay 1
	tell group 2 of window 1 to tell checkbox 1
		if not (its value as boolean) then click it
	end tell
end tell
delay 1
tell application "System Preferences" to quit'

#	Sound
osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "effects" of pane id "com.apple.preference.sound"
end tell
tell application "System Events" to tell application process "System Preferences"
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

#	Enable F keys insted of media keys, change repet speed to max, key globe change input source, enable keyboard navigation
osascript -e '
tell application "System Preferences"
	activate
	reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
end tell
tell application "System Events" to tell process "System Preferences"
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
tell application "System Events" to tell process "System Preferences"
	delay 1
	tell checkbox 1 of tab group 1 of window 1
		if not (its value as boolean) then click it
	end tell
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
	try
		tell group 1 of window 1 to tell tab group 1
			click radio button "Scaled"
			tell radio group 1 of group 1
				click radio button 4
			end tell
		end tell
	on error
		tell tab group 1 of window 1
			click radio button "Scaled"
			tell radio group 1 of group 1
				click radio button 4
			end tell
		end tell
	end try
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
	delay 0.5
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
defaults write com.apple.dock "tilesize" -int 50
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

defaults write com.sindresorhus.Plash websites -array '"{\"usePrintStyles\":false,\"isCurrent\":true,\"invertColors2\":\"never\",\"id\":\"7CBC4207-3B90-463C-8935-853FAF0AAA12\",\"title\":\"Stars\",\"css\":\"\",\"javaScript\":\"\",\"invertColors\":false,\"url\":\"file:\\/\\/\\/Users\\/wilkmaciej\\/.plash\\/\"}"'

# Stats
open /Applications/Stats.app
sleep 1
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

defaults write com.knollsoft.Rectangle "snapEdgeMarginTop" -int 50
defaults write com.knollsoft.Rectangle "snapEdgeMarginBottom" -int 10
defaults write com.knollsoft.Rectangle "snapEdgeMarginLeft" -int 10
defaults write com.knollsoft.Rectangle "snapEdgeMarginRight" -int 10
defaults write com.knollsoft.Rectangle "launchOnLogin" -int 0
defaults write com.knollsoft.Rectangle "SUHasLaunchedBefore" -int 1
defaults write com.knollsoft.Rectangle "hideMenubarIcon" -int 1
open /Applications/Rectangle.app

# delete all items
sudo osascript -e 'tell application "System Events" to delete every login item'

# add login items
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Displaperture.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/CopyClip.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Stats.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Plash.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item with properties {path:"Applications/Rectangle.app", hidden:true}'