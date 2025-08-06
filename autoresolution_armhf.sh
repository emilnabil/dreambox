#!/bin/bash
#
## command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/autoresolution_armhf.sh -O - | /bin/sh
#####################

apt-get update -y

apt-get install -y wget curl hlsdl \
    python-lxml python-requests python-beautifulsoup4 python-cfscrape \
    livestreamer python-six python-sqlite3 python-pycrypto f4mdump \
    python-image python-imaging python-argparse python-multiprocessing \
    python-mmap python-ndg-httpsclient python-pydoc python-xmlrpc \
    python-certifi python-urllib3 python-chardet python-pysocks \
    enigma2-plugin-systemplugins-serviceapp ffmpeg exteplayer3 gstplayer \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-bad \
    enigma2-plugin-systemplugins-videomode enigma2

####################

cd /tmp || exit 1

echo "Downloading plugin package..."
curl -kL "https://github.com/emilnabil/dreambox/raw/refs/heads/main/autoresolution_armhf.tar.gz" -o /tmp/autoresolution_armhf.tar.gz
if [ $? -ne 0 ]; then
    echo "✖ Download failed!"
    exit 1
fi

echo "Installing package..."
tar -xzf /tmp/autoresolution_armhf.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "✖ Extraction failed!"
    exit 1
fi

echo "Cleaning up..."
rm -f /tmp/autoresolution_armhf.tar.gz

echo ""
echo "✅ Installation complete!"
echo ">>>>>>>>>>>>>>>>> DONE <<<<<<<<<<<<<<<<<"
sleep 2
exit 0



