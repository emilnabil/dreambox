#!/bin/bash
# command=wget https://github.com/emilnabil/dreambox/raw/refs/heads/main/displayskin.sh -O - | /bin/sh

apt update
wget -O /tmp/displayskin_5.0-stable.deb https://github.com/emilnabil/dreambox/raw/refs/heads/main/displayskin_5.0-stable.deb
dpkg -i /tmp/displayskin_5.0-stable.deb
apt install -f -y
sleep 2
rm -f/tmp/displayskin_5.0-stable.deb
exit 0




