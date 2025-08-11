#!/bin/bash
#
## command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/pluginsort.sh -O - | /bin/sh
#####################

echo "Updating package list..."
apt-get update || echo "⚠ Failed to update package list, continuing..."

echo "Installing required packages (optional)..."
apt-get install -y wget curl tar \
    enigma2-plugin-systemplugins-mphelp \
    python-shell python-codecs python-xml python-lang enigma2 || \
    echo "⚠ Some packages failed to install, continuing..."

mkdir -p /tmp
cd /tmp || exit 1

echo "Downloading plugin package..."
if command -v curl >/dev/null 2>&1; then
    curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/pluginsort.tar.gz" -o pluginsort.tar.gz || {
        echo "✖ Download failed with curl!"
        exit 1
    }
elif command -v wget >/dev/null 2>&1; then
    wget "https://github.com/emilnabil/dreambox/raw/refs/heads/main/pluginsort.tar.gz" -O pluginsort.tar.gz || {
        echo "✖ Download failed with wget!"
        exit 1
    }
else
    echo "✖ Neither curl nor wget found!"
    exit 1
fi

echo "Installing package..."
tar -xzf pluginsort.tar.gz -C / || {
    echo "✖ Extraction failed!"
    exit 1
}

echo "Cleaning up..."
rm -f pluginsort.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0


