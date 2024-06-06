#!/bin/sh

checks() {
	command -v stow > /dev/null || exec echo 'Please install GNU Stow' # At this point the script has become so big that I'm wondering if I should just drop stow

	[ `whoami` = 'root' ] && \
		printf "You should avoid running this script as root\nQuit? [Y/n]: " && \
		read doquit && \
		doquit=`printf "$doquit" | tr '[:upper:]' '[:lower:]'` && \
		[ "$doquit" != 'n' ] && \
		exec echo "Quitting"
}

detect() {
	"detect_$1"
}

detect_su() {
	[ `whoami` = 'root' ] && auth=':' && return 1

	test -n "$CUSTOM_AUTH" && auth=$CUSTOM_AUTH && return 0

	command -v sudo &> /dev/null && auth=sudo
	command -v doas &> /dev/null && auth=doas     # Safer
	command -v pkexec &> /dev/null && auth=pkexec # Safest

	test -z "$auth" && exec printf "Couldn't find a superuser authentication method.\nPlease provide at least one of the following commands: [ pkexec | doas | sudo ] \nor execute this script as root (not recommended).\nYou can also provide your own authentication by setting the CUSTOM_AUTH env var.\n(eg. CUSTOM_AUTH=doas apply.sh )\n"

	return 0
}

rootdo() {
	detect su || ("$@" && return)
	
	"$auth" "$@"
}

fedora_eduroam() {

	[ `whoami` != 'root' ] && authmsg=" (will require superuser authentication)"

	printf "Fedora detected!\nEduroam fix script available\nThe script enables potentially unsafe wireless connections.\nApply the script?$authmsg [y/N]: " && \
		read doapplyeduroam && \
		doapplyeduroam=`printf "$doapplyeduroam" | tr '[:upper:]' '[:lower:]'` && \
		[ "$doapplyeduroam" = 'y' ] && \
		echo && \
		rootdo ./nostow/fedora/eduroam-wificonfig.sh && \
		return
	echo "Didn't apply eduroam fix script."
}

default_flathub() {
	printf "Set flathub as default source in gnome-software? [Y/n]: " && \
		read setflathub && \
		setflathub=`printf "$setflathub" | tr '[:upper:]' '[:lower:]'` && \
		[ "$setflathub" != n ] && \
		dconf write /org/gnome/software/packaging-format-preference "['flatpak:flathub']" && \
		echo "Flathub is now default source in gnome-software." && \
		return

	echo "Didn't set Flathub as default source in gnome-software."
}

detect_fedora() {

	. /etc/os-release
	[ "$ID" != "fedora" ] && return

	fedora_eduroam

	echo

	default_flathub

	echo
}

detect_gnome() {
	[ "$DESKTOP_SESSION" != 'gnome' ] && return

	printf "GNOME detected, do you want to enable the touchpad while typing? [Y/n]: " && \
		read enabletouchpad && \
		setflathub=`printf "$enabletouchpad" | tr '[:upper:]' '[:lower:]'` && \
		[ "$enabletouchpad" != n ] && \
		dconf write /org/gnome/desktop/peripherals/touchpad/disable-while-typing false && \
		echo "Touchpad is now enabled while typing." && \
		return

	echo "Did not change disable-while-typing dconf setting."
}

apply() {
	stow --target=$HOME $1
}

ask() {
	printf "Apply $2? [y/N]: "
	read doapply

	doapply=`printf "$doapply" | tr '[:upper:]' '[:lower:]'`

	[ "$doapply" = "y" ] && apply $1 && echo "Applied $2." && return

	printf "Didn't apply $2.\n\n"
}




checks

ask fish "fish shell config"

ask scripts "user scripts"

ask systemd-services "user systemd services"

detect fedora

detect gnome

printf '\nAll done!\n'
