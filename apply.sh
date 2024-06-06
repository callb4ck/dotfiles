#!/bin/sh

checks() {
	command -v stow > /dev/null || exec echo 'Please install GNU Stow'

	[ `whoami` = 'root' ] && \
		printf "You should avoid running this script as root\nQuit? [Y/n]: " && \
		read doquit && \
		doquit=`printf "$doquit" | tr '[:upper:]' '[:lower:]'` && \
		[ "$doquit" != 'n' ] && \
		exec echo "Quitting"
}

apply() {
	stow --target=$HOME $1
}

ask() {
	printf "Apply $2? [y/N]: "
	read doapply

	doapply=`printf "$doapply" | tr '[:upper:]' '[:lower:]'`

	[ "$doapply" = "y" ] && apply $1 && echo "Applied $2." && return

	echo "Didn't apply $2."
}




checks

ask fish "fish shell config"

ask scripts "user scripts"

ask systemd-services "user systemd services"

echo 'All done!'
