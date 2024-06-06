#!/bin/sh

# You need this configuration to be able to connect
# to legacy networks configs such as eduroam or other
# enterprise/institutional networks on Fedora

[ "$(whoami)" != "root" ] && exec echo "Run this script as root (pkexec, doas or sudo)"

update-crypto-policies --set LEGACY

OPENSSL_CONFIG='/etc/crypto-policies/back-ends/openssl.config'

sed -i.OLDCOPY 's/SECLEVEL=./SECLEVEL=0/' "$OPENSSL_CONFIG" \
    && echo -e "\nUpdated SECLEVEL in $OPENSSL_CONFIG, config file is\n$OPENSSL_CONFIG.OLDCOPY\n\nPlease reboot the system"
