#!/bin/sh

conf() {
    stow --target=$HOME $1
}

conf fish
conf scripts
conf systemd-services

