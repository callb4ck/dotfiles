#!/bin/sh

randr='/var/userbin/gnome-randr' # default path

command -v 'gnome-randr' &>/dev/null && \
	randr=$(command -v gnome-randr)

monitor-sensor --accel | awk ' BEGIN {print cmd} \
	/normal/ {system(cmd " normal " screen)} \
	/left-up/ {system(cmd " right " screen)} \
	/right-up/ {system(cmd " left " screen)} \
	/bottom-up/ {system(cmd " inverted " screen)}' \
	cmd="$randr modify -r" \
	screen="eDP-1"
