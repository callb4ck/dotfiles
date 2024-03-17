#!/bin/sh

conf() {
    stow --target=$HOME $1
}

command -v stow > /dev/null || echo "Please install GNU Stow" && exit 1

conf fish
conf scripts
conf systemd-services

