#!/bin/bash
#
## command=curl -kL https://github.com/emilnabil/skins-obh/raw/refs/heads/main/Signalfinder.sh | bash
######################

TMPFILE="/tmp/Signalfinder.tar.gz"
URL="https://github.com/emilnabil/skins-obh/raw/refs/heads/main/Signalfinder.tar.gz"

cd /tmp || {
    echo "Failed to change directory to /tmp"
    exit 1
}

echo "Downloading plugin package..."
if ! curl -kL "$URL" -o "$TMPFILE"; then
    echo "Download failed!"
    exit 1
fi

echo "Installing package..."
if ! tar -xzf "$TMPFILE" -C /; then
    echo "Extraction failed!"
    rm -f "$TMPFILE"
    exit 1
fi

echo "Cleaning up..."
rm -f "$TMPFILE"

echo ""
echo "Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0


