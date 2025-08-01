#!/bin/bash
#
##comand=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/SoftwareManager.sh -O - | /bin/sh
#####################
cd /tmp || exit 1

echo "Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/SoftwareManager.tar.gz" -o /tmp/SoftwareManager.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "Installing package..."
tar -xzf /tmp/SoftwareManager.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "Cleaning up..."
rm -f /tmp/SoftwareManager.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0





