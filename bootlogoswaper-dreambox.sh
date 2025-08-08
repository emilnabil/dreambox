#!/bin/bash
#
## command=curl -kL https://github.com/emilnabil/dreambox/raw/refs/heads/main/bootlogoswaper-dreambox.sh | bash
######################
set -e 
TMPFILE="/tmp/bootlogoswaper-dreambox.tar.gz"
URL="https://github.com/emilnabil/dreambox/raw/refs/heads/main/bootlogoswaper-dreambox.tar.gz"

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




