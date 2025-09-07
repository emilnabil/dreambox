#!/bin/bash
#
##comand=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/channelselectionplus.sh -O - | /bin/sh
#######################################

URL="https://github.com/emilnabil/dreambox/raw/refs/heads/main/channelselectionplus.deb"
DEB_FILE="/tmp/channelselectionplus.deb"

wget -O "$DEB_FILE" "$URL"
if [ $? -ne 0 ]; then
    echo "Download failed: $URL"
    exit 1
fi

dpkg -i "$DEB_FILE"
if [ $? -ne 0 ]; then
    echo "Errors occurred during installation, trying to fix..."
fi

apt-get -f -y install

rm -f "$DEB_FILE"
exit






