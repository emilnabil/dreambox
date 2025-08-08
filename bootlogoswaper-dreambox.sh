#!/bin/bash
#
## command=curl -kL https://github.com/emilnabil/dreambox/raw/refs/heads/main/bootlogoswaper-dreambox.sh | bash
######################

set -e 

echo "Updating package list..."
apt-get update -y

echo "Installing required packages..."
apt-get install -y \
    enigma2-plugin-skincomponents-runningtext \
    enigma2-plugin-skincomponents-cover \
    enigma2-plugin-skincomponents-eventlist \
    enigma2-plugin-skincomponents-serviceinfofhd \
    enigma2-plugin-skincomponents-weathercomponent \
    enigma2-plugin-systemplugins-weathercomponenthandler \
    enigma2-plugin-skincomponents-eventposition \
    enigma2-plugin-skincomponents-reftomoviename \
    enigma2-plugin-skincomponents-boxinfo \
    enigma2-plugin-skincomponents-reftopiconname \
    enigma2-plugin-skincomponents-volumetext

TMPFILE="/tmp/bootlogoswaper-dreambox.tar.gz"
URL="https://github.com/emilnabil/download-plugins/raw/refs/heads/main/skins-for-dreambox/bootlogoswaper-dreambox.tar.gz"

cd /tmp

echo "Downloading plugin package..."
curl -kL "$URL" -o "$TMPFILE"

echo "Installing package..."
tar -xzf "$TMPFILE" -C /

echo "Cleaning up..."
rm -f "$TMPFILE"

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0



