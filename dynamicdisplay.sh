#!/bin/bash
#
## command: wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/dynamicdisplay.sh -O - | /bin/sh
#####################

echo "🔄 Removing old version..."
rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/DynamicDisplay
rm -f /usr/share/enigma2/menu/DynamicDisplay.svg

cd /tmp || {
    echo "✖ Failed to access /tmp"
    exit 1
}

echo "⬇ Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/dynamicdisplay.tar.gz" -o dynamicdisplay.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "📦 Installing plugin..."
tar -xzf dynamicdisplay.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "🧹 Cleaning up..."
rm -f dynamicdisplay.tar.gz

echo ""
echo "✅ DynamicDisplay Installed Successfully!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0


