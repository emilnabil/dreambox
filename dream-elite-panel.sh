#!/bin/bash
#
##command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/dream-elite-panel.sh -O - | /bin/sh
#####################

ARCH=""
HOSTNAME=$(cat /etc/hostname)

case "$HOSTNAME" in
    dm520|dm820|dm7080)
        ARCH="mipsel"
        ;;
    dm900|dm920)
        ARCH="armhf"
        ;;
    dreambox)
        ARCH="aarch64"
        ;;
esac

if [ -n "$ARCH" ]; then
    echo "Adding Dream-Elite feed for $ARCH..."
    echo "deb [trusted=yes] http://feed.dream-elite.net/ElitePanel/installer/$ARCH ./" > "/etc/apt/sources.list.d/dep-installer-${ARCH}-feed.list"
else
    echo "✖ Unsupported device hostname: $HOSTNAME"
    exit 1
fi

cd /tmp || exit 1

echo "Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/dream-elite-panel.tar.gz" -o /tmp/dream-elite-panel.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "Installing package..."
tar -xzf /tmp/dream-elite-panel.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "Cleaning up..."
rm -f /tmp/dream-elite-panel.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0


