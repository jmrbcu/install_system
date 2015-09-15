# SETTINGS
# General
set -o nounset # Exit, with error message, when attempting to use an undefined variable.
set -o errexit # Abort script at first error, when a command exits with non-zero status.
set -o pipefail # Returns exit status of the last command in the pipe that returned a non-zero return value.
IFS=$'\n\t' # Defines how Bash splits words and iterates arrays. This defines newlines and tabs as delimiters.
export SYSTEM_LABEL=Snakebite # Placeholder for system display name.
export SYSTEM_NAME=snakebite # Placeholder for system name.
export WORK_PATH=/tmp/downloads # Temporary location for processing of file downloads and installers.

# Applications

# iterm
export ITERM_APP_NAME=iTerm.app
export ITERM_APP_URL="https://iterm2.com/downloads/stable/iTerm2-2_1_1.zip"

# App Cleaner
export APP_CLEANER_APP_NAME=AppCleaner.app
export APP_CLEANER_APP_URL="http://www.freemacsoft.net/downloads/AppCleaner_2.3.zip"

# BetterTouchTool
export BETTERTOUCH_APP_NAME=BetterTouchTool.app
export BETTERTOUCH_APP_URL="http://bettertouchtool.net/BetterTouchTool.zip"

# Sublime Text 3
export SUBLIME_TEXT_APP_NAME="Sublime Text.app"
export SUBLIME_TEXT_APP_URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203083.dmg"

# google chrome
export CHROME_APP_NAME="Google Chrome.app"
export CHROME_APP_URL="https://dl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"

# sequel pro
export SEQUEL_PRO_APP_NAME="Sequel Pro.app"
export SEQUEL_PRO_APP_URL="https://sequel-pro.googlecode.com/files/sequel-pro-1.0.2.dmg"

# vlc
export VLC_APP_NAME=VLC.app
export VLC_APP_URL="http://get.videolan.org/vlc/2.2.1/macosx/vlc-2.2.1.dmg"


