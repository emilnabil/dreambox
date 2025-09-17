#!/bin/bash
#
## command=curl -kL https://github.com/emilnabil/dreambox/raw/refs/heads/main/bootlogoswaper-ts.sh | bash
######################
set -e 
TMPFILE="/tmp/BootlogoSwap-Ts.tar.gz"
URL="https://github.com/emilnabil/dreambox/raw/refs/heads/main/BootlogoSwap-Ts.tar.gz"

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






