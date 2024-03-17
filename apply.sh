#!/bin/sh

conf() {
    stow --target=$HOME $1
}

command -v stow > /dev/null || echo 'Please install GNU Stow'

conf fish
conf scripts
conf systemd-services

echo 'Done!'
