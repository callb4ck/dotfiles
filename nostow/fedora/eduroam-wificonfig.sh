#!/bin/sh

# You need this configuration to be able to connect
# to legacy networks configs such as eduroam or other
# enterprise/institutional networks on Fedora

[ "$(whoami)" != "root" ] && exec echo "Run this script as root (pkexec, doas or sudo)"

#update-crypto-policies --set LEGACY
#
#OPENSSL_CONFIG='/etc/crypto-policies/back-ends/openssl.config'
#
#sed -i.OLDCOPY 's/SECLEVEL=./SECLEVEL=0/' "$OPENSSL_CONFIG" \
#    && echo -e "\nUpdated SECLEVEL in $OPENSSL_CONFIG, config file is\n$OPENSSL_CONFIG.OLDCOPY\n\nPlease reboot the system"

nmcli connection modify eduroam 802-1x.phase1-auth-flags 32 || exec echo "You need to try and connect at least once first, even if the connection fails"

echo "Changed eduroam phase1-auth settings"

printf "NetworkManager.service should be restarted now, is that ok? [Y/n]: "

read dorestart

dorestart=`printf "$dorestart" | tr '[:upper:]' '[:lower:]'`

[ "$dorestart" != n ] && systemctl restart NetworkManager.service && exec echo "Restarting NetworkManager.service"

echo "Didn't restart NetworkManager.service"
