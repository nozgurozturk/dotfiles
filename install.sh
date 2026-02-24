#!/bin/bash
#
# noo development environment setup
#
# Usage:
#   curl -fsSL https://codeberg.org/noo/dotfiles/raw/branch/main/install.sh | bash

set -e

# Configuration
REPO="noo/dotfiles"
RELEASE_URL_BASE="https://codeberg.org/api/v1/repos/${REPO}/releases"
DEV_DIR="${HOME}/Development"
CODERBERG_DIR="${DEV_DIR}/codeberg.org"
DOTFILES_DIR="${CODERBERG_DIR}/${REPO}"

COMPUTER_NAME="Ozgur’s MacBook Pro M2"
LANGUAGES=(en nl)
LOCALE="en_US@currency=EUR"
MEASUREMENT_UNITS="Centimeters"
SCREENSHOTS_FOLDER="${HOME}/Screenshots"

# Color and formatting
# Check if tput is available, stdout is a terminal, and tput can actually work with the current TERM
if command -v tput >/dev/null 2>&1 && [ -t 1 ] && tput setaf 1 >/dev/null 2>&1; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    RESET=$(tput sgr0)
else
    RED=""
    GREEN=""
    YELLOW=""
    RESET=""
fi

# Logging functions
log_info() {
    printf "%s[INFO]%s %s\n" "${GREEN}" "${RESET}" "$1" >&2
}

log_warn() {
    printf "%s[WARN]%s %s\n" "${YELLOW}" "${RESET}" "$1" >&2
}

log_error() {
    printf "%s[ERROR]%s %s\n" "${RED}" "${RESET}" "$1" >&2
}

# Detect OS
uname_os() {
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$os" in
        msys_nt*) os="windows" ;;
        mingw*) os="windows" ;;
        cygwin*) os="windows" ;;
        win*) os="windows" ;;
    esac
    echo "$os"
}

# Detect architecture
uname_arch() {
    arch=$(uname -m)
    case $arch in
        x86_64) arch="x86_64" ;;
        x64) arch="x86_64" ;;
        i686) arch="386" ;;
        i386) arch="386" ;;
        aarch64) arch="arm64" ;;
        armv5*) arch="armv5" ;;
        armv6*) arch="armv6" ;;
        armv7*) arch="armv7" ;;
    esac
    echo "${arch}"
}

# Check if OS is supported
uname_os_check() {
    os=$(uname_os)
    case "$os" in
        darwin) return 0 ;;
    esac
    log_error "OS $os is not supported"
    return 1
}

# Check if architecture is supported
uname_arch_check() {
    arch=$(uname_arch)
    case "$arch" in
        x86_64) return 0 ;;
        arm64) return 0 ;;
    esac
    log_error "Architecture $arch is not supported"
    return 1
}

# Ensure required tools are installed
uname_tools_check() {
	if ! command -v curl >/dev/null 2>&1; then
		log_error "curl is required but not installed"
		return 1
	fi

	if ! command -v git >/dev/null 2>&1; then
		log_error "git is required but not installed"
		return 1
	fi

	return 0
}


# Get latest version from Codeberg
get_latest_version() {
    log_info "Fetching latest release information..."

    # Use /releases/latest endpoint to get latest version
    url="${RELEASE_URL_BASE}/latest"

	# Get version from latest release's response body { tag_name: <version> }
	version=$(curl -s -H 'accept: application/json' "$url" | awk -F '"' '/tag_name/ { print $6; exit }')

    # Validate that we found a version
    if [ -z "$version" ]; then
        log_error "No stable vx.x.x releases found"
        return 1
    fi

    log_info "Found latest version: $version"
    echo "$version"
    return 0
}

# Normalize version (ensure it starts with v)
normalize_version() {
    version="$1"
    case "$version" in
        v*) echo "$version" ;;
        *) echo "v$version" ;;
    esac
}

# Get version to install
get_version() {
    version=""

    # Priority order: 1. Environment variable, 2. Command line argument, 3. Latest
    if [ -n "$DOTFILES_VERSION" ]; then
        version="$DOTFILES_VERSION"
        log_info "Using version from environment: $version"
    elif [ -n "$1" ]; then
        version="$1"
        log_info "Using version from argument: $version"
    else
        version=$(get_latest_version) || return 1
    fi

    version=$(normalize_version "$version")

    echo "$version"
}

install_zerobrew() {
	if command -v zb >/dev/null 2>&1; then
		log_info "Zerobrew already installed"
		return 0
	fi

	log_info "Installing Zerobrew..."
	# Use non-interactive install script for macOS
	/bin/bash -c "$(curl -fsSL https://zerobrew.rs/install)" </dev/null

	log_info "Verifying Zerobrew installation..."
	if ! command -v zb >/dev/null 2>&1; then
		log_error "Zerobrew installation failed"
		return 1
	fi

	return 0
}

setup_macos_defaults() { 

	osascript -e 'tell application "System Preferences" to quit'

	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until this script has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	###############################################################################
	# Computer & Host name                                                        #
	###############################################################################

	# Set computer name (as done via System Preferences → Sharing)
	sudo scutil --set ComputerName "$COMPUTER_NAME"
	sudo scutil --set HostName "$COMPUTER_NAME"
	sudo scutil --set LocalHostName "$COMPUTER_NAME"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

	###############################################################################
	# Localization                                                                #
	###############################################################################

	# Set language and text formats
	defaults write NSGlobalDomain AppleLanguages -array ${LANGUAGES[@]}
	defaults write NSGlobalDomain AppleLocale -string "$LOCALE"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "$MEASUREMENT_UNITS"
	defaults write NSGlobalDomain AppleMetricUnits -bool true

	# Using systemsetup might give Error:-99, can be ignored (commands still work)
	# systemsetup manpage: https://ss64.com/osx/systemsetup.html

	# Set the time zone
	sudo defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
	sudo systemsetup -setusingnetworktime on

	###############################################################################
	# System                                                                      #
	###############################################################################

	# Restart automatically if the computer freezes (Error:-99 can be ignored)
	sudo systemsetup -setrestartfreeze on 2> /dev/null

	# Set standby delay to 24 hours (default is 1 hour)
	sudo pmset -a standbydelay 86400

	# Disable Sudden Motion Sensor
	sudo pmset -a sms 0

	# Disable audio feedback when volume is changed
	defaults write com.apple.sound.beep.feedback -bool false

	# Disable the sound effects on boot
	sudo nvram SystemAudioVolume=" "
	sudo nvram StartupMute=%01

	# Menu bar: show battery percentage
	defaults write com.apple.menuextra.battery ShowPercent YES

	# Disable opening and closing window animations
	defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

	# Increase window resize speed for Cocoa applications
	defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

	# Expand save panel by default
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

	# Expand print panel by default
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

	# Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Disable Resume system-wide
	defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

	# Disable the crash reporter
	defaults write com.apple.CrashReporter DialogType -string "none"

	# Disable Notification Center and remove the menu bar icon
	launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

	###############################################################################
	# Keyboard & Input                                                            #
	###############################################################################

	# Disable smart quotes and dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# Set a blazingly fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Automatically illuminate built-in MacBook keyboard in low light
	defaults write com.apple.BezelServices kDim -bool true

	# Turn off keyboard illumination when computer is not used for 5 minutes
	defaults write com.apple.BezelServices kDimTime -int 300

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	###############################################################################
	# Trackpad, mouse, Bluetooth accessories                                      #
	###############################################################################

	# Trackpad: enable tap to click for this user and for the login screen
	defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	# Trackpad: map bottom right corner to right-click
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
	defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

	# Trackpad: swipe between pages with three fingers
	defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
	defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

	# Increase sound quality for Bluetooth headphones/headsets
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	###############################################################################
	# Screen                                                                      #
	###############################################################################

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	# Save screenshots to the ~/Screenshots folder
	mkdir -p "${SCREENSHOTS_FOLDER}"
	defaults write com.apple.screencapture location -string "${SCREENSHOTS_FOLDER}"

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	# Enable subpixel font rendering on non-Apple LCDs
	defaults write NSGlobalDomain AppleFontSmoothing -int 2

	###############################################################################
	# Finder                                                                      #
	###############################################################################

	# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
	defaults write com.apple.finder QuitMenuItem -bool true

	# Finder: disable window animations and Get Info animations
	defaults write com.apple.finder DisableAllAnimations -bool true

	# Finder: show hidden files by default
	defaults write com.apple.finder AppleShowAllFiles -bool true

	# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	# Finder: show status bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Finder: allow text selection in Quick Look
	defaults write com.apple.finder QLEnableTextSelection -bool true

	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# When performing a search, search the current folder by default
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Disable disk image verification
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

	# Use AirDrop over every interface.
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	# Always open everything in Finder's list view.
	# Use list view in all Finder windows by default
	# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

	# Disable the warning before emptying the Trash
	defaults write com.apple.finder WarnOnEmptyTrash -bool false

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true

	###############################################################################
	# Dock                                                                        #
	###############################################################################

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Don’t animate opening applications from the Dock
	defaults write com.apple.dock launchanim -bool false

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Disable delay on mouse over
	defaults write com.apple.dock autohide-delay -float 0

	# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

	# No bouncing icons
	defaults write com.apple.dock no-bouncing -bool true

	# Disable hot corners
	defaults write com.apple.dock wvous-tl-corner -int 0
	defaults write com.apple.dock wvous-tr-corner -int 0
	defaults write com.apple.dock wvous-bl-corner -int 0
	defaults write com.apple.dock wvous-br-corner -int 0

	# Don't show recently used applications in the Dock
	defaults write com.apple.dock show-recents -bool false

	# Only show open apps on dock
	defaults write com.apple.dock static-only -bool true

	###############################################################################
	# Mail                                                                        #
	###############################################################################

	# Display emails in threaded mode
	defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"

	# Disable send and reply animations in Mail.app
	defaults write com.apple.mail DisableReplyAnimations -bool true
	defaults write com.apple.mail DisableSendAnimations -bool true

	# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
	defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

	# Disable inline attachments (just show the icons)
	defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

	# Disable automatic spell checking
	defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

	# Disable sound for incoming mail
	defaults write com.apple.mail MailSound -string ""

	# Disable sound for other mail actions
	defaults write com.apple.mail PlayMailSounds -bool false

	# Mark all messages as read when opening a conversation
	defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true

	# Disable includings results from trash in search
	defaults write com.apple.mail IndexTrash -bool false

	# Automatically check for new message (not every 5 minutes)
	defaults write com.apple.mail AutoFetch -bool true
	defaults write com.apple.mail PollTime -string "-1"

	# Show most recent message at the top in conversations
	defaults write com.apple.mail ConversationViewSortDescending -bool true

	###############################################################################
	# Calendar                                                                    #
	###############################################################################

	# Show week numbers (10.8 only)
	defaults write com.apple.iCal "Show Week Numbers" -bool true

	# Week starts on monday
	defaults write com.apple.iCal "first day of week" -int 1

	###############################################################################
	# Terminal                                                                    #
	###############################################################################

	# Only use UTF-8 in Terminal.app
	defaults write com.apple.terminal StringEncodings -array 4

	# Appearance
	defaults write com.apple.terminal "Default Window Settings" -string "Pro"
	defaults write com.apple.terminal "Startup Window Settings" -string "Pro"
	defaults write com.apple.Terminal ShowLineMarks -int 0

	###############################################################################
	# Activity Monitor                                                            #
	###############################################################################

	# Show the main window when launching Activity Monitor
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

	# Visualize CPU usage in the Activity Monitor Dock icon
	defaults write com.apple.ActivityMonitor IconType -int 5

	# Show all processes in Activity Monitor
	defaults write com.apple.ActivityMonitor ShowCategory -int 0

	# Sort Activity Monitor results by CPU usage
	defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	defaults write com.apple.ActivityMonitor SortDirection -int 0

	###############################################################################
	# Software Updates                                                            #
	###############################################################################

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Check for software updates weekly (`dot update` includes software updates)
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -string 7

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

	# Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	# Allow the App Store to reboot machine on macOS updates
	defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

	###############################################################################
	# Kill affected applications                                                  #
	###############################################################################

	for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
	  killall "${app}" &> /dev/null
	done
}

install_tmux_plugin_manager() {
	mkdir -p "${HOME}/.tmux/plugins"
	if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
		git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm" || log_warn "Failed to clone tmux tpm"
	else
		log_info "tmux tpm already installed"
	fi
}

install_zsh_plugins() {
	log_info "Installing zsh plugins..."

	#Autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions || log_warn "Failed to clone zsh-autosuggestions"

	# Syntax Highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting ||  log_warn "Failed to clone zsh-syntax-highlighting"

	# Better history search
	git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search || log_warn "Failed to clone zsh-history-substring-search"
}

install_brew_packages() {

	# Install Homebrew packages from Brewfile if available
	if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
		zb bundle --file="${DOTFILES_DIR}/Brewfile" || log_warn "Failed to install Brewfile packages"
	else
		log_warn "No Brewfile found in dotfiles"
	fi
}

clone_git_repository() {
	log_info "Cloning dotfiles repository..."

	mkdir -p "${CODERBERG_DIR}"

	if [ -d "${DOTFILES_DIR}/.git" ]; then
		log_info "Dotfiles repo already exists, pulling latest changes"
		( cd "${DOTFILES_DIR}" && git pull --rebase ) || log_warn "Failed to update dotfiles repo"
		return 0
	fi

	git clone "https://codeberg.org/${REPO}.git" "${DOTFILES_DIR}" || {
		log_error "Failed to clone dotfiles repo"
		return 1
	}
}

setup_symlinks() {
	# Symlink config
	(
		local src_config_dir="${DOTFILES_DIR}/.config"
		local dest_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

		if [ ! -d "${src_config_dir}" ]; then
			log_warn "No .config directory in dotfiles"
			return 0
		fi

		mkdir -p "${dest_config_dir}"
		for cfg in "${src_config_dir}"/*; do
			name=$(basename "$cfg")
			target="${dest_config_dir}/$name"
			ln -sf "$cfg" "$target" || log_warn "Failed to link $name"
		done
	)
	
	# Symlink .local
	(
		local src_local_dir="${DOTFILES_DIR}/.local"
		local dest_local_dir="${HOME}/.local"

		if [ ! -d "${src_local_dir}" ]; then
			log_warn "No local directory in dotfiles"
			return 0
		fi

		mkdir -p "${dest_local_dir}"
		for item in "${src_local_dir}"/*; do
			name=$(basename "$item")
			target="${dest_local_dir}/$name"
			ln -sf "$item" "$target" || log_warn "Failed to link local/$name"
		done
	)
	# Symlink .gitconfig
	(
		local src_gitconfig="${DOTFILES_DIR}/.gitconfig"
		local dest_gitconfig="${HOME}/.gitconfig"

		if [ -f "${src_gitconfig}" ]; then
			ln -sf "${src_gitconfig}" "${dest_gitconfig}" || log_warn "Failed to link .gitconfig"
		else
			log_warn "No .gitconfig in dotfiles"
		fi
	)

	# Symlink .gitignore
	(
		local src_gitignore="${DOTFILES_DIR}/.gitignore"
		local dest_gitignore="${HOME}/.gitignore"

		if [ -f "${src_gitignore}" ]; then
			ln -sf "${src_gitignore}" "${dest_gitignore}" || log_warn "Failed to link .gitignore"
		else
			log_warn "No .gitignore in dotfiles"
		fi
	)


	# Symlink .ripgreprc
	(
		local src_ripgrep="${DOTFILES_DIR}/.ripgreprc"
		local dest_ripgrep="${HOME}/.ripgreprc"

		if [ -f "${src_ripgrep}" ]; then
			ln -sf "${src_ripgrep}" "${dest_ripgrep}" || log_warn "Failed to link .ripgreprc"
		else
			log_warn "No .ripgreprc in dotfiles"
		fi
	)

	# Symlink .zshrc
	(
		local src_zshrc="${DOTFILES_DIR}/.zshrc"
		local dest_zshrc="${HOME}/.zshrc"

		if [ -f "${src_zshrc}" ]; then
			ln -sf "${src_zshrc}" "${dest_zshrc}" || log_warn "Failed to link .zshrc"
		else
			log_warn "No .zshrc in dotfiles"
		fi
	)
}

# Download and setup
setup() {
    version=""
    os=""
    arch=""
    archive_url=""
    archive_name=""

    # Get version
    version=$(get_version "$1") || return 1

    # Check platform support
    uname_os_check || return 1
    uname_arch_check || return 1

    # Get platform details
    os=$(uname_os)
    arch=$(uname_arch)

    log_info "Setup dotfiles $version for $os/$arch"

	clone_git_repository

	install_zerobrew
	install_brew_packages
	install_tmux_plugin_manager
	install_zsh_plugins

	setup_symlinks
	setup_macos_defaults
}

# Main execution
setup "$1"
