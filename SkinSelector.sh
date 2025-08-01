#!/bin/bash
#
##comand=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/SkinSelector.sh -O - | /bin/sh
#####################
cd /tmp || exit 1

echo "Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/SkinSelector.tar.gz" -o /tmp/SkinSelector.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "Installing package..."
tar -xzf /tmp/SkinSelector.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "Cleaning up..."
rm -f /tmp/SkinSelector.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0




