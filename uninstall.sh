#!/bin/bash
#
# noo development environment cleanup
#
# Usage:
#   curl -fsSL https://codeberg.org/noo/dotfiles/raw/branch/main/uninstall.sh | bash


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

uninstall_zerobrew() {
	log_info "Uninstalling Zerobrew..."

	if command -v zb >/dev/null 2>&1; then
		if zb self uninstall >/dev/null 2>&1; then
			log_info "Removed Zerobrew via zb self uninstall"
		else
			log_warn "zb self uninstall failed, removing common Zerobrew paths"
		fi
	else
		log_warn "zb command not found, removing common Zerobrew paths"
	fi

	rm -f "${HOME}/.local/bin/zb" || log_warn "Failed to remove ${HOME}/.local/bin/zb"
	rm -rf "${HOME}/.zerobrew" || log_warn "Failed to remove ${HOME}/.zerobrew"
	rm -rf "${HOME}/.cache/zerobrew" || log_warn "Failed to remove ${HOME}/.cache/zerobrew"
	rm -rf "${HOME}/.local/share/zerobrew" || log_warn "Failed to remove ${HOME}/.local/share/zerobrew"
}

uninstall_tmux_plugin_manager() {
	log_info "Uninstalling tmux plugin manager..."

	if [ -d "${HOME}/.tmux/plugins/tpm" ]; then
		rm -rf "${HOME}/.tmux/plugins/tpm" || log_warn "Failed to remove ${HOME}/.tmux/plugins/tpm"
	else
		log_info "tmux tpm is not installed"
	fi

	rmdir "${HOME}/.tmux/plugins" >/dev/null 2>&1 || true
}

uninstall_zsh_plugins() {
	log_info "Uninstalling zsh plugins..."

	rm -rf "${HOME}/.zsh/zsh-autosuggestions" || log_warn "Failed to remove zsh-autosuggestions"
	rm -rf "${HOME}/.zsh/zsh-syntax-highlighting" || log_warn "Failed to remove zsh-syntax-highlighting"
	rm -rf "${HOME}/.zsh/zsh-history-substring-search" || log_warn "Failed to remove zsh-history-substring-search"
}

uninstall_brew_packages() {
	log_info "Uninstalling Brewfile packages..."

	if ! command -v zb >/dev/null 2>&1; then
		log_warn "zb not found; skipping Brewfile package uninstall"
		return 0
	fi

	zb reset --yes
}

reset_macos_defaults() {
	log_info "Resetting macOS defaults changed by setup_macos_defaults..."

	reset_default() {
		defaults delete "$1" "$2" >/dev/null 2>&1 || true
	}

	reset_current_host_default() {
		defaults -currentHost delete "$1" "$2" >/dev/null 2>&1 || true
	}

	# Ask for the administrator password upfront for privileged reset operations.
	sudo -v || {
		log_warn "Could not acquire sudo credentials; only user-level defaults were reset"
	}

	# User-level and current host defaults.
	reset_default NSGlobalDomain AppleLanguages
	reset_default NSGlobalDomain AppleLocale
	reset_default NSGlobalDomain AppleMeasurementUnits
	reset_default NSGlobalDomain AppleMetricUnits
	reset_default com.apple.sound.beep.feedback
	reset_default com.apple.menuextra.battery ShowPercent
	reset_default NSGlobalDomain NSAutomaticWindowAnimationsEnabled
	reset_default NSGlobalDomain NSWindowResizeTime
	reset_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode
	reset_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2
	reset_default NSGlobalDomain PMPrintingExpandedStateForPrint
	reset_default NSGlobalDomain PMPrintingExpandedStateForPrint2
	reset_default NSGlobalDomain NSDocumentSaveNewDocumentsToCloud
	reset_default com.apple.print.PrintingPrefs "Quit When Finished"
	reset_default com.apple.LaunchServices LSQuarantine
	reset_default com.apple.systempreferences NSQuitAlwaysKeepsWindows
	reset_default com.apple.CrashReporter DialogType
	reset_default NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled
	reset_default NSGlobalDomain NSAutomaticDashSubstitutionEnabled
	reset_default NSGlobalDomain AppleKeyboardUIMode
	reset_default NSGlobalDomain ApplePressAndHoldEnabled
	reset_default NSGlobalDomain KeyRepeat
	reset_default NSGlobalDomain InitialKeyRepeat
	reset_default com.apple.BezelServices kDim
	reset_default com.apple.BezelServices kDimTime
	reset_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
	reset_default com.apple.AppleMultitouchTrackpad Clicking
	reset_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking
	reset_current_host_default NSGlobalDomain com.apple.mouse.tapBehavior
	reset_default NSGlobalDomain com.apple.mouse.tapBehavior
	reset_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick
	reset_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick
	reset_current_host_default NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior
	reset_current_host_default NSGlobalDomain com.apple.trackpad.enableSecondaryClick
	reset_default NSGlobalDomain AppleEnableSwipeNavigateWithScrolls
	reset_current_host_default NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture
	reset_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture
	reset_default com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)"
	reset_default com.apple.screensaver askForPassword
	reset_default com.apple.screensaver askForPasswordDelay
	reset_default com.apple.screencapture location
	reset_default com.apple.screencapture type
	reset_default com.apple.screencapture disable-shadow
	reset_default NSGlobalDomain AppleFontSmoothing
	reset_default com.apple.finder QuitMenuItem
	reset_default com.apple.finder DisableAllAnimations
	reset_default com.apple.finder AppleShowAllFiles
	reset_default NSGlobalDomain AppleShowAllExtensions
	reset_default com.apple.finder ShowStatusBar
	reset_default com.apple.finder ShowPathbar
	reset_default com.apple.finder QLEnableTextSelection
	reset_default com.apple.finder _FXShowPosixPathInTitle
	reset_default com.apple.finder _FXSortFoldersFirst
	reset_default com.apple.finder FXDefaultSearchScope
	reset_default com.apple.finder FXEnableExtensionChangeWarning
	reset_default com.apple.desktopservices DSDontWriteNetworkStores
	reset_default com.apple.desktopservices DSDontWriteUSBStores
	reset_default com.apple.frameworks.diskimages skip-verify
	reset_default com.apple.frameworks.diskimages skip-verify-locked
	reset_default com.apple.frameworks.diskimages skip-verify-remote
	reset_default com.apple.NetworkBrowser BrowseAllInterfaces
	reset_default com.apple.finder FXPreferredViewStyle
	reset_default com.apple.finder WarnOnEmptyTrash
	reset_default com.apple.finder FXInfoPanesExpanded
	reset_default com.apple.dock show-process-indicators
	reset_default com.apple.dock launchanim
	reset_default com.apple.dock autohide
	reset_default com.apple.dock autohide-delay
	reset_default com.apple.dock showhidden
	reset_default com.apple.dock no-bouncing
	reset_default com.apple.dock wvous-tl-corner
	reset_default com.apple.dock wvous-tr-corner
	reset_default com.apple.dock wvous-bl-corner
	reset_default com.apple.dock wvous-br-corner
	reset_default com.apple.dock show-recents
	reset_default com.apple.dock static-only
	reset_default com.apple.mail DraftsViewerAttributes
	reset_default com.apple.mail DisableReplyAnimations
	reset_default com.apple.mail DisableSendAnimations
	reset_default com.apple.mail AddressesIncludeNameOnPasteboard
	reset_default com.apple.mail DisableInlineAttachmentViewing
	reset_default com.apple.mail SpellCheckingBehavior
	reset_default com.apple.mail MailSound
	reset_default com.apple.mail PlayMailSounds
	reset_default com.apple.mail ConversationViewMarkAllAsRead
	reset_default com.apple.mail IndexTrash
	reset_default com.apple.mail AutoFetch
	reset_default com.apple.mail PollTime
	reset_default com.apple.mail ConversationViewSortDescending
	reset_default com.apple.iCal "Show Week Numbers"
	reset_default com.apple.iCal "first day of week"
	reset_default com.apple.terminal StringEncodings
	reset_default com.apple.terminal "Default Window Settings"
	reset_default com.apple.terminal "Startup Window Settings"
	reset_default com.apple.Terminal ShowLineMarks
	reset_default com.apple.ActivityMonitor OpenMainWindow
	reset_default com.apple.ActivityMonitor IconType
	reset_default com.apple.ActivityMonitor ShowCategory
	reset_default com.apple.ActivityMonitor SortColumn
	reset_default com.apple.ActivityMonitor SortDirection
	reset_default com.apple.SoftwareUpdate AutomaticCheckEnabled
	reset_default com.apple.SoftwareUpdate ScheduleFrequency
	reset_default com.apple.SoftwareUpdate AutomaticDownload
	reset_default com.apple.SoftwareUpdate CriticalUpdateInstall
	reset_default com.apple.commerce AutoUpdate
	reset_default com.apple.commerce AutoUpdateRestartRequired

	# Privileged preferences and system values changed by setup.
	sudo defaults delete /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName >/dev/null 2>&1 || true
	sudo defaults delete /Library/Preferences/com.apple.timezone.auto Active >/dev/null 2>&1 || true
	sudo nvram -d SystemAudioVolume >/dev/null 2>&1 || true
	sudo nvram -d StartupMute >/dev/null 2>&1 || true
	launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist >/dev/null 2>&1 || true

	for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
		killall "${app}" >/dev/null 2>&1 || true
	done
}


reset_symlinks() {
	log_info "Resetting symlinks created by setup_symlinks..."

	remove_symlink_if_matches() {
		link_path="$1"
		expected_target="$2"

		if [ -L "${link_path}" ] && [ "$(readlink "${link_path}")" = "${expected_target}" ]; then
			rm -f "${link_path}" || log_warn "Failed to remove symlink ${link_path}"
		fi
	}

	# .config symlinks
	(
		local src_config_dir="${DOTFILES_DIR}/.config"
		local dest_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

		if [ -d "${src_config_dir}" ]; then
			for cfg in "${src_config_dir}"/*; do
				name=$(basename "$cfg")
				remove_symlink_if_matches "${dest_config_dir}/${name}" "${cfg}"
			done
		fi
	)

	# .local symlinks
	(
		local src_local_dir="${DOTFILES_DIR}/.local"
		local dest_local_dir="${HOME}/.local"

		if [ -d "${src_local_dir}" ]; then
			for item in "${src_local_dir}"/*; do
				name=$(basename "$item")
				remove_symlink_if_matches "${dest_local_dir}/${name}" "${item}"
			done
		fi
	)

	remove_symlink_if_matches "${HOME}/.ripgreprc" "${DOTFILES_DIR}/.ripgreprc"
	remove_symlink_if_matches "${HOME}/.zshrc" "${DOTFILES_DIR}/.zshrc"
}

uninstall() {
	log_info "Cleaning up installed files and settings..."

	# Reset macOS defaults and remove symlinks
	reset_macos_defaults || log_warn "Failed to reset macOS defaults"
	reset_symlinks || log_warn "Failed to reset symlinks"

	# Remove installed tools
	uninstall_zsh_plugins || log_warn "Failed to uninstall zsh plugins"
	uninstall_tmux_plugin_manager || log_warn "Failed to uninstall tmux plugin manager"
	uninstall_brew_packages || log_warn "Failed to uninstall brew packages"
	uninstall_zerobrew || log_warn "Failed to uninstall zerobrew"
	
	# Remove dotfiles repo if requested
	if [ -d "${DOTFILES_DIR}" ]; then
		rm -rf "${DOTFILES_DIR}" || log_warn "Failed to remove ${DOTFILES_DIR}"
	fi

	log_info "Cleanup complete"
}

