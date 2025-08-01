#!/bin/bash
#
##comand=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/CrashlogAutoSubmit.sh -O - | /bin/sh
#####################
cd /tmp || exit 1

echo "Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/CrashlogAutoSubmit.tar.gz" -o /tmp/CrashlogAutoSubmit.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "Installing package..."
tar -xzf /tmp/CrashlogAutoSubmit.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "Cleaning up..."
rm -f /tmp/CrashlogAutoSubmit.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0









